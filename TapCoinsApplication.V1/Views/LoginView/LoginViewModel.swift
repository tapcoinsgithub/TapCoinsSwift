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
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("show_security_questions") var show_security_questions:Bool?
    @Published var username:String = ""
    @Published var password:String = ""
    @Published var is_error:Bool = false
    @Published var log_pressed:Bool = false
    @Published var user_error:Error_States?
    @Published var password_error:Error_States?
    private var globalFunctions = GlobalFunctions()
    
    func login(){
        is_error = false
        log_pressed = true
        if check_errors_function(state: Error_States.RequiredLogin, user:username, password:password) == false{
            return
        }
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/login"
        }
        else{
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/login"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username":username,
            "password":password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    self?.logged_in_user = response.token
                    self?.show_security_questions = false
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
                            if self?.check_errors_function(state: Error_States.No_Match_User, user:user_error, password:password_error) == false{
                                return
                            }
                            else {
                                self?.is_error = false
                            }
                        }
                        else{
                            if self?.check_errors_function(state: Error_States.No_Match_Password, user:user_error, password:password_error) == false{
                                return
                            }
                            else{
                                self?.is_error = false
                            }
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            }
        })
        task.resume()
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
