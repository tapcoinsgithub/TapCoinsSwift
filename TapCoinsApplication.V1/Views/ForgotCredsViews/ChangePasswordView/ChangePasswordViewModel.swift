//
//  ChangePasswordViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class ChangePasswordViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("changing_password") var changing_password: Bool?
    @Published var is_match_error:Bool = false
    @Published var is_password_error:Bool = false
    @Published var submitted:Bool = false
    @Published var is_error = false
    @Published var error:String = ""
    @Published var password:String = ""
    @Published var c_password:String = ""
    @Published var submit_pressed:Bool = false
    
    func change_password(){
        submit_pressed = true
        is_error = false
        is_match_error = false
        submitted = false
        
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/change_password"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/change_password"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        
        if password != c_password{
            is_match_error = true
            is_password_error = false
            submit_pressed = false
            return
        }
        
        if password == "" {
            is_password_error = true
            is_match_error = false
            submit_pressed = false
            return
        }
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "code": "Change_Password",
            "username": self.logged_in_user,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response3.self, from: data)
                    if response.response{
                        self?.submitted = true
                        self?.submit_pressed = false
                        self?.changing_password = false
                        self?.logged_in_user = nil
                    }
                    else{
                        self?.submit_pressed = false
                        let errorType = Error_Types.allCases.first(where: { $0.index == response.error_type })
                        if errorType == Error_Types.BlankPassword{
                            self?.is_error = true
                            self?.error = response.message
                        }
                        if errorType == Error_Types.PreviousPassword{
                            self?.is_error = true
                            self?.error = response.message
                        }
                        if errorType == Error_Types.SomethingWentWrong{
                            self?.is_error = true
                            self?.error = response.message
                        }
                    }
                }
                catch{
                    self?.is_error = true
                    self?.error = "Something went wrong!"
                }
            }
        })
        task.resume()
    }
    
    struct Response3:Codable {
        let response: Bool
        let message: String
        let expired: Bool
        let error_type: Int
    }
}
