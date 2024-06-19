//
//  ProfileViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class ProfileViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("de_queue") private var de_queue: Bool?
    @AppStorage("num_friends") public var num_friends:Int?
    @AppStorage("loadedUser") var loaded_get_user:Bool?
    @AppStorage("tapDash") var tapDash:Bool?
    @AppStorage("haptics") var haptics_on:Bool?
    @Published var userModel: UserViewModel = UserViewModel(first_name: "NO FIRST NAME", last_name: "NO LAST NAME")
    @Published var sUsername:String = ""
    @Published var result:String = ""
    @Published var showRequest:Bool = false
    @Published var usernameRes:Bool = false
    @Published var smaller_screen:Bool = false
    @Published var show_logout_option:Bool = false
    @Published var league_title:String = "Noob"
    @Published var leagueColor:Color = CustomColorsModel().colorSchemeTwo
    @Published var leageForeground:Color = Color(.black)
    @Published var pressed_send_request:Bool = false
    @Published var invalid_entry:Bool = false
    @Published var friendsViewNavIsActive:Bool = false
    private var globalFunctions = GlobalFunctions()
    
    init(){
        let convertedData = UserViewModel(self.userViewModel ?? Data())
        self.userModel = convertedData ?? UserViewModel(first_name: "NO FIRST NAME", last_name: "NO LAST NAME")
        set_league_data()
        for friend in self.userModel.friends ?? ["NO FRIENDS"]{
            if friend.contains("Friend request from"){
                if self.userModel.numFriends != nil && self.userModel.numFriends != 0{
                    self.userModel.numFriends! -= 1
                }
                else{
                    self.userModel.numFriends! = 0
                }
            }
            else if friend.contains("Pending request to"){
                if self.userModel.numFriends != nil && self.userModel.numFriends != 0{
                    self.userModel.numFriends! -= 1
                }
                else{
                    self.userModel.numFriends! = 0
                }
            }
        }
        num_friends = self.userModel.numFriends
        self.loaded_get_user = true
    }
    
    func set_league_data(){
        if self.tapDash ?? false{
            switch self.userModel.tap_dash_league {
            case League.NOOB.rawValue:
                league_title = "NOOB"
                leagueColor = CustomColorsModel().colorSchemeTwo
                leageForeground = Color(.black)
            case League.BAD.rawValue:
                league_title = "BAD"
                leagueColor = CustomColorsModel().colorSchemeFive
                leageForeground = Color(.black)
            case League.OKAY.rawValue:
                league_title = "OKAY"
                leagueColor = CustomColorsModel().colorSchemeSix
                leageForeground = Color(.black)
            case League.BETTER.rawValue:
                league_title = "BETTER"
                leagueColor = CustomColorsModel().colorSchemeThree
                leageForeground = Color(.white)
            case League.GOOD.rawValue:
                league_title = "GOOD"
                leagueColor = CustomColorsModel().colorSchemeSeven
                leageForeground = Color(.black)
            case League.SOLID.rawValue:
                league_title = "SOLID"
                leagueColor = CustomColorsModel().colorSchemeFour
                leageForeground = Color(.white)
            case League.SUPER.rawValue:
                league_title = "SUPER"
                leagueColor = CustomColorsModel().colorSchemeEight
                leageForeground = Color(.white)
            case League.MEGA.rawValue:
                league_title = "MEGA"
                leagueColor = CustomColorsModel().colorSchemeNine
            case League.GODLY.rawValue:
                league_title = "GODLY"
                leagueColor = CustomColorsModel().colorSchemeOne
            default:
                league_title = "NOOB"
                leagueColor = CustomColorsModel().colorSchemeTwo
            }
        }
        else{
            switch self.userModel.free_play_league {
            case League.NOOB.rawValue:
                league_title = "NOOB"
                leagueColor = CustomColorsModel().colorSchemeTwo
                leageForeground = Color(.black)
            case League.BAD.rawValue:
                league_title = "BAD"
                leagueColor = CustomColorsModel().colorSchemeFive
                leageForeground = Color(.black)
            case League.OKAY.rawValue:
                league_title = "OKAY"
                leagueColor = CustomColorsModel().colorSchemeSix
                leageForeground = Color(.black)
            case League.BETTER.rawValue:
                league_title = "BETTER"
                leagueColor = CustomColorsModel().colorSchemeThree
                leageForeground = Color(.white)
            case League.GOOD.rawValue:
                league_title = "GOOD"
                leagueColor = CustomColorsModel().colorSchemeSeven
                leageForeground = Color(.black)
            case League.SOLID.rawValue:
                league_title = "SOLID"
                leagueColor = CustomColorsModel().colorSchemeFour
                leageForeground = Color(.white)
            case League.SUPER.rawValue:
                league_title = "SUPER"
                leagueColor = CustomColorsModel().colorSchemeEight
                leageForeground = Color(.white)
            case League.MEGA.rawValue:
                league_title = "MEGA"
                leagueColor = CustomColorsModel().colorSchemeNine
            case League.GODLY.rawValue:
                league_title = "GODLY"
                leagueColor = CustomColorsModel().colorSchemeOne
            default:
                league_title = "NOOB"
                leagueColor = CustomColorsModel().colorSchemeTwo
            }
        }
    }
    
    func sendRequestTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.pressed_send_request = true
                    self.usernameRes = false
                }
                
                if sUsername.count <= 0 {
                    DispatchQueue.main.async {
                        self.result = "Invalid entry."
                        self.pressed_send_request = false
                        self.invalid_entry = true
                    }
                    return
                }
                
                let result:Bool = try await sendRequest()
                if result{
                    print("SUCCESS")
                }
                else{
                    print("Something went wrong.")
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    func sendRequest() async throws -> Bool{
        
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/sfr"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/friend/sfr"
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "username=" + sUsername + "&token=" + session
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
            do {
                let response = try JSONDecoder().decode(rResponse.self, from: data)
                DispatchQueue.main.async {
                    if response.result != "Success"{
                        self.invalid_entry = true
                        self.result = response.result + response.friends
                    }
                    else{
                        self.usernameRes = true
                        self.result = "Sent Friend Request"
                        self.loaded_get_user = false
                        DispatchQueue.main.async { [weak self] in
                            self?.globalFunctions.getUserTask(token:self?.logged_in_user ?? "None", this_user:nil, curr_user:nil)
                        }
                        DispatchQueue.main.async { [weak self] in
                            self?.userModel = UserViewModel(self?.userViewModel ?? Data()) ?? UserViewModel(Data())!
                        }
                        if self.userModel.is_guest == false {
    //                                self?.result = self?.globalFunctions.addRequest(sender: self?.userModel.username ?? "None", receiver: self?.sUsername ?? "None", requestType: "FriendRequest") ?? "ErrorOccured"
                        }
                        else{
                            self.result = "IS A GUEST"
                        }
                    }
                }
            }
            catch{
                print(error)
            }
        return true
    }

    struct rResponse:Codable {
        let result: String
        let friends:String
    }
}
