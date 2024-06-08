//
//  ForgotUsernameViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class ForgotUsernameViewModel: ObservableObject {
    @AppStorage("debug") private var debug: Bool?
    @Published var phone_number:String = ""
    @Published var send_pressed:Bool = false
    @Published var is_phone_error = false
    @Published var successfully_sent = false
    private var globalFunctions = GlobalFunctions()
    
    func send_username(){
        send_pressed = true
        is_phone_error = false
        successfully_sent = false
        
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/send_username"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/send_username"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        
        if phone_number == ""{
            is_phone_error = true
            send_pressed = false
            successfully_sent = false
            return
        }
        
        if self.globalFunctions.check_errors(state: Error_States.Invalid_Phone_Number, _phone_number: phone_number, uName: "", p1: "", p2: "", _email_address: "") == "PHError" {
            is_phone_error = true
            send_pressed = false
            successfully_sent = false
            return
        }
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "phone_number": phone_number,
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    if response.response{
                        self?.successfully_sent = true
                        self?.send_pressed = false
                    }
                    else{
                        self?.is_phone_error = true
                    }
                }
                catch{
                    print("Something went wrong.")
                }
                self?.send_pressed = false
            }
            
        })
        task.resume()
    }
    
    struct Response:Codable {
        let response: Bool
        let message: String
    }
}
