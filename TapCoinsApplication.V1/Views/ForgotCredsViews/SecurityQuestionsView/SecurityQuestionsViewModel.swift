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
    @AppStorage("debug") private var debug: Bool?
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
    
    func check_if_user_has_questions(){
        username_sent = true
        submit_pressed = true
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/securityquestions/check_has_questions"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/securityquestions/check_has_questions"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username":_username,
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    if response.result == "Success"{
                        self?.valid_userename = true
                        self?.submit_pressed = false
                        self?.question_1 = response.question_1
                        self?.question_2 = response.question_2
                    }
                    else{
                        self?.submit_pressed = false
                    }
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    struct Response:Codable {
        let result:String
        let question_1:String
        let question_2:String
    }
    func check_answers_to_questions(){
        username_sent = true
        submit_pressed = true
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/securityquestions/check_users_answers"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/securityquestions/check_users_answers"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        
        if answer_1 == ""{
            submit_pressed = false
            incorrect_answers_errors = true
            return
        }
        
        if answer_2 == ""{
            submit_pressed = false
            incorrect_answers_errors = true
            return
        }

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username":_username,
            "answer_1": answer_1,
            "answer_2": answer_2
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response2.self, from: data)
                    if response.result == true{
                        self?.correct_answers = true
                        self?.incorrect_answers_errors = false
                        self?.submit_pressed = false
                        self?.logged_in_user = self?._username
                        self?.changing_password = true
                    }
                    else{
                        self?.submit_pressed = false
                        self?.incorrect_answers_errors = true
                    }
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    struct Response2:Codable {
        let result:Bool
    }
}
