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
    @AppStorage("loadedUser") var loaded_get_user:Bool?
    @AppStorage("tapDashIsActive") var tapDashIsActive:Bool?
    @AppStorage("tapDash") var tapDash:Bool?
    @AppStorage("tapDashLeft") var tapDashLeft:Int?
    @AppStorage("tap_dash_time_left") var tap_dash_time_left:String?
    private var in_get_user:Bool = false
    
    func getUserTask(token:String, this_user:Int?, curr_user:Int?){
        Task {
            do {
                
                let result:Bool = try await getUser(token: token, this_user: this_user, curr_user: curr_user)
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
    
    func getUser(token:String, this_user:Int?, curr_user:Int?) async throws -> Bool{
        
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/info"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/user/info"
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
            var myData = UserViewModel(
                first_name: response.first_name,
                last_name: response.last_name,
                response: response.response,
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
//                        has_wallet: response.has_wallet,
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
            DispatchQueue.main.async {
                self.tapDashIsActive = response.tapDashIsActive
                self.tapDashLeft = response.tapDashLeft
                self.tap_dash_time_left = response.tap_dash_time_left
                if response.tapDashIsActive == false{
                    self.tapDash = false
                }
                self.de_queue = nil
                self.userViewModel = myData.storageValue
                self.loaded_get_user = true
            }
            return true
        }
        catch{
            DispatchQueue.main.async {
                self.logged_in_user = nil
            }
            print(error)
            return false
        }
    }
    
    // Response for Home View Get User Call
    struct Response:Codable {
        let first_name: String
        let last_name: String
        let response: String
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
//        let has_wallet: Bool
        let has_location: Bool
        let has_security_questions: Bool
        let tapDashIsActive: Bool
        let tapDashLeft: Int
        let tap_dash_time_left: String
    }
    
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
    
    func validate_email_address(value: String) -> Bool {
        let email_regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", email_regex).evaluate(with: value)
    }
    
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
        }
        return "Pass"
    }
    
    func get_security_questions_text() -> [String: Any]?{
        var got_response = false
        var return_data: [String: Any]?
        var _error:Bool = false
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/securityquestions/get_security_questions_text"
        }
        else{
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/securityquestions/get_security_questions_text"
        }
        
        guard let url = URL(string: url_string) else{
            return nil
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: request, completionHandler: {[] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                print("DATA BELOW")
                print(data)
                DispatchQueue.main.async {
                    do {
                        print("IN THE DO")
                        let response = try JSONDecoder().decode(SecurityQResponse.self, from: data)
                        print("RESPONSE BELOW")
                        print(response)
                        let joined1 = response.options_1.joined(separator: ";")
                        let joined2 = response.options_2.joined(separator: ";")
                        let joined3 = joined1 + "|" + joined2
                        let response_data: [String: Any] = [
                            "security_questions": joined3,
                            "options1": response.options_1,
                            "options2": response.options_2
                        ]
                        return_data = response_data
                        got_response = true
                    }
                    catch{
                        // return nil
                        _error = true
                        print(error)
                    }
                }
            })
            task.resume()
        }
        if (got_response == true){
            return return_data
        }
        else{
            if (_error){
                return nil
            }
            var count = 0
            while(got_response == false){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if (count == 3){
                        _error = true
                    }
                    else{
                        count += 1
                    }
                }
                if (_error == true){
                    break
                }
            }
            return return_data
        }
    }
    
    struct SecurityQResponse:Codable {
        let options_1: [String]
        let options_2: [String]
    }
    
//    func addRequest(sender:String, receiver:String, requestType: String) -> String{
//        var newRequest: CKRecord?
//        if requestType == "FriendRequest"{
//            newRequest = CKRecord(recordType: "FriendRequest")
//        }
//        else if requestType == "GameInvite"{
//            newRequest = CKRecord(recordType: "GameInvite")
//        }
//        else{
//            newRequest = nil
//        }
//        if newRequest == nil{
//            return "NilRequest"
//        }
//        newRequest!["sender"] = sender
//        newRequest!["receiver"] = receiver
//        let result = (newRequest!["sender"] ?? "No Sender") + " | " + (newRequest!["receiver"] ?? "No Receiver")
//        if saveRequest(record: newRequest!){
//            return result
//        }
//        else{
//            return "SaveFail"
//        }
//    }
//
//    func saveRequest(record:CKRecord) -> Bool{
//        var passed = false
//        CKContainer(identifier: "iCloud.com.ericviera.TapTapCoin").publicCloudDatabase.save(record) { [self] returnedRecord, returnedError in
//            if returnedError != nil{
//                passed = false
//            }
//            if returnedRecord != nil{
//                passed = true
//            }
//        }
//        return passed
//    }
}