//
//  ChangePasswordViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class ChangePasswordViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("changing_password") var changing_password: Bool?
    @Published var is_match_error:Bool = false
    @Published var is_password_error:Bool = false
    @Published var submitted:Bool = false
    @Published var is_error = false
    @Published var error:String = ""
    @Published var password:String = ""
    @Published var c_password:String = ""
    @Published var submit_pressed:Bool = false
    private var globalVariables = GlobalVariables()
    
    func changePasswordTask(){
        Task {
            do {
                print("IN SEND CODE TASK")
                DispatchQueue.main.async{
                    self.submit_pressed = true
                    self.is_error = false
                    self.is_match_error = false
                    self.submitted = false
                }
                
                if password != c_password{
                    DispatchQueue.main.async{
                        self.is_match_error = true
                        self.is_password_error = false
                        self.submit_pressed = false
                    }
                    return
                }
                
                if password == "" {
                    DispatchQueue.main.async{
                        self.is_password_error = true
                        self.is_match_error = false
                        self.submit_pressed = false
                    }
                    return
                }
                
                let result:Bool = try await changePassword()
                if !result{
                    print("Something went wrong.")
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.is_error = true
                    self.error = "Something went wrong!"
                }
            }
        }
    }
    
    func changePassword() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        url_string = serverURL + "/tapcoinsapi/user/change_password"
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let userInfo = "&username=" + session + "&password=" + password
        let requestBody = "code=Change_Password" + userInfo
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(Response3.self, from: data)
            if response.response{
                self.submitted = true
                self.submit_pressed = false
                self.changing_password = false
                self.logged_in_user = nil
                return true
            }
            else{
                self.submit_pressed = false
                let errorType = Error_Types.allCases.first(where: { $0.index == response.error_type })
                if errorType == Error_Types.BlankPassword{
                    self.is_error = true
                    self.error = response.message
                }
                if errorType == Error_Types.PreviousPassword{
                    self.is_error = true
                    self.error = response.message
                }
                if errorType == Error_Types.SomethingWentWrong{
                    self.is_error = true
                    self.error = response.message
                }
                return false
            }
        }
        catch {
            throw PostDataError.invalidData
        }
    }
    
    struct Response3:Codable {
        let response: Bool
        let message: String
        let expired: Bool
        let error_type: Int
    }
}
