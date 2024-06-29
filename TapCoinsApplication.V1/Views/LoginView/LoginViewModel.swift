//
//  LoginViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class LoginViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @Published var username:String = ""
    @Published var password:String = ""
    @Published var is_error:Bool = false
    @Published var log_pressed:Bool = false
    @Published var user_error:Error_States?
    @Published var password_error:Error_States?
    private var globalFunctions = GlobalFunctions()
    
    func loginTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.is_error = false
                    self.log_pressed = true
                    if self.check_errors_function(state: Error_States.RequiredLogin, user:self.username, password:self.password) == false{
                        return
                    }
                }
                
                let result:Bool = try await login()
                if result{
                    print("SUCCESS")
                }
                else{
                    print("Something went wrong.")
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.log_pressed = false
                    self.is_error = true
                    self.user_error = nil
                    self.password_error = nil
                }
                
            }
        }
    }
    
    func login() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = ProcessInfo.processInfo.environment["API_URL"] ?? "None"
        if serverURL == "None"{
            print("SERVER URL IS NONE")
            return false
        }
        else{
            print("GOT THE SERVER URL")
            url_string = serverURL + "/tapcoinsapi/user/login"
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "username=" + username + "&password=" + password
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        DispatchQueue.main.async {
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                self.logged_in_user = response.token
            }
            catch{
                do{
                    let response2 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    let error_dict: NSDictionary = response2 as? NSDictionary ?? [
                        "user" : "No user",
                        "password" : "No password",
                    ]
                    let user_error = error_dict["user"] as? String ?? ""
                    let password_error = error_dict["password"] as? String ?? ""

                    if user_error.count > 0{
                        if self.check_errors_function(state: Error_States.No_Match_User, user:user_error, password:password_error) == false{
                            return
                        }
                        else {
                            self.is_error = false
                        }
                    }
                    else{
                        if self.check_errors_function(state: Error_States.No_Match_Password, user:user_error, password:password_error) == false{
                            return
                        }
                        else{
                            self.is_error = false
                        }
                    }
                }
                catch{
                    print(error)
                    self.log_pressed = false
                    self.is_error = true
                    self.user_error = nil
                    self.password_error = nil
                }
            }
        }
        return true
    }
    
    struct Response:Codable {
        let response: String
        let token: String
        let username: String
    }
    
    func check_errors_function(state:Error_States, user:String, password:String) -> Bool{
        let result = globalFunctions.check_errors(state: state, _phone_number: "", uName: user, p1: password, p2:"", _email_address: "")
        
        if (result == "RequiredLogin"){
            is_error = true
            log_pressed = false
            user_error = Error_States.Required
            password_error = Error_States.Required
            return false
        }
        else if (result == "NMUError"){
            is_error = true
            log_pressed = false
            user_error = Error_States.No_Match_User
            password_error = Error_States.No_Match_Password
            return false
        }
        else if (result == "NMP"){
            log_pressed = false
            is_error = true
            user_error = Error_States.No_Match_User
            password_error = Error_States.No_Match_Password
            return false
        }
        return true
    }
    
}
