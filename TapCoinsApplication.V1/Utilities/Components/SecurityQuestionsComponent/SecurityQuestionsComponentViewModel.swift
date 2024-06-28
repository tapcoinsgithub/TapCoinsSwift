//
//  SecurityQuestionsComponentViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI
final class SecurityQuestionsComponentViewModel: ObservableObject {
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("show_security_questions") var show_security_questions:Bool?
    @AppStorage("user") private var userViewModel: Data?
    @Published var userModel: UserViewModel = UserViewModel(first_name: "NO FIRST NAME", last_name: "NO LAST NAME")
    @Published var answer_1:String = ""
    @Published var answer_2:String = ""
    @Published var password:String = ""
    @Published var question_1:Int = 0
    @Published var question_2:Int = 0
    @Published var got_security_questions:Bool = false
    @Published var confirmed_password:Bool = false
    @Published var pressed_check_and_set_sqs:Bool = false
    @Published var pressed_confirm_password:Bool = false
    @Published var is_loading:Bool = false
    @Published var password_error:Bool = false
    @Published var saved_questions_answers:Bool = false
    @Published var passwordErrorMessage:String = ""
    @Published var saveQAError:Bool = false
    public var options1:[String] = ["Loading ..."]
    public var options2:[String] = ["Loading ..."]
    private var globalFunctions = GlobalFunctions()
    
    init(){
        DispatchQueue.main.async {
            let convertedData = UserViewModel(self.userViewModel ?? Data())
            self.userModel = convertedData ?? UserViewModel(first_name: "NO FIRST NAME", last_name: "NO LAST NAME")
            self.getSecurityQuestionsTextTask()
        }
    }
    
    func saveQuestionsAndAnswersTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.saveQAError = false
                }
                let result:Bool = try await saveQuestionsAndAnswers()
                if !result{
                    print("HERE!!!")
                    print("Something went wrong.")
                    DispatchQueue.main.async {
                        self.saveQAError = true
                    }
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.saveQAError = true
                }
            }
        }
    }
    
    func saveQuestionsAndAnswers() async throws -> Bool{
        
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/securityquestions/save_users_security_questions"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://www.tapcoinsgameqa.com/tapcoinsapi/securityquestions/save_users_security_questions"
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let qa_1 = "&question_1=" + options1[question_1] + "&answer_1=" + answer_1
        let qa_2 = "&question_2=" + options2[question_2] + "&answer_2=" + answer_2
        let requestBody = "token=" + session + qa_1 + qa_2
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            _ = try JSONDecoder().decode(Save_SQ_Response.self, from: data)
            DispatchQueue.main.async {
                self.show_security_questions = false
                self.pressed_check_and_set_sqs = false
                self.is_loading = false
                self.saved_questions_answers = true
            }
            return true
        }
        catch {
            throw PostDataError.invalidData
        }
    }
    
    struct Save_SQ_Response:Codable{
        let result:String
    }
    
    func check_and_set_sqs(){
        DispatchQueue.main.async {
            self.pressed_check_and_set_sqs = true
            self.is_loading = true
        }
        if question_1 == 0 {
            DispatchQueue.main.async {
                self.pressed_check_and_set_sqs = false
                self.is_loading = false
            }
            return
        }
        if answer_1 == "" {
            DispatchQueue.main.async {
                self.pressed_check_and_set_sqs = false
                self.is_loading = false
            }
            return
        }
        if question_2 == 0{
            DispatchQueue.main.async {
                self.pressed_check_and_set_sqs = false
                self.is_loading = false
            }
            return
        }
        if answer_2 == ""{
            DispatchQueue.main.async {
                self.pressed_check_and_set_sqs = false
                self.is_loading = false
            }
            return
        }
        saveQuestionsAndAnswersTask()
    }
    
    func getSecurityQuestionsTextTask(){
        Task {
            do {
                
                let result:Bool = try await getSecurityQuestionsText()
                if !result{
                    print("HERE$$$")
                    print("Something went wrong.")
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    func getSecurityQuestionsText() async throws -> Bool{
        
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/securityquestions/get_security_questions_text"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://www.tapcoinsgameqa.com/tapcoinsapi/securityquestions/get_security_questions_text"
        }
        
        guard var urlComponents = URLComponents(string: url_string) else {
            throw PostDataError.invalidURL
        }
        
        // Ensure the URL is valid
        guard let url = urlComponents.url else {
            throw PostDataError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(SecurityQResponse.self, from: data)
            DispatchQueue.main.async {
                self.options1 = response.options_1
                self.options2 = response.options_2
                print("OPTIONS 1 BELOW")
                print(response.options_1)
                self.got_security_questions = true
            }
            return true
        }
        catch{
            print(error)
            return false
        }
    }
    
    struct SecurityQResponse:Codable {
        let options_1: [String]
        let options_2: [String]
    }
    
    func getUsersQuestionsAndAnswersTask(){
        Task {
            do {
                
                let result:Bool = try await getUsersQuestionsAndAnswers()
                if !result{
                    print("HERE???")
                    print("Something went wrong.")
                    DispatchQueue.main.async {
                        self.question_1 = 0
                        self.question_2 = 0
                        self.answer_1 = ""
                        self.answer_2 = ""
                    }
                }
                DispatchQueue.main.async {
                    self.got_security_questions = true
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.question_1 = 0
                    self.question_2 = 0
                    self.answer_1 = ""
                    self.answer_2 = ""
                    self.got_security_questions = true
                }
            }
        }
    }
    
    func getUsersQuestionsAndAnswers() async throws -> Bool{
        
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/securityquestions/get_users_questions_answers"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://www.tapcoinsgameqa.com/tapcoinsapi/securityquestions/get_users_questions_answers"
        }
        
        guard var urlComponents = URLComponents(string: url_string) else {
            throw PostDataError.invalidURL
        }
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        // Add query parameters to the URL
        urlComponents.queryItems = [
            URLQueryItem(name: "token", value: session)
        ]
        
        // Ensure the URL is valid
        guard let url = urlComponents.url else {
            throw PostDataError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(ResponseSQA.self, from: data)
            if response.result == "Success"{
                DispatchQueue.main.async {
                    self.question_1 = self.options1.firstIndex(of: response.question_1) ?? 0
                    self.question_2 = self.options2.firstIndex(of: response.question_2) ?? 0
                    self.answer_1 = response.answer_1
                    self.answer_2 = response.answer_2
                }
            }
            else if response.result == "No QAs" {
                return true
            }
            else{
                return false
            }
            return true
        }
        catch{
            return false
        }
    }
    struct ResponseSQA:Codable {
        let result:String
        let question_1:String
        let question_2:String
        let answer_1:String
        let answer_2:String
    }
    
    func confirmPasswordTask(){
        Task {
            do {
                DispatchQueue.main.async{
                    self.pressed_confirm_password = true
                    self.is_loading = true
                    self.password_error = false
                }
                if password == ""{
                    DispatchQueue.main.async{
                        self.pressed_confirm_password = false
                        self.is_loading = false
                        self.password_error = true
                        self.passwordErrorMessage = "Invalid Password."
                    }
                    return
                }
                let result:Bool = try await globalFunctions.confirmPassword(password: password)
                if result{
                    DispatchQueue.main.async{
                        self.confirmed_password = true
                        if self.userModel.has_security_questions ?? false{
                            self.got_security_questions = false
                            self.getUsersQuestionsAndAnswersTask()
                        }
                    }
                }
                else{
                    DispatchQueue.main.async{
                        self.password_error = true
                        self.passwordErrorMessage = "Invalid Password."
                    }
                }
                DispatchQueue.main.async{
                    self.pressed_confirm_password = false
                    self.is_loading = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async{
                    self.pressed_confirm_password = false
                    self.is_loading = false
                    self.password_error = true
                    self.passwordErrorMessage = "Something went wrong."
                }
            }
        }
    }
}
