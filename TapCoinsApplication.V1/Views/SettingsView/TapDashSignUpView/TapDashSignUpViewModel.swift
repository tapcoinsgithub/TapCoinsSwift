//
//  TapDashSignUpViewModel.swift
//  TapCoinsApplication.V1
//
//  Created by Eric Viera on 6/28/24.
//

import Foundation
import Foundation
import SwiftUI

final class TapDashSignUpViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("haptics") var haptics_on:Bool?
    @Published var is_error:Bool = false
    @Published var signUpPressed:Bool = false
    @Published var tocIsChecked:Bool = false
    @Published var ppIsChecked:Bool = false
    private var globalFunctions = GlobalFunctions()
    private var globalVariables = GlobalVariables()
    
    func signUpTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.signUpPressed = true
                }
                let result = try await signUp()
                if result {
                    print("SUCCESS")
                    DispatchQueue.main.async {
                        self.globalFunctions.getAllUserInfoTask()
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.is_error = true
                        self.signUpPressed = false
                    }
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.signUpPressed = true
                    self.is_error = true
                }
            }
        }
    }
    
    func signUp() async throws -> Bool{
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        url_string = serverURL + "/tapcoinsapi/user/sign_up"
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "token=" + session + "&tocIsChecked=" + String(tocIsChecked)
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(Response.self, from: data)
            if response.response == "Success"{
                return true
            }
            return false
        }
        catch{
            print(error)
            return false
        }
    }
    
    struct Response:Codable {
        let response: String
    }
}
