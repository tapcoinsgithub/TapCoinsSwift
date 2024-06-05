//
//  RegistrationViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class RegistrationViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("show_security_questions") var show_security_questions:Bool?
    @Published var first_name:String = ""
    @Published var last_name:String = ""
    @Published var username:String = ""
    @Published var password:String = ""
    @Published var confirm_password:String = ""
    @Published var first_name_error:Error_States?
    @Published var last_name_error:Error_States?
    @Published var username_error:Error_States?
    @Published var phone_error:Error_States?
    @Published var password_error:Error_States?
    @Published var is_fName_error:Bool = false
    @Published var is_lName_error:Bool = false
    @Published var is_phone_error:Bool = false
    @Published var is_uName_error:Bool = false
    @Published var is_password_error:Bool = false
    @Published var reg_pressed:Bool = false
    @Published var phone_info:Bool = false
    @Published var register_error:Bool = false
    @Published var register_error_string:String = ""
    private var globalFunctions = GlobalFunctions()
    
    func register(){
        phone_info = false
        reg_pressed = true
        is_phone_error = false
        is_uName_error = false
        is_password_error = false
        self.register_error = false
        if check_errors_function(state: Error_States.Required, _phone_number: "", uName: username, p1: password, p2:confirm_password) == false{
            return
        }
        if check_errors_function(state: Error_States.Password_Match, _phone_number: "",  uName: username, p1: password, p2:confirm_password) == false{
            return
        }
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/register"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/register"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "first_name":first_name,
            "last_name":last_name,
            "username":username,
            "password":password,
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }

            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    if response.response == "Success"{
                        self?.logged_in_user = response.token
                        self?.show_security_questions = true
                    }
                    else if response.response == "Invalid phone number."{
                        self?.phone_error = Error_States.Invalid_Phone_Number
                        self?.is_phone_error = true
                        self?.reg_pressed = false
                    }
                }
                catch{
                    do {
                        let response2 = try JSONDecoder().decode(ErrResponse.self, from: data)
                        if response2.isErr == true{
                            self?.register_error_string = response2.error
                            self?.register_error = true
                            self?.reg_pressed = false
                            return
                        }
                        else {
                            self?.is_phone_error = false
                            self?.is_uName_error = false
                            self?.is_password_error = false
                        }
                    }
                    catch{
                        self?.reg_pressed = false
                        self?.username = ""
                        self?.password = ""
                        self?.confirm_password = ""
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
    
    struct ErrResponse:Codable {
        let error:String
        let isErr:Bool
    }
    
    func check_errors_function(state:Error_States, _phone_number:String, uName:String, p1:String, p2:String) -> Bool{
        let result = globalFunctions.check_errors(state: state, _phone_number: "", uName: uName, p1: p1, p2:p2, _email_address: "")
        
        if (result == "Required"){
            is_uName_error = true
            is_password_error = true
            username_error = Error_States.Required
            password_error = Error_States.Required
            reg_pressed = false
            return false
        }
        else if (result == "Invalid_Username"){
            is_uName_error = true
            username_error = Error_States.Invalid_Username
            reg_pressed = false
            return false
        }
        else if (result == "PMError"){
            password_error = Error_States.Password_Match
            is_password_error = true
            reg_pressed = false
            return false
        }
        else if(result == "PHError"){
            phone_error = Error_States.Invalid_Phone_Number
            is_phone_error = true
            reg_pressed = false
            return false
        }
        return true
    }
}
