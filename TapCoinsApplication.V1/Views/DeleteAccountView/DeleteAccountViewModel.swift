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
    @Published var delete_pressed:Bool = false
    @Published var password:String = ""
    @Published var pressed_confirm_password:Bool = false
    @Published var confirm_password_error:Bool = false
    @Published var confirmed_current_password:Bool = false
    @Published var deleteAccountError:Bool = false
    @Published var confirmPasswordErrorMessage:String = ""
    private var globalFunctions = GlobalFunctions()
    private var globalVariables = GlobalVariables()
    
    func confirmPasswordTask(){
        Task {
            do {
                DispatchQueue.main.async{
                    self.pressed_confirm_password = true
                    self.confirm_password_error = false
                }
                if password == ""{
                    DispatchQueue.main.async{
                        self.pressed_confirm_password = false
                        self.confirm_password_error = true
                        self.confirmPasswordErrorMessage = "Invalid Password."
                    }
                    return
                }
                let result:Bool = try await globalFunctions.confirmPassword(password: password)
                if result{
                    DispatchQueue.main.async{
                        self.confirmed_current_password = true
                    }
                }
                else{
                    DispatchQueue.main.async{
                        self.confirm_password_error = true
                        self.confirmPasswordErrorMessage = "Invalid Password."
                    }
                }
                DispatchQueue.main.async{
                    self.pressed_confirm_password = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async{
                    self.pressed_confirm_password = false
                    self.confirmPasswordErrorMessage = "Something went wrong."
                }
            }
        }
    }
    
    func deleteAccountTask(){
        Task {
            do {
                DispatchQueue.main.async{
                    self.delete_pressed = true
                }
                let result:Bool = try await delete_account()
                if result{
                    DispatchQueue.main.async{
                        self.logged_in_user = nil
                    }
                }
                else{
                    print("Something went wrong.")
                    DispatchQueue.main.async{
                        self.deleteAccountError = true
                    }
                }
                DispatchQueue.main.async{
                    self.delete_pressed = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async{
                    self.delete_pressed = false
                    self.deleteAccountError = true
                }
            }
        }
    }
    
    func delete_account() async throws -> Bool{
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        url_string = serverURL + "/tapcoinsapi/user/delete_account"
        
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
