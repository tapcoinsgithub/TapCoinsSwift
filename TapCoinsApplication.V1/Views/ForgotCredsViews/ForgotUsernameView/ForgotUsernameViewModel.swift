//
//  ForgotUsernameViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class ForgotUsernameViewModel: ObservableObject {
    @Published var phone_number:String = ""
    @Published var send_pressed:Bool = false
    @Published var is_phone_error = false
    @Published var successfully_sent = false
    private var globalFunctions = GlobalFunctions()
    
    func sendUsernameTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.send_pressed = true
                    self.is_phone_error = false
                    self.successfully_sent = false
                }
                if phone_number == ""{
                    DispatchQueue.main.async {
                        self.is_phone_error = true
                        self.send_pressed = false
                        self.successfully_sent = false
                    }
                    return
                }
                
                if self.globalFunctions.check_errors(state: Error_States.Invalid_Phone_Number, _phone_number: phone_number, uName: "", p1: "", p2: "", _email_address: "") == "PHError" {
                    DispatchQueue.main.async {
                        self.is_phone_error = true
                        self.send_pressed = false
                        self.successfully_sent = false
                    }
                    return
                }
                let result:Bool = try await sendUsername()
                if result{
                    print("Success")
                }
                else{
                    print("Something went wrong.")
                    DispatchQueue.main.async {
                        self.is_phone_error = true
                    }
                }
                DispatchQueue.main.async {
                    self.send_pressed = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.send_pressed = false
                    self.is_phone_error = true
                }
            }
        }
    }
    
    func sendUsername() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = ProcessInfo.processInfo.environment["API_URL"] ?? "None"
        if serverURL == "None"{
            print("SERVER URL IS NONE")
            return false
        }
        else{
            print("GOT THE SERVER URL")
            url_string = serverURL + "/tapcoinsapi/user/send_username"
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "phone_number=" + phone_number
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(Response.self, from: data)
            if response.response{
                DispatchQueue.main.async {
                    self.successfully_sent = true
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
    
    struct Response:Codable {
        let response: Bool
        let message: String
    }
}
