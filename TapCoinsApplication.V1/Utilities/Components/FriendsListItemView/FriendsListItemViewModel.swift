//
//  FriendsListItemViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class FriendsListItemViewModel: ObservableObject {
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("Player1") var first_player: String?
    @AppStorage("Player2") var second_player: String?
    @AppStorage("gameId") var game_id: String?
    @AppStorage("from_queue") var from_queue: Bool?
    @AppStorage("custom_game") var custom_game: Bool?
    @AppStorage("is_first") var is_first: Bool?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("num_friends") public var num_friends:Int?
    @AppStorage("haptics") var haptics_on:Bool?
    @Published var userModel:UserViewModel?
    @Published var friend_requester_name:String = ""
    @Published var show_friend_request_actions_bool:Bool = false
    @Published var pressed_decline_request:Bool = false
    @Published var pressed_accept_request:Bool = false
    @Published var pressed_accept_invite:Bool = false
    @Published var pressed_decline_invite:Bool = false
    @Published var pressed_remove_friend:Bool = false
    @Published var pressed_send_invite:Bool = false
    @Published var show_friend_actions_bool:Bool = false
    @Published var friend_state:FriendItemState = FriendItemState.DynamicFriend
    @Published var normalFriendName:String = ""
    @Published var loading_the_switch:Bool = false
    @Published var active_friends_index_list:[Int] = []
    private var removed_friend_successfully:Bool = false
    private var view_token:String = ""
    private var globalFunctions = GlobalFunctions()
    
    init(){
        userModel = UserViewModel(self.userViewModel ?? Data())
        active_friends_index_list = userModel?.active_friends_index_list ?? []
    }
    
    func show_hide_friend_request_actions(index:String){
        show_friend_request_actions_bool = !show_friend_request_actions_bool
        friend_requester_name = index
    }
    
    func show_hide_friend_actions(index:Int, friend:String){
        show_friend_actions_bool = !show_friend_actions_bool
    }
    
    func getFriendsDataTask(){
        Task {
            do {
                let result:Bool = try await globalFunctions.getFriendsData(_userModel: self.userModel ?? nil)
                if result{
                    print("SUCCESS")
                    DispatchQueue.main.async {
                        self.userModel = UserViewModel(self.userViewModel ?? Data())
                        self.active_friends_index_list = self.userModel?.active_friends_index_list ?? []
                    }
                    
                }
                else{
                    print("Something went wrong.")
                }
            } catch {
                let catchError = "Error: \(error.localizedDescription)"
                print(catchError)
            }
        }
    }
    
    
    func declineRequestTask(friend:String){
        Task {
            do {
                DispatchQueue.main.async {
                    self.pressed_decline_request = true
                }
                let rNameSplit = friend.split(separator: " ")
                let rUsername = rNameSplit[3]
                let result:Bool = try await declineFriendRequest(requestName: String(rUsername))
                if result{
                    DispatchQueue.main.async {
                        self.getFriendsDataTask()
                    }
                }
                else{
                    print("Something went wrong.")
                }
                DispatchQueue.main.async {
                    self.pressed_decline_request = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.pressed_decline_request = false
                }
            }
        }
    }
    
    func declineFriendRequest(requestName:String) async throws -> Bool{
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/dfr"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/friend/dfr"
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestBody = "username=" + requestName + "&token=" + session
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            let dcFrResponse = try decoder.decode(FriendRequestResponse.self, from: data)
            if dcFrResponse.result == "Declined"{
                return true
            }
            return false
        }
        catch {
            throw PostDataError.invalidData
        }
    }
    
    func acceptRequestTask(friend:String){
        Task {
            do {
                DispatchQueue.main.async {
                    self.pressed_accept_request = true
                }
                let rNameSplit = friend.split(separator: " ")
                let rUsername = rNameSplit[3]
                let result:Bool = try await acceptFriendRequest(requestName: String(rUsername))
                if result{
                    DispatchQueue.main.async {
                        self.getFriendsDataTask()
                    }
                }
                else{
                    print("Something went wrong.")
                }
                DispatchQueue.main.async {
                    self.pressed_accept_request = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.pressed_accept_request = false
                }
            }
        }
    }
    
    func acceptFriendRequest(requestName:String) async throws -> Bool{
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/afr"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/friend/afr"
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestBody = "username=" + requestName + "&token=" + session
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            let acFrResponse = try decoder.decode(FriendRequestResponse.self, from: data)
            if acFrResponse.result == "Accepted"{
                return true
            }
            return false
        }
        catch {
            throw PostDataError.invalidData
        }
    }
    
    func removeFriendTask(friend:String){
        Task {
            do {
                let result:Bool = try await removeFriendFunction(requestName: friend)
                if result{
                    DispatchQueue.main.async {
                        self.getFriendsDataTask()
                    }
                }
                else{
                    print("Something went wrong.")
                }
                DispatchQueue.main.async {
                    self.pressed_remove_friend = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.pressed_remove_friend = false
                }
            }
        }
    }
    
    func removeFriendFunction(requestName:String) async throws -> Bool{
        var url_string:String = ""
        var sending_username = ""
        
        if friend_state == FriendItemState.NormalFriend{
            sending_username = adjustNormalFriendName(input_name: requestName)
        }
        else{
            sending_username = requestName
        }
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/remove_friend"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/friend/remove_friend"
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestBody = "username=" + sending_username + "&token=" + session
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            let rmFrResponse = try decoder.decode(FriendRequestResponse.self, from: data)
            if rmFrResponse.result == "Removed"{
                return true
            }
            return false
        }
        catch {
            throw PostDataError.invalidData
        }
    }
    
    func adjustNormalFriendName(input_name:String) -> String {
        let iNameSplit = input_name.split(separator: " ")
        let iUsername = iNameSplit[3]
        return String(iUsername)
    }
    
    struct FriendRequestResponse:Codable {
        let result: String
    }
    
    func acceptInviteTask(_inviteName:String){
        Task {
            do {
                DispatchQueue.main.async {
                    self.pressed_accept_invite = true
                }
                let result:Bool = try await acceptInvite(inviteName: _inviteName)
                if result{
                    DispatchQueue.main.async {
                        self.custom_game = true
                        self.in_game = true
                    }
                }
                else{
                    print("Something went wrong.")
                }
                DispatchQueue.main.async {
                    self.pressed_accept_invite = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.pressed_accept_invite = false
                }
            }
        }
    }

    
    func acceptInvite(inviteName:String) async throws -> Bool{
        
        var url_string:String = ""
        let rNameSplit = inviteName.split(separator: " ")
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/ad_invite"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/friend/ad_invite"
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let other_data = "username=" + rNameSplit[3] + "&token=" + session
        let requestBody = other_data + "&adRequest=accept"
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(AIResponse.self, from: data)
            if response.result == "Accepted"{
                DispatchQueue.main.async {
                    var index = 0
                    for friend in self.userModel?.friends ?? ["NO FRIENDS"]{
                        if friend.contains(inviteName){
                            self.userModel?.friends?[index] = String(rNameSplit[3])
                            break
                        }
                        index += 1
                    }
                    self.userViewModel = self.userModel?.storageValue
                    self.first_player = response.first
                    self.second_player = response.second
                    self.game_id = response.gameId
                    self.from_queue = false
                    self.is_first = false
                }
                return true
            }
            return false
        }
        catch {
            throw PostDataError.invalidData
        }
    }
    
    struct AIResponse:Codable {
        let result: String
        let first: String
        let second: String
        let gameId: String
    }
    
    func declineInviteTask(_inviteName:String, curr_user_name:String){
        Task {
            do {
                DispatchQueue.main.async {
                    self.pressed_decline_invite = true
                }
                let result:Bool = try await declineInvite(inviteName: _inviteName, curr_user_name: curr_user_name)
                if result{
                    DispatchQueue.main.async {
                        self.getFriendsDataTask()
                    }
                }
                else{
                    print("Something went wrong.")
                }
                DispatchQueue.main.async {
                    self.pressed_decline_invite = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.pressed_decline_invite = false
                }
            }
        }
    }
    
    func declineInvite(inviteName:String, curr_user_name:String) async throws -> Bool{
        
        var url_string:String = ""
        let rNameSplit = inviteName.split(separator: " ")
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/ad_invite"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/friend/ad_invite"
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let players_names = "first_player=" + rNameSplit[3] + "&second_player=" + curr_user_name
        let other_data = "&token=" + session + "&adRequest=delete"
        let requestBody = players_names + other_data
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(DIResponse.self, from: data)
            if response.result == "Cancelled"{
                return true
            }
            return false
        }
        catch {
            throw PostDataError.invalidData
        }
    }
    
    struct DIResponse:Codable {
        let result: String
        let gameId: String
    }
    
    func sendInviteTask(_inviteName:String){
        Task {
            do {
                DispatchQueue.main.async {
                    self.pressed_send_invite = true
                }
                let result:Bool = try await sendInvite(inviteName: _inviteName)
                if result{
                    DispatchQueue.main.async {
                        self.custom_game = true
                        self.in_game = true
                    }
                }
                else{
                    print("Something went wrong.")
                }
                DispatchQueue.main.async {
                    self.pressed_send_invite = false
                }
            } catch {
                _ = "Error: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    self.pressed_send_invite = false
                }
            }
        }
    }
    
    func sendInvite(inviteName:String) async throws -> Bool{
        
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/send_invite"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/friend/send_invite"
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw PostDataError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = "username=" + inviteName + "&token=" + session
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PostDataError.invalidResponse
        }
        do {
            let response = try JSONDecoder().decode(CGResponse.self, from: data)
            if response.first != "ALREADY EXISTS"{
                DispatchQueue.main.async {
                    self.first_player = response.first
                    self.second_player = response.second
                    self.game_id = response.gameId
                    self.from_queue = false
                    self.is_first = true
                }
                return true
            }
            return false
        }
        catch {
            throw PostDataError.invalidData
        }
    }
    
    struct CGResponse:Codable {
        let first: String
        let second: String
        let gameId: String
    }
}
