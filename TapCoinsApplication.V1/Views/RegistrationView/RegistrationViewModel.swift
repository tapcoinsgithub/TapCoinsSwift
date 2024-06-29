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
    
    func registerTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.phone_info = false
                    self.reg_pressed = true
                    self.is_phone_error = false
                    self.is_uName_error = false
                    self.is_password_error = false
                    self.register_error = false
                }
                
                DispatchQueue.main.async {
                    if self.check_errors_function(state: Error_States.Required, _phone_number: "", uName: self.username, p1: self.password, p2:self.confirm_password) == false{
                        return
                    }
                    if self.check_errors_function(state: Error_States.Password_Match, _phone_number: "",  uName: self.username, p1: self.password, p2:self.confirm_password) == false{
                        return
                    }
                }
                
                let result:Bool = try await register()
                if result{
                    print("SUCCESS")
                }
                else{
                    print("Something went wrong.")
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    func register() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = ProcessInfo.processInfo.environment["API_URL"] ?? "None"
        if serverURL == "None"{
            print("SERVER URL IS NONE")
            return false
        }
        else{
            print("GOT THE SERVER URL")
            url_string = serverURL + "/tapcoinsapi/user/register"
        }
        
        guard let url = URL(string: url_string) else{
            DispatchQueue.main.async {
                self.reg_pressed = false
                self.username = ""
                self.password = ""
                self.confirm_password = ""
                self.register_error_string = "Something went wrong."
                self.register_error = true
            }
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let names = "first_name=" + first_name + "&last_name=" + last_name
        let _data = "&username=" + username + "&password=" + password
        let requestBody = names + _data
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            DispatchQueue.main.async {
                self.reg_pressed = false
                self.username = ""
                self.password = ""
                self.confirm_password = ""
                self.register_error_string = "Something went wrong."
                self.register_error = true
            }
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(Response.self, from: data)
            if response.response == "Success"{
                DispatchQueue.main.async {
                    self.logged_in_user = response.token
                }
                return true
            }
            else if response.response == "Invalid phone number."{
                DispatchQueue.main.async {
                    self.phone_error = Error_States.Invalid_Phone_Number
                    self.is_phone_error = true
                    self.reg_pressed = false
                }
                return false
            }
        }
        catch{
            do {
                let response2 = try JSONDecoder().decode(ErrResponse.self, from: data)
                if response2.isErr == true{
                    DispatchQueue.main.async {
                        self.register_error_string = response2.error
                        self.register_error = true
                        self.reg_pressed = false
                    }
                    return false
                }
                else {
                    DispatchQueue.main.async {
                        self.is_phone_error = false
                        self.is_uName_error = false
                        self.is_password_error = false
                    }
                    return true
                }
            }
            catch{
                DispatchQueue.main.async {
                    self.reg_pressed = false
                    self.username = ""
                    self.password = ""
                    self.confirm_password = ""
                    self.register_error_string = "Something went wrong."
                    self.register_error = true
                }
                throw PostDataError.invalidData
            }
        }
        return false
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
