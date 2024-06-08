//
//  DeleteAccountViewModel.swift
//  TapCoinsApplication.V1
//
//  Created by Eric Viera on 5/8/24.
//

import Foundation
import SwiftUI

final class DeleteAccountViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("debug") private var debug: Bool?
    @Published var delete_pressed:Bool = false
    @Published var password:String = ""
    @Published var pressed_confirm_password:Bool = false
    @Published var confirm_password_error:Bool = false
    @Published var confirmed_current_password:Bool = false
    @Published var deleteAccountError:Bool = false
    
    func confirm_password(){
        pressed_confirm_password = true
        confirm_password_error = false
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/confirm_password"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/confirm_password"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        
        guard let session = logged_in_user else{
            return
        }
        if password == ""{
            pressed_confirm_password = false
            confirm_password_error = true
            return
        }
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "token": session,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(ResponseCP.self, from: data)
                    if response.result{
                        self?.confirmed_current_password = true
                        self?.pressed_confirm_password = false
                    }
                    else{
                        self?.confirm_password_error = true
                        self?.pressed_confirm_password = false
                    }
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    struct ResponseCP:Codable {
        let result:Bool
    }
    
    func deleteAccountTask(){
        Task {
            do {
                delete_pressed = true
                let result:Bool = try await delete_account()
                if result{
                    logged_in_user = nil
                }
                else{
                    print("Something went wrong.")
                    deleteAccountError = true
                }
                delete_pressed = false
            } catch {
                _ = "Error: \(error.localizedDescription)"
                delete_pressed = false
                deleteAccountError = true
            }
        }
    }
    
    func delete_account() async throws -> Bool{
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/delete_account"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/delete_account"
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestBody = "token=" + session
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(DeleteAccountResponse.self, from: data)
            if response.result == "Deleted"{
                return true
            }
            return false
        }
        catch {
            throw PostDataError.invalidData
        }
    }
    
    struct DeleteAccountResponse:Codable {
        let result: String
    }
}
