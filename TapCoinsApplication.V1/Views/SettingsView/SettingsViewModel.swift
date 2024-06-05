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
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("wallet_added") private var wallet_added: Bool?
    @Published var username:String = ""
    @Published var smaller_screen:Bool = false
    @Published var userModel:UserViewModel?
    @Published var show_logout_option:Bool = false
    @Published var clicked_metamask_connect: Bool = false
    @Published var got_the_users_wallet: Bool = false
    @Published var users_address: String = ""
    @Published var pressed_get_wallet:Bool = false
    @Published var pressed_logout:Bool = false
    
    init(){
        self.userModel = UserViewModel(self.userViewModel ?? Data())
        if UIScreen.main.bounds.height < 750.0{
            smaller_screen = true
        }
        if wallet_added ?? false{
            got_the_users_wallet = true
        }
    }
    
    func getWallet() {
        pressed_get_wallet = true
        var usersAddress = "None"
        guard let session = logged_in_user else{
            return
        }
        if debug ?? true{
            usersAddress = session
        }
        else{
//            usersAddress = metaMaskRepo.getWalletAddress()
        }
        
        if usersAddress == "None"{
            return
        }
        
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/tapcoinsbc/saveWallet"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/tapcoinsbc/saveWallet"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var isUserOne = false
        if self.userModel?.username == "SAUCEYE"{
            isUserOne = true
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "wallet": usersAddress,
            "isUserOne": isUserOne
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    self?.got_the_users_wallet = true
                    self?.users_address = response.response
                    self?.wallet_added = true
//                    self?.userModel?.has_wallet = true
                    self?.userViewModel = self?.userModel?.storageValue
                }
                catch{
                    print("SOMETHING WENT WRONG HERE")
                }
            }
        })
        task.resume()
    }
    
    struct Response:Codable {
        let response: String
        let wallet_address: Bool
    }
    
    func logoutTask(){
        Task {
            do {
                let result:Bool = try await logout()
                if result{
//                    self?.wallet_added = false
                    self.logged_in_user = nil
                }
                else{
                    print("Something went wrong.")
                }
                pressed_logout = false
            } catch {
                _ = "Error: \(error.localizedDescription)"
                pressed_logout = false
            }
        }
    }
    
    func logout() async throws -> Bool{
        
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/logout"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/logout"
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
