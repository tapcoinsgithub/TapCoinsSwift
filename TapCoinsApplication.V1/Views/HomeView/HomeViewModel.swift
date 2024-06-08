//
//  HomeViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI
//import CloudKit
//import RecaptchaEnterprise

final class HomeViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("de_queue") private var de_queue: Bool?
    @AppStorage("notifications") var notifications_on:Bool?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("show_security_questions") var show_security_questions:Bool?
    @AppStorage("selectedOption1") var selectedOption1:Int?
    @AppStorage("selectedOption2") var selectedOption2:Int?
    @AppStorage("answerHere1") var answerHere1:String?
    @AppStorage("answerHere2") var answerHere2:String?
    @AppStorage("loadedUser") var loaded_get_user:Bool?
    @AppStorage("from_gq") private var from_gq: Bool?
    @AppStorage("tapDash") var tapDash:Bool?
    @AppStorage("tapDashLeft") var tapDashLeft:Int?
    @AppStorage("tap_dash_time_left") var tap_dash_time_left:String?
    @Published var iCloudAccountError:String?
    @Published var hasiCloudAccountError:Bool?
    @Published var isSignedInToiCloud:Bool?
    @Published var user_name:String?
    @Published var username:String = "NULL"
    @Published var showFaceIdPopUp:Bool = false
    @Published var passedFaceId:Bool = false
    @Published var failedFaceId:Bool = false
    @Published var userModel:UserViewModel?
    @Published var iCloud_status:String = "No iCloud Status."
    @Published var failedFaceIdMessage: String = ""
    @Published var pressed_find_game:Bool = false
    @Published var pressed_face_id_button:Bool = false
    @Published var pressed_check_and_set_sqs:Bool = false
    @Published var temp_answer_1:String = ""
    @Published var temp_answer_2:String = ""
    @Published var temp_question_1:Int = 0
    @Published var temp_question_2:Int = 0
    @Published var got_security_questions:Bool = false
    @Published var show_user_streak_pop_up:Bool = false
    public var options1:[String] = ["Loading ..."]
    public var options2:[String] = ["Loading ..."]
    private var question_1:String = ""
    private var answer_1:String = ""
    private var question_2:String = ""
    private var answer_2:String = ""
    private var status_granted:Bool = false
    private var globalFunctions = GlobalFunctions()
    
    init() {
        DispatchQueue.main.async { [weak self] in
            self?.globalFunctions.getUserTask(token:self?.logged_in_user ?? "None", this_user:nil, curr_user:nil)
        }
        DispatchQueue.main.async { [weak self] in
            self?.userModel = UserViewModel(self?.userViewModel ?? Data())
            self?.get_security_questions_text()
            if self?.userModel?.has_security_questions == true{
                self?.show_security_questions = false
            }
            else{
                self?.show_security_questions = true
                self?.selectedOption1 = 0
                self?.selectedOption2 = 0
                self?.answerHere1 = ""
                self?.answerHere2 = ""
            }
        }
        DispatchQueue.main.async { [weak self] in
            if self?.userModel?.is_guest == false {
//                self?.getiCloudStatus()
            }
            else{
                self?.iCloud_status = "IS A GUEST"
                self?.show_security_questions = false
            }
        }
//        if from_gq ?? false{
//            start_user_streak()
//        }
    }
    
    func start_user_streak(){
        var url_string:String = ""
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/game/start_user_streak"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/game/start_user_streak"
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
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(StartUserStreakResponse.self, from: data)
                    if response.response == true{
                        self?.from_gq = false
                        self?.show_user_streak_pop_up = true
                    }
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    struct StartUserStreakResponse:Codable {
        let response: Bool
    }
    
    func get_security_questions_text(){
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/securityquestions/get_security_questions_text"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/securityquestions/get_security_questions_text"
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
                    self?.got_security_questions = true
                }
                catch{
                    self?.logged_in_user = nil
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
    
    func save_questions_and_answers(){
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/securityquestions/save_users_security_questions"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/securityquestions/save_users_security_questions"
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
            "question_1":question_1,
            "answer_1": answer_1,
            "question_2":question_2,
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
        if temp_question_1 != 0 {
            question_1 = options1[temp_question_1]
        }
        else{
            self.pressed_check_and_set_sqs = false
            return
        }
        if temp_answer_1 != "" {
            answer_1 = temp_answer_1
        }
        else{
            self.pressed_check_and_set_sqs = false
            return
        }
        if temp_question_2 != 0{
            question_2 = options2[temp_question_2]
        }
        else{
            self.pressed_check_and_set_sqs = false
            return
        }
        if temp_answer_2 != ""{
            answer_2 = temp_answer_2
        }
        else{
            self.pressed_check_and_set_sqs = false
            return
        }
        save_questions_and_answers()
    }

}
