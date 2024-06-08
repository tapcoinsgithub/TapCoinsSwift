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
    public var options1:[String] = ["Loading ..."]
    public var options2:[String] = ["Loading ..."]
    
    init(){
        get_security_questions_text()
    }
    
    func save_questions_and_answers(){
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/securityquestions/save_users_security_questions"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/securityquestions/save_users_security_questions"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        
        guard let session = logged_in_user else{
            return
        }
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "token": session,
            "question_1":options1[question_1],
            "answer_1": answer_1,
            "question_2":options2[question_2],
            "answer_2": answer_2
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    _ = try JSONDecoder().decode(Save_SQ_Response.self, from: data)
                    self?.show_security_questions = false
                    self?.pressed_check_and_set_sqs = false
                    self?.is_loading = false
                    self?.saved_questions_answers = true
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    struct Save_SQ_Response:Codable{
        let result:String
    }
    
    func check_and_set_sqs(){
        pressed_check_and_set_sqs = true
        is_loading = true
        if question_1 == 0 {
            self.pressed_check_and_set_sqs = false
            self.is_loading = false
            return
        }
        if answer_1 == "" {
            self.pressed_check_and_set_sqs = false
            self.is_loading = false
            return
        }
        if question_2 == 0{
            self.pressed_check_and_set_sqs = false
            self.is_loading = false
            return
        }
        if answer_2 == ""{
            self.pressed_check_and_set_sqs = false
            self.is_loading = false
            return
        }
        save_questions_and_answers()
    }
    
    func get_security_questions_text(){
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/securityquestions/get_security_questions_text"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/securityquestions/get_security_questions_text"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(SecurityQResponse.self, from: data)
                    self?.options1 = response.options_1
                    self?.options2 = response.options_2
                    print("OPTIONS 1 BELOW")
                    print(response.options_1)
                    self?.got_security_questions = true
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    struct SecurityQResponse:Codable {
        let options_1: [String]
        let options_2: [String]
    }
    
    func get_users_questions_and_answers(){
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/securityquestions/get_users_questions_answers"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/securityquestions/get_users_questions_answers"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "token":logged_in_user,
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(ResponseSQA.self, from: data)
                    if response.result == "Success"{
                        self?.question_1 = self?.options1.firstIndex(of: response.question_1) ?? 0
                        self?.question_2 = self?.options2.firstIndex(of: response.question_2) ?? 0
                        self?.answer_1 = response.answer_1
                        self?.answer_2 = response.answer_2
                    }
                    else{
                        self?.question_1 = 0
                        self?.question_2 = 0
                        self?.answer_1 = ""
                        self?.answer_2 = ""
                    }
                    self?.got_security_questions = true
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    struct ResponseSQA:Codable {
        let result:String
        let question_1:String
        let question_2:String
        let answer_1:String
        let answer_2:String
    }
    
    func confirm_password(){
        pressed_confirm_password = true
        is_loading = true
        password_error = false
        var url_string:String = ""
        
        if debug ?? false{
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
            is_loading = false
            password_error = true
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
                        self?.is_loading = false
                        self?.confirmed_password = true
                        self?.got_security_questions = false
                        self?.get_users_questions_and_answers()
                    }
                    else{
                        self?.password_error = true
                        self?.pressed_confirm_password = false
                        self?.is_loading = false
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
}
