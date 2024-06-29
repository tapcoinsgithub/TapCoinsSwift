//
//  SettingsViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class SettingsViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("notifications") var notifications_on:Bool?
    @AppStorage("haptics") var haptics_on:Bool?
    @AppStorage("sounds") var sound_on:Bool?
    @AppStorage("user") private var userViewModel: Data?
    @Published var username:String = ""
    @Published var smaller_screen:Bool = false
    @Published var userModel:UserViewModel?
    @Published var show_logout_option:Bool = false
    @Published var clicked_metamask_connect: Bool = false
    @Published var users_address: String = ""
    @Published var pressed_logout:Bool = false
    @Published var accountInfoNavIsActive:Bool = false
    @Published var toggleViewNavIsActive:Bool = false
    
    init(){
        self.userModel = UserViewModel(self.userViewModel ?? Data())
        if UIScreen.main.bounds.height < 750.0{
            smaller_screen = true
        }
    }
    
    func logoutTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.pressed_logout = true
                }
                let result:Bool = try await logout()
                if result{
                    print("SUCCESS")
                }
                else{
                    print("Something went wrong.")
                }
                DispatchQueue.main.async {
                    self.logged_in_user = nil
                    self.pressed_logout = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.logged_in_user = nil
                    self.pressed_logout = false
                }
            }
        }
    }
    
    func logout() async throws -> Bool{
        
        var url_string:String = ""
        let serverURL = ProcessInfo.processInfo.environment["API_URL"] ?? "None"
        if serverURL == "None"{
            print("SERVER URL IS NONE")
            return false
        }
        else{
            print("GOT THE SERVER URL")
            url_string = serverURL + "/tapcoinsapi/user/logout"
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestBody = "token=" + session
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(LogoutResponse.self, from: data)
            if response.result == "Success"{
                return true
            }
            return false
        }
        catch {
            throw PostDataError.invalidData
        }
    }
    
    struct LogoutResponse:Codable {
        let result: String
    }
}
