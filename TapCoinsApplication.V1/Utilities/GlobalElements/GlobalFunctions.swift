//
//  GlobalFunctions.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI
//import CloudKit

struct GlobalFunctions {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("de_queue") private var de_queue: Bool?
    @AppStorage("show_location") var show_location:Int?
    @AppStorage("location_on") var location_on:Bool?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("Player1") var first_player: String?
    @AppStorage("Player2") var second_player: String?
    @AppStorage("GotFirst") var got_first:Bool?
    @AppStorage("GotSecond") var got_second:Bool?
    @AppStorage("loadedAllUserData") var loadedAllUserData:Bool?
    @AppStorage("tapDashIsActive") var tapDashIsActive:Bool?
    @AppStorage("tapDash") var tapDash:Bool?
    @AppStorage("tapDashLeft") var tapDashLeft:Int?
    @AppStorage("tap_dash_time_left") var tap_dash_time_left:String?
    @AppStorage("num_friends") public var num_friends:Int?
    @AppStorage("activeTapDashUsers") var activeTapDashUsers:String?
    private var in_get_user:Bool = false
    
    // Task
    func getAllUserInfoTask(){
        Task {
            do {
                
                let result:Bool = try await getAllUserInfo()
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
    
    // API Call
    func getAllUserInfo() async throws -> Bool{
        
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/get_all_user_info"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/user/get_all_user_info"
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
            URLQueryItem(name: "de_queue", value: "\(self.de_queue ?? false)")
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
            print("IN THE DO Home")
            let response = try JSONDecoder().decode(Response.self, from: data)
            print(response)
            if response.has_location{
                print("HAS LOCATION")
                DispatchQueue.main.async {
                    self.location_on = true
                    self.show_location = 1
                }
            }
            else{
                DispatchQueue.main.async {
                    print("DOESNT HAVE LOCATION")
                    self.location_on = false
                    self.show_location = 0
                }
            }
            DispatchQueue.main.async {
                var myData = UserViewModel(
                    first_name: response.first_name,
                    last_name: response.last_name,
                    username: response.username,
                    phone_number: response.phone_number,
                    email_address: response.email_address,
                    friends: response.friends,
                    active_friends_index_list: response.active_friends_index_list,
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
                    hasPhoneNumber: response.HPN,
                    hasEmailAddress: response.HEA,
                    is_guest: response.is_guest,
                    has_security_questions: response.has_security_questions
                )
                print("SET MY DATA")
                if response.friends.count > 0{
                    if response.friends[0] == "0"{
                        myData.numFriends = 0
                    }
                    else{
                        var count = 0
                        for friend in response.friends{
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
                myData.hasPhoneNumber = response.HPN
                self.tapDashIsActive = response.tapDashIsActive
                self.tapDashLeft = response.tapDashLeft
                self.tap_dash_time_left = response.tap_dash_time_left
                self.activeTapDashUsers = response.active_tapdash_users
                if response.tapDashIsActive == false{
                    self.tapDash = false
                }
                self.de_queue = nil
                self.userViewModel = myData.storageValue
                self.loadedAllUserData = true
            }
            return true
        }
        catch{
            DispatchQueue.main.async {
                self.logged_in_user = nil
            }
            return false
        }
    }
    
    // Response Get User Call
    struct Response:Codable {
        let first_name: String
        let last_name: String
        let username: String
        let phone_number: String
        let email_address: String
        let friends:Array<String>
        let active_friends_index_list:Array<Int>
        let hasInvite:Bool
        let HPN:Bool
        let HEA:Bool
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
        let has_location: Bool
        let has_security_questions: Bool
        let tapDashIsActive: Bool
        let tapDashLeft: Int
        let tap_dash_time_left: String
        let active_tapdash_users: String
    }
    
    // API Call
    func endUserStreak() async throws -> Bool{
        
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/game/end_user_streak"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/game/end_user_streak"
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // set body variable for if it is confirming phone number or email code
        let requestBody = "token=" + session
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(EndStreakResponse.self, from: data)
            if response.result == true{
                print("ENDED USERS STREAK SUCCESSFULLY")
                print("ENDED USERS STREAK SUCCESSFULLY")
                print("ENDED USERS STREAK SUCCESSFULLY")
                print("ENDED USERS STREAK SUCCESSFULLY")
            }
            else{
                print("UNABLE TO END THE USERS STREAK")
                print("UNABLE TO END THE USERS STREAK")
                print("UNABLE TO END THE USERS STREAK")
                print("UNABLE TO END THE USERS STREAK")
            }
            return true
        }
        catch{
            print(error)
            return false
        }
    }
    
    struct EndStreakResponse:Codable {
        let result: Bool
    }
    
    // API Call
    func confirmPassword(password:String) async throws -> Bool{
        
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/confirm_password"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/user/confirm_password"
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // set body variable for if it is confirming phone number or email code
        let requestBody = "token=" + session + "&password=" + password
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(ResponseCP.self, from: data)
            if response.result{
                return true
            }
            return false
        }
        catch{
            print(error)
            throw PostDataError.invalidData
        }
    }
    struct ResponseCP:Codable {
        let result:Bool
    }
    
    // API Call
    func getFriendsData(_userModel:UserViewModel?) async throws -> Bool{
        print("IN GET FRIENDS DATA")
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/friends_view"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/user/friends_view"
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
            let response = try JSONDecoder().decode(FriendsDataResponse.self, from: data)
            print("GOT RESPONSE BELOW")
            print(response)
            print(response.fArrayCount)
            DispatchQueue.main.async {
                var myData = UserViewModel(
                    first_name: _userModel?.first_name ?? "None",
                    last_name: _userModel?.last_name ?? "None",
                    username: _userModel?.username,
                    friends: response.friends,
                    active_friends_index_list: response.active_friends_index_list,
                    hasInvite: response.hasInvite,
                    free_play_wins: _userModel?.free_play_wins,
                    free_play_losses: _userModel?.free_play_losses,
                    free_play_best_streak: _userModel?.free_play_best_streak,
                    free_play_win_streak: _userModel?.free_play_win_streak,
                    free_play_games: _userModel?.free_play_games,
                    free_play_league: _userModel?.free_play_league,
                    tap_dash_wins: _userModel?.tap_dash_wins,
                    tap_dash_losses: _userModel?.tap_dash_losses,
                    tap_dash_best_streak: _userModel?.tap_dash_best_streak,
                    tap_dash_win_streak: _userModel?.tap_dash_win_streak,
                    tap_dash_games: _userModel?.tap_dash_games,
                    tap_dash_league: _userModel?.tap_dash_league,
                    tap_coin: _userModel?.tap_coin,
                    fArrayCount: response.fArrayCount,
                    hasPhoneNumber: _userModel?.hasPhoneNumber,
                    hasEmailAddress: _userModel?.hasEmailAddress,
                    is_guest: _userModel?.is_guest,
                    has_security_questions: _userModel?.has_security_questions
                )
                print("SET MY DATA IN FRIENDS VIEW")
                if response.friends.count > 0{
                    if response.friends[0] == "0"{
                        myData.numFriends = 0
                    }
                    else{
                        var count = 0
                        for friend in response.friends{
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
                self.userViewModel = myData.storageValue
            }
            return true
        }
        catch{
            print("ERROR BELOW")
            print(error)
            return false
        }
    }
    
    // Response Get User Call
    struct FriendsDataResponse:Codable {
        let username: String
        let friends:Array<String>
        let hasInvite:Bool
        let active_friends_index_list:Array<Int>
        let fArrayCount: Int
    }

    
    
    // Simple function
    func validate_phone_number(value: String) -> Bool {
        let int_phone_number = Int(value) ?? 0
        if int_phone_number == 0 {
            return false
        }
        if int_phone_number > 9999999999999999 || int_phone_number <= 0{
            return false
        }
        else{
            let phone_regex = #"^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}"#
            return NSPredicate(format: "SELF MATCHES %@", phone_regex).evaluate(with: value)
        }
    }
    
    // Simple function
    func validate_email_address(value: String) -> Bool {
        let email_regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", email_regex).evaluate(with: value)
    }
    
    // Simple function
    func check_errors(state:Error_States, _phone_number:String, uName:String, p1:String, p2:String, _email_address:String) -> String{
        var is_uName_error = false
        var is_password_error = false
        switch state {
        case .Required:
            is_uName_error = uName.count <= 0 ? true : false
            if !is_uName_error{
                return "Pass"
            }
            return "Required"
        case .Invalid_Username:
            return "Invalid_Username"
        case .Password_Match:
            if p1 != p2{
                return "PMError"
            }
        case .Invalid_Phone_Number:
            if validate_phone_number(value: _phone_number) == false{
                return "PHError"
            }
        case .No_Match_User:
            return "NMUError"
        case .No_Match_Password:
            return "NMPError"
        case .RequiredLogin:
            is_uName_error = uName.count <= 0 ? true : false
            is_password_error = p1.count <= 0 ? true : false
            if !is_uName_error && !is_password_error{
                return "Pass"
            }
            return "RequiredLogin"
        case .Specific_Password_Error:
            return "SpecificPasswordError"
        case .Invalid_Email_Address:
            if validate_email_address(value: _email_address) == false{
                return "EAError"
            }
        case .Duplicate_Phone_Number:
            return ""
        case .Duplicate_Email_Address:
            return ""
        }
        return "Pass"
    }

}
