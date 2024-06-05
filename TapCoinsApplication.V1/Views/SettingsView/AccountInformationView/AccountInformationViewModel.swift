//
//  AccountInformationViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class AccountInformationViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("de_queue") private var de_queue: Bool?
    @AppStorage("selectedOption1") var selectedOption1:Int?
    @AppStorage("selectedOption2") var selectedOption2:Int?
    @AppStorage("loadedUser") var loaded_get_user:Bool?
    @AppStorage("show_security_questions") var show_security_questions:Bool?
    @AppStorage("gsave_pressed") var gsave_pressed:Bool?
    @Published var first_name:String = ""
    @Published var last_name:String = ""
    @Published var username:String = ""
    @Published var phone_number:String = ""
    @Published var email_address:String = ""
    @Published var password:String = ""
    @Published var cpassword:String = ""
    @Published var message:String = ""
    @Published var error:String = ""
    @Published var code:String = ""
    @Published var username_error:Error_States?
    @Published var phone_error:Error_States?
    @Published var email_error:Error_States?
    @Published var password_error:Error_States?
    @Published var is_phone_error:Bool = false
    @Published var is_email_error:Bool = false
    @Published var is_uName_error:Bool = false
    @Published var is_match_error:Bool = false
    @Published var is_password_error:Bool = false
    @Published var is_error:Bool = false
    @Published var is_guest:Bool = false
    @Published var save_pressed:Bool = false
    @Published var save_p_pressed:Bool = false
    @Published var show_code_screen:Bool = false
    @Published var show_text_code:Bool = false
    @Published var show_email_code:Bool = false
    @Published var saved:Bool = false
    @Published var psaved:Bool = false
    @Published var show_guest_message:Bool = false
    @Published var _answerHere:String = "Your answer here"
    @Published var _is_pressed: Bool = false
    @Published var _index_pressed:Bool = false
    @Published var confirmed_current_password:Bool = false
    @Published var pressed_confirm_password:Bool = false
    @Published var confirm_password_error:Bool = false
    @Published var send_code_pressed:Bool = false
    @Published var successfully_sent_code:Bool = false
    @Published var confirm_code_message:String = ""
    @Published var saved_phone_number:Bool = false
    private var userData:UserViewModel?
    public var options1:[String] = ["Option1", "Option2", "Option3", "Option4"]
    public var options2:[String] = ["Option5", "Option6", "Option7", "Option8"]
    @Published var set_page_data:Bool = false
    private var globalFunctions = GlobalFunctions()
    private var current_username:String = ""
    private var initialFirstName:String = ""
    private var initialLastName:String = ""
    private var initialPhoneNumber:String = ""
    private var initialUserName:String = ""
    private var initialEmailAddress:String = ""
    
    init(){
        self.userData = UserViewModel(self.userViewModel ?? Data())
        self.current_username = self.userData?.username ?? "None"
        self.setPageData(usersData: self.userData!)
        self.is_guest = self.userData?.is_guest ?? false
    }
    
    func setPageData(usersData:UserViewModel){
        username = userData?.username ?? "No username"
        first_name = userData?.first_name ?? "No First Name"
        last_name = userData?.last_name ?? "No Last Name"
        
        initialFirstName = first_name
        initialLastName = last_name
        initialUserName = username
        if userData?.hasPhoneNumber ?? false{
            phone_number = userData?.phone_number ?? ""
            initialPhoneNumber = phone_number
        }
        else{
            phone_number = ""
            initialPhoneNumber = ""
        }
        if userData?.hasEmailAddress ?? false {
            email_address = userData?.email_address ?? ""
            initialEmailAddress = email_address
        }
        else{
            email_address = ""
            initialEmailAddress = ""
        }
        set_page_data = true
    }
    
    func checkValuesChanged() -> Bool{
        print("CHECKING VALUES HAVE CHANGED")
        if userData?.is_guest ?? false{
            if initialUserName != username{
                return true
            }
        }
        else{
            if initialFirstName != first_name{
                return true
            }
            if initialLastName != last_name{
                return true
            }
            if initialPhoneNumber != phone_number{
                return true
            }
            if initialUserName != username{
                return true
            }
            if initialEmailAddress != email_address{
                return true
            }
        }
        print("NO VALUES CHANGED")
        return false
    }
    
    func saveTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.save_pressed = true
                    self.gsave_pressed = true
                    self.show_guest_message = false
                    self.saved = false
                    self.is_phone_error = false
                    self.is_uName_error = false
                }
                if checkValuesChanged() == false{
                    DispatchQueue.main.async {
                        self.save_pressed = false
                        self.gsave_pressed = false
                    }
                    return
                }
                if check_errors_function(state: Error_States.Required, _phone_number: phone_number, uName: username, _email_address: email_address) == false{
                    DispatchQueue.main.async {
                        self.save_pressed = false
                        self.gsave_pressed = false
                    }
                    return
                }
                if phone_number != ""{
                    if check_errors_function(state: Error_States.Invalid_Phone_Number, _phone_number: phone_number, uName: username, _email_address: self.email_address) == false{
                        DispatchQueue.main.async {
                            self.save_pressed = false
                            self.gsave_pressed = false
                        }
                        return
                    }
                }
                if email_address != "" {
                    if check_errors_function(state: Error_States.Invalid_Email_Address, _phone_number: phone_number, uName: username, _email_address: email_address) == false{
                        DispatchQueue.main.async {
                            self.save_pressed = false
                            self.gsave_pressed = false
                        }
                        return
                    }
                }
                let result:Bool = try await save()
                if !result{
                    print("Something went wrong.")
                }
                else{
                    print("SUCCESS")
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    func save() async throws -> Bool{
        
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/save"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/save"
        }
        
        guard let session = logged_in_user else {
            DispatchQueue.main.async {
                self.is_error = true
                self.error = "Something went wrong."
                self.save_pressed = false
            }
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            DispatchQueue.main.async {
                self.is_error = true
                self.error = "Something went wrong."
                self.save_pressed = false
            }
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var changed_username:Bool = false
        if (self.current_username != self.username){
            changed_username = true
        }
        let name_values = "first_name=" + first_name + "&last_name=" + last_name
        let contact_info = "&phone_number=" + phone_number + "&email_address=" + email_address
        let other_values = "&username=" + username + "&token=" + session
        let bool_values = "&guest=" + String(is_guest) + "&changed_username=" + String(changed_username)
        
        let requestBody = name_values + contact_info + other_values + bool_values
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            DispatchQueue.main.async {
                self.is_error = true
                self.error = "Something went wrong."
                self.save_pressed = false
            }
            throw PostDataError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(Response2.self, from: data)
            if response.response == "Invalid username."{
                if self.check_errors_function(state: Error_States.Invalid_Username, _phone_number: self.phone_number, uName: self.username, _email_address: self.email_address) == false{
                    DispatchQueue.main.async {
                        self.save_pressed = false
                        self.gsave_pressed = false
                    }
                }
            }
            else if response.response == "Successfully saved data."{
                DispatchQueue.main.async {
                    self.saved = true
                    self.save_pressed = false
                    self.gsave_pressed = false
                    self.message = "Successfully saved data."
                    self.is_phone_error = false
                    self.is_uName_error = false
                }
            }
            else if response.response == "Guest"{
                DispatchQueue.main.async {
                    self.saved = true
                    self.save_pressed = false
                    self.message = "Successfully saved data. You are still a guest, create a password to save your account"
                    self.is_phone_error = false
                    self.is_uName_error = false
                    self.show_guest_message = true
                }
            }
            if response.sent_text_code == 0{
                DispatchQueue.main.async {
                    self.show_code_screen = true
                    self.show_text_code = true
                    self.show_email_code = false
                    self.confirm_code_message = "A code has been sent to \(self.phone_number). Please input the code to confirm your phone number."
                    if response.sent_email_code == 0{
                        self.show_email_code = true
                    }
                }
            }
            else if response.sent_email_code == 0{
                DispatchQueue.main.async {
                    self.confirm_code_message = "A code has been sent to \(self.email_address). Please input the code to confirm your email address."
                    self.show_code_screen = true
                    self.show_email_code = true
                }
            }
            else{
                self.loaded_get_user = false
                DispatchQueue.main.async { [weak self] in
                    self?.globalFunctions.getUser(token:self?.logged_in_user ?? "None", this_user:nil, curr_user:nil)
                }
                DispatchQueue.main.async { [weak self] in
                    self?.userData = UserViewModel(self?.userViewModel ?? Data())
                    self?.setPageData(usersData: (self?.userData)!)
                }
            }
            print("RETURNING TRUE")
            return true
        }
        catch {
            print("IN THE CATCH BLOCK")
            DispatchQueue.main.async {
                self.is_error = true
                self.error = "Something went wrong."
                self.save_pressed = false
            }
            throw PostDataError.invalidData
        }
    }
    
    func check_errors_function(state:Error_States, _phone_number:String, uName:String, _email_address:String) -> Bool{
        let result = globalFunctions.check_errors(state: state, _phone_number: _phone_number, uName: uName, p1: "", p2:"", _email_address: _email_address)
        if (result == "Required"){
            is_uName_error = true
            username_error = Error_States.Required
            save_pressed = false
            return false
        }
        else if (result == "Invalid_Username"){
            is_uName_error = true
            username_error = Error_States.Invalid_Username
            save_pressed = false
            return false
        }
        else if (result == "PHError"){
            phone_error = Error_States.Invalid_Phone_Number
            is_phone_error = true
            save_pressed = false
            return false
        }
        else if (result == "EAError"){
            email_error = Error_States.Invalid_Email_Address
            is_email_error = true
            save_pressed = false
            return false
        }
        return true
    }
    
    struct Response2:Codable {
        let response: String
        let sent_text_code: Int
        let sent_email_code: Int
    }
    
    func savePasswordTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.save_p_pressed = true
                    self.is_match_error = false
                    self.is_error = false
                    self.psaved = false
                }
                if password != cpassword{
                    DispatchQueue.main.async {
                        self.is_match_error = true
                        self.is_password_error = false
                        self.save_p_pressed = false
                    }
                    return
                }
                
                if password == ""{
                    DispatchQueue.main.async {
                        self.is_password_error = true
                        self.is_match_error = false
                        self.save_p_pressed = false
                    }
                    return
                }
                
                let result:Bool = try await save_password()
                if result{
                    DispatchQueue.main.async {
                        self.psaved = true
                        self.save_p_pressed = false
                        self.userData?.is_guest = false
                        self.userViewModel = self.userData?.storageValue
                    }
                }
                else{
                    print("Something went wrong.")
                    DispatchQueue.main.async {
                        self.save_p_pressed = false
                    }
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    func save_password() async throws -> Bool{
        
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/change_password"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/change_password"
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestBody = "code=SAVE&password=" + password + "&token=" + session
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(Response3.self, from: data)
            if response.response{
                return true
            }
            else{
                let errorType = Error_Types.allCases.first(where: { $0.index == response.error_type })
                if errorType == Error_Types.BlankPassword{
                    DispatchQueue.main.async {
                        self.is_error = true
                        self.error = "Password can't be blank."
                    }
                }
                if errorType == Error_Types.PreviousPassword{
                    DispatchQueue.main.async {
                        self.is_error = true
                        self.error = "Password can't be previous password."
                    }
                }
                if errorType == Error_Types.SomethingWentWrong{
                    DispatchQueue.main.async {
                        self.is_error = true
                        self.error = "Something went wrong."
                    }
                }
                if errorType == Error_Types.TimeLimitCode{
                    DispatchQueue.main.async {
                        self.is_error = true
                        self.error = "Invalid code."
                    }
                }
                return false
            }
        }
        catch {
            DispatchQueue.main.async {
                self.is_error = true
                self.error = "Something went wrong!"
            }
            throw PostDataError.invalidData
        }
    }
    
    struct Response3:Codable {
        let response: Bool
        let message: String
        let error_type: Int
    }
    
    func confirm_password(){
        pressed_confirm_password = true
        save_p_pressed = true
        confirm_password_error = false
        var url_string:String = ""
        
        if debug ?? true{
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
            save_p_pressed = false
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
                        self?.pressed_confirm_password = false
                        self?.save_p_pressed = false
                        self?.confirmed_current_password = true
                    }
                    else{
                        self?.confirm_password_error = true
                        self?.pressed_confirm_password = false
                        self?.save_p_pressed = false
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
    
    func sendCodeTask(){
        Task {
            do {
                send_code_pressed = true
                successfully_sent_code = false
                let result:Bool = try await send_code()
                if !result{
                    print("Something went wrong.")
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    func send_code() async throws -> Bool{
        print("IN THE SEND CODE FUNCTION")
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/send_code"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/send_code"
        }
        
        guard let session = logged_in_user else {
            DispatchQueue.main.async{
                self.send_code_pressed = false
                self.is_error = true
                self.error = "Something went wrong."
            }
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            DispatchQueue.main.async{
                self.send_code_pressed = false
                self.is_error = true
                self.error = "Something went wrong."
            }
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let token = "token=" + session
        let contact_info = "&phone_number=" + phone_number + "&email_address=" + email_address
        let bool_values = "&is_phone=" + (show_text_code ? "Yes" : "No") + "&is_email=" + (show_email_code ? "Yes" : "No")
        let requestBody = token + contact_info + bool_values
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            DispatchQueue.main.async{
                self.send_code_pressed = false
                self.is_error = true
                self.error = "Something went wrong."
            }
            throw PostDataError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(Response.self, from: data)
            if response.response{
                DispatchQueue.main.async {
                    self.successfully_sent_code = true
                    self.send_code_pressed = false
                }
                return true
            }
            else{
                DispatchQueue.main.async {
                    self.send_code_pressed = false
                    self.is_error = true
                    self.error = "Could not send code."
                }
                return false
            }
        }
        catch {
            DispatchQueue.main.async {
                self.is_error = true
                self.error = "Something went wrong."
                self.send_code_pressed = false
            }
            throw PostDataError.invalidData
        }
    }
    
    struct Response:Codable {
        let response: Bool
    }
    
    func confirmCodeTask(){
        Task {
            do {
                send_code_pressed = true
                is_error = false
                if code == ""{
                    is_error = true
                    error = "Invalid code"
                    return
                }
                let result:Bool = try await confirm_code()
                if !result{
                    print("Something went wrong.")
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    func confirm_code() async throws -> Bool {
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/confirm_code"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/confirm_code"
        }
        
        guard let session = logged_in_user else {
            DispatchQueue.main.async{
                self.send_code_pressed = false
                self.is_error = true
                self.error = "Something went wrong."
            }
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            DispatchQueue.main.async{
                self.send_code_pressed = false
                self.is_error = true
                self.error = "Something went wrong."
            }
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // set body variable for if it is confirming phone number or email code
        let code_token = "code=" + code + "&token=" + session
        let phone_email = "&phone_number=" + phone_number + "&email_address=" + email_address
        let bool_values = "&is_phone=" + (show_text_code ? "Yes" : "No") + "&is_email=" + (show_email_code ? "Yes" : "No")
        let requestBody = code_token + phone_email + bool_values
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            DispatchQueue.main.async{
                self.send_code_pressed = false
                self.is_error = true
                self.error = "Something went wrong."
            }
            throw PostDataError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(ConfirmCodeResponse.self, from: data)
            if response.response{
                DispatchQueue.main.async {
                    // check if still has to confirm email code after text code or not.
                    if self.show_email_code {
                        if response.sent_email_code == 0{
                            DispatchQueue.main.async {
                                self.confirm_code_message = "A code has been sent to \(self.email_address). Please input the code to confirm your email address."
                                self.show_text_code = false
                                self.saved_phone_number = true
                            }
                        }
                        else if response.sent_email_code == 1{
                            DispatchQueue.main.async {
                                self.confirm_code_message = "Something went wrong sending a confirmation code to the email you input. Please save your email again."
                                self.show_text_code = false
                                self.saved_phone_number = true
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                self.show_code_screen = false
                                self.show_text_code = false
                                self.show_email_code = false
                                self.loaded_get_user = false
                            }
                            DispatchQueue.main.async { [weak self] in
                                self?.globalFunctions.getUser(token:self?.logged_in_user ?? "None", this_user:nil, curr_user:nil)
                            }
                            DispatchQueue.main.async { [weak self] in
                                self?.userData = UserViewModel(self?.userViewModel ?? Data())
                                self?.setPageData(usersData: (self?.userData)!)
                            }
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            self.show_code_screen = false
                            self.show_text_code = false
                            self.show_email_code = false
                            self.loaded_get_user = false
                            self.send_code_pressed = false
                        }
                        DispatchQueue.main.async { [weak self] in
                            self?.globalFunctions.getUser(token:self?.logged_in_user ?? "None", this_user:nil, curr_user:nil)
                        }
                        DispatchQueue.main.async { [weak self] in
                            self?.userData = UserViewModel(self?.userViewModel ?? Data())
                            self?.setPageData(usersData: (self?.userData)!)
                        }
                    }
                }
                return true
            }
            else{
                DispatchQueue.main.async {
                    self.send_code_pressed = false
                    self.is_error = true
                    self.error = response.message
                }
                return false
            }
        }
        catch {
            DispatchQueue.main.async {
                self.is_error = true
                self.error = "Something went wrong."
                self.send_code_pressed = false
            }
            throw PostDataError.invalidData
        }
    }

    struct ConfirmCodeResponse:Codable {
        let response: Bool
        let message: String
        let sent_email_code: Int
    }
}
