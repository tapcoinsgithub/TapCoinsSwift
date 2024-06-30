//
//  SecurityQuestionsViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class SecurityQuestionsViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("changing_password") private var changing_password: Bool?
    @Published var answer_1:String = ""
    @Published var answer_2:String = ""
    @Published var _username:String = ""
    @Published var username_sent:Bool = false
    @Published var valid_userename:Bool = false
    @Published var submit_pressed:Bool = false
    @Published var question_1:String = ""
    @Published var question_2:String = ""
    @Published var correct_answers:Bool = false
    @Published var incorrect_answers_errors:Bool = false
    @Published var password:String = ""
    @Published var c_password:String = ""
    @Published var is_match_error:Bool = false
    @Published var is_password_error:Bool = false
    @Published var submitted:Bool = false
    @Published var is_error = false
    @Published var username_error:String = ""
    private var globalVariables = GlobalVariables()
    
    func checkIfUserHasQuestionsTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.username_sent = true
                    self.submit_pressed = true
                    self.is_error = false
                }
                let result:Bool = try await checkIfUserHasQuestions()
                if result{
                    print("Success")
                }
                else{
                    print("Something went wrong.")
                    DispatchQueue.main.async {
                        self.is_error = true
                        self.username_error = "Invalid username."
                    }
                }
                DispatchQueue.main.async {
                    self.submit_pressed = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.submit_pressed = false
                    self.is_error = true
                    self.username_error = "Invalid username."
                }
            }
        }
    }
    
    func checkIfUserHasQuestions() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        url_string = serverURL + "/tapcoinsapi/securityquestions/check_has_questions"
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "username=" + _username
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(Response.self, from: data)
            if response.result == "Success"{
                DispatchQueue.main.async {
                    self.valid_userename = true
                    self.submit_pressed = false
                    self.question_1 = response.question_1
                    self.question_2 = response.question_2
                }
                return true
            }
            return false
        }
        catch {
            throw PostDataError.invalidData
        }
    }
    struct Response:Codable {
        let result:String
        let question_1:String
        let question_2:String
    }
    
    func checkAnswersToQuestionsTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.username_sent = true
                    self.submit_pressed = true
                    self.incorrect_answers_errors = false
                    self.is_error = false
                }
                if answer_1 == ""{
                    DispatchQueue.main.async {
                        self.username_sent = false
                        self.submit_pressed = false
                        self.incorrect_answers_errors = true
                    }
                    return
                }
                
                if answer_2 == ""{
                    DispatchQueue.main.async {
                        self.username_sent = false
                        self.submit_pressed = false
                        self.incorrect_answers_errors = true
                    }
                    return
                }
                let result:Bool = try await checkAnswersToQuestions()
                if result{
                    print("Success")
                }
                else{
                    print("Something went wrong.")
                    DispatchQueue.main.async {
                        self.incorrect_answers_errors = true
                    }
                }
                DispatchQueue.main.async {
                    self.submit_pressed = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.is_error = true
                    self.submit_pressed = false
                }
            }
        }
    }
    
    func checkAnswersToQuestions() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        url_string = serverURL + "/tapcoinsapi/securityquestions/check_users_answers"
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let answers = "&answer_1=" + answer_1 + "&answer_2=" + answer_2
        let requestBody = "username=" + _username + answers
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(Response2.self, from: data)
            if response.result == true{
                DispatchQueue.main.async {
                    self.correct_answers = true
                    self.submit_pressed = false
                    self.logged_in_user = self._username
                    self.changing_password = true
                }
                return true
            }
            else{
                return false
            }
        }
        catch {
            throw PostDataError.invalidData
        }
    }
    
    struct Response2:Codable {
        let result:Bool
    }
}
