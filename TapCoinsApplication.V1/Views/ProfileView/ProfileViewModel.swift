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
    @AppStorage("tapDash") var tapDash:Bool?
    @AppStorage("haptics") var haptics_on:Bool?
    @Published var userModel: UserViewModel = UserViewModel(first_name: "NO FIRST NAME", last_name: "NO LAST NAME")
    @Published var sUsername:String = ""
    @Published var result:String = ""
    @Published var showRequest:Bool = false
    @Published var usernameRes:Bool = false
    @Published var smaller_screen:Bool = false
    @Published var show_logout_option:Bool = false
    @Published var league_title:String = "NOOB"
    @Published var leagueColor:Color = CustomColorsModel().colorSchemeTwo
    @Published var leageForeground:Color = Color(.black)
    @Published var pressed_send_request:Bool = false
    @Published var invalid_entry:Bool = false
    @Published var friendsViewNavIsActive:Bool = false
    @Published var gotProfileView:Bool = false
    private var globalFunctions = GlobalFunctions()
    
    init(){
        DispatchQueue.main.async {
            let convertedData = UserViewModel(self.userViewModel ?? Data())
            self.userModel = convertedData ?? UserViewModel(first_name: "NO FIRST NAME", last_name: "NO LAST NAME")
            self.num_friends = self.userModel.numFriends
            self.gotProfileView = true
            self.set_league_data()
        }
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
    
    func getProfileDataTask(){
        Task {
            do {
                DispatchQueue.main.async {
                    self.gotProfileView = false
                }
                let result:Bool = try await getProfileData()
                if result{
                    print("SUCCESS")
                    DispatchQueue.main.async {
                        self.set_league_data()
                    }
                }
                else{
                    print("Something went wrong.")
                }
                DispatchQueue.main.async {
                    self.gotProfileView = true
                }
            } catch {
                let catchError = "Error: \(error.localizedDescription)"
                print(catchError)
                DispatchQueue.main.async {
                    self.gotProfileView = true
                }
                
            }
        }
    }
    
    // API Call
    func getProfileData() async throws -> Bool{
        print("IN GET PROFILE DATA")
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/profile_view"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://www.tapcoinsgameqa.com/tapcoinsapi/user/profile_view"
        }
        
        guard var urlComponents = URLComponents(string: url_string) else {
            throw PostDataError.invalidURL
        }
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        // Add query parameters to the URL
        urlComponents.queryItems = [
            URLQueryItem(name: "token", value: session),
        ]
        
        // Ensure the URL is valid
        guard let url = urlComponents.url else {
            throw PostDataError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(Response.self, from: data)
            print("RESPONSE IS BELOW")
            print(response)
            
            DispatchQueue.main.async {
                var myData = UserViewModel(
                    first_name: self.userModel.first_name,
                    last_name: self.userModel.last_name,
                    username: response.username,
                    phone_number: self.userModel.phone_number,
                    email_address: self.userModel.email_address,
                    friends: response.friends,
                    active_friends_index_list: self.userModel.active_friends_index_list,
                    hasInvite: response.hasInvite,
                    free_play_wins: response.free_play_wins,
                    free_play_losses: response.free_play_losses,
                    free_play_best_streak: response.free_play_best_streak,
                    free_play_win_streak: response.free_play_win_streak,
                    free_play_games: response.free_play_games,
                    free_play_league: response.free_play_league,
                    tap_dash_wins: response.tap_dash_wins,
                    tap_dash_losses: response.tap_dash_losses,
                    tap_dash_best_streak: response.tap_dash_best_streak,
                    tap_dash_win_streak: response.tap_dash_win_streak,
                    tap_dash_games: response.tap_dash_games,
                    tap_dash_league: response.tap_dash_league,
                    tap_coin: response.tap_coin,
                    hasPhoneNumber: self.userModel.hasPhoneNumber,
                    hasEmailAddress: self.userModel.hasEmailAddress,
                    is_guest: response.is_guest,
                    has_security_questions: self.userModel.has_security_questions
                )
                if response.friends.count > 0{
                    if response.friends[0] == "0"{
                        myData.numFriends = 0
                    }
                    else{
                        var count = 0
                        for friend in response.friends{
                            print("FRIEND: \(friend)")
                            if !friend.contains("requested|"){
                                if !friend.contains("sentTo|"){
                                    count += 1
                                    if response.hasInvite{
                                        myData.hasGI = true
                                    }
                                }
                                else{
                                    myData.hasST = true
                                }
                            }
                            else{
                                myData.hasRQ = true
                            }
                        }
                        myData.numFriends = count
                        myData.fArrayCount = response.friends.count
                    }
                }
                else{
                    myData.numFriends = 0
                    myData.fArrayCount = 0
                }
                self.num_friends = myData.numFriends
                print("SET MY DATA IN PROFILE VIEW")
                self.userViewModel = myData.storageValue
                self.userModel = UserViewModel(self.userViewModel ?? Data())!
            }
            return true
        }
        catch{
            print(error)
            return false
        }
    }
    
    // Response Get User Call
    struct Response:Codable {
        let username: String
        let friends:Array<String>
        let hasInvite:Bool
        let is_guest:Bool
        let free_play_wins: Int
        let free_play_losses: Int
        let free_play_best_streak: Int
        let free_play_win_streak: Int
        let free_play_games: Int
        let free_play_league: Int
        let tap_dash_wins: Int
        let tap_dash_losses: Int
        let tap_dash_best_streak: Int
        let tap_dash_win_streak: Int
        let tap_dash_games: Int
        let tap_dash_league: Int
        let tap_coin: Int
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
                
                try await sendRequest()
                DispatchQueue.main.async {
                    self.pressed_send_request = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.pressed_send_request = false
                    self.invalid_entry = true
                    self.result = "Something went wrong."
                }
            }
        }
    }
    
    func sendRequest() async throws{
        
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/sfr"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://www.tapcoinsgameqa.com/tapcoinsapi/friend/sfr"
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
                        self.getProfileDataTask()
                        // Look into this later
//                        if self.userModel.is_guest == false {
//    //                                self?.result = self?.globalFunctions.addRequest(sender: self?.userModel.username ?? "None", receiver: self?.sUsername ?? "None", requestType: "FriendRequest") ?? "ErrorOccured"
//                        }
//                        else{
//                            self.result = "IS A GUEST"
//                        }
                    }
                }
            }
            catch{
                print(error)
                DispatchQueue.main.async {
                    self.invalid_entry = true
                    self.result = "Something went wrong."
                }
            }
    }

    struct rResponse:Codable {
        let result: String
        let friends:String
    }
}
