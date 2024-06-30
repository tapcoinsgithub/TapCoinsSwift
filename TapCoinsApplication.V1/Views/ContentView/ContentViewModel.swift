//
//  ContentViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class ContentViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("de_queue") private var de_queue: Bool?
    @AppStorage("changing_password") private var changing_password: Bool?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("darkMode") var darkMode: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("betaMode") var betaMode: Bool?
    @Published var glPressed:Bool = false
    @Published var glError:Bool = false
    private var globalVariables = GlobalVariables()
    
    init() {
//        in_game = false
//        in_queue = false
//        logged_in_user = nil
        betaMode = true
        if logged_in_user == nil{
            changing_password = false
        }
    }
    
    func guestLoginTask(){
        Task {
            do {
                DispatchQueue.main.async{
                    self.glPressed = true
                    self.glError = false
                }
                let result:Bool = try await guestLogin()
                if !result{
                    print("Something went wrong.")
                    DispatchQueue.main.async{
                        self.glError = true
                    }
                }
                DispatchQueue.main.async{
                    self.glPressed = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async{
                    self.glError = true
                    self.glPressed = false
                }
            }
        }
    }
    
    func guestLogin() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = globalVariables.apiUrl
        url_string = serverURL + "/tapcoinsapi/user/guestLogin"
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "guest=login"
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(GLResponse.self, from: data)
            if response.error == false{
                DispatchQueue.main.async{
                    self.logged_in_user = response.token
                }
                return true
            }
            return false
        }
        catch {
            throw PostDataError.invalidData
        }
    }
    
    struct GLResponse:Codable {
        let response:String
        let username:String
        let error:Bool
        let token:String
    }
}
