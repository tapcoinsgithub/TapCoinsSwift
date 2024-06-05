//
//  FriendsViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class FriendsViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("Player1") var first_player: String?
    @AppStorage("Player2") var second_player: String?
    @AppStorage("gameId") var game_id: String?
    @AppStorage("from_queue") var from_queue: Bool?
    @AppStorage("custom_game") var custom_game: Bool?
    @AppStorage("is_first") var is_first: Bool?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("num_friends") public var num_friends:Int?
    @Published var userModel:UserViewModel?
    @Published var show_friend_request_actions_bool:Bool = false
    @Published var friend_requester_name:String = ""
    @Published var show_friend_actions_bool:Bool = false
    @Published var friend_name:String = ""
    @Published var active_friends_index_list:[Int] = []
    @Published var pressed_decline_request:Bool = false
    @Published var pressed_accept_request:Bool = false
    @Published var pressed_accept_invite:Bool = false
    @Published var pressed_decline_invite:Bool = false
    @Published var pressed_remove_friend:Bool = false
    @Published var pressed_send_invite:Bool = false
    private var first_time:Bool = true
    private var globalFunctions = GlobalFunctions()
    @Published var friends_indexes:[Int:Bool] = [:]
    
    init(){
        self.userModel = UserViewModel(self.userViewModel ?? Data())
        set_friend_indexes()
    }
    
    func set_friend_indexes(){
        var index = 0
        friends_indexes = [:]
        for friend in self.userModel?.friends ?? ["NO FRIENDS"] {
            if friend == "NO FRIENDS"{
                return
            }
            friends_indexes[index] = false
            index += 1
        }
    }
    
    func friend_logic(){
        var tempUserModelData = UserViewModel(self.userViewModel ?? Data())
        if tempUserModelData?.friends?.count ?? 0 > 0{
            if tempUserModelData?.friends?[0] == "0"{
                tempUserModelData?.numFriends = 0
            }
            else{
                var count = 0
                for friend in tempUserModelData?.friends ?? ["NO FRIENDS"]{
                    if !friend.contains("requested|"){
                        tempUserModelData?.hasRQ = false
                        if !friend.contains("sentTo|"){
                            tempUserModelData?.hasST = false
                            if !friend.contains("Pending request to"){
                                count += 1
                                if tempUserModelData?.hasInvite ?? false{
                                    tempUserModelData?.hasGI = true
                                }
                            }
                        }
                        else{
                            tempUserModelData?.hasST = true
                        }
                    }
                    else{
                        tempUserModelData?.hasRQ = true
                    }
                }
                tempUserModelData?.numFriends = count
                let arrayCount = tempUserModelData?.friends?.count
                tempUserModelData?.fArrayCount = arrayCount
            }
            let newFriendsArray = self.sortFriends(user: tempUserModelData ?? UserViewModel(first_name: "NO FIRST NAME", last_name: "NO LAST NAME"))
            self.userModel?.friends = newFriendsArray
        }
        else{
            tempUserModelData?.numFriends = 0
            tempUserModelData?.fArrayCount = 0
        }
    }
    
    func sortFriends(user: UserViewModel) -> Array<String>{
        var newFriends:Array<String> = []
        for friend in user.friends ?? ["NO FRIENDS"]{
            if friend.contains("sentTo|"){
                let fSplit = friend.split(separator: "|")
                let new_friend = "Pending request to " + fSplit[1]
                newFriends.append(new_friend)
            }
            else if friend.contains("requested|"){
                let fSplit = friend.split(separator: "|")
                let new_friend = "Friend request from " + fSplit[1]
                newFriends.append(new_friend)
            }
            else{
                if user.hasInvite ?? false{
                    let inv_friend = "Game Invite from " + friend
                    newFriends.append(inv_friend)
                }
                else{
                    newFriends.append(friend)
                }
            }
        }
        return newFriends
    }
    
    func decline_request(requestName:String){
        pressed_decline_request = true
        let rNameSplit = requestName.split(separator: " ")
        let rUsername = rNameSplit[3]
        
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/dfr"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/friend/dfr"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        guard let session = logged_in_user else{
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": rUsername,
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let response = try JSONDecoder().decode(DResponse.self, from: data)
                DispatchQueue.main.async {
                    if response.result == "Declined"{
                        var index = 0
                        for friend in self?.userModel?.friends ?? ["NO FRIENDS"]{
                            if friend.contains(requestName){
                                self?.userModel?.friends?.remove(at: index)
                                break
                            }
                            index += 1
                        }
                        self?.pressed_decline_request = false
                    }
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    struct DResponse:Codable {
        let result: String
    }
    
    func accept_request(requestName:String){
        pressed_accept_request = true
        let rNameSplit = requestName.split(separator: " ")
        let rUsername = rNameSplit[3]
        if self.num_friends == nil{
            self.num_friends = 1
        }
        else{
            self.num_friends! += 1
        }
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/afr"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/friend/afr"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        guard let session = logged_in_user else{
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": rUsername,
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(AResponse.self, from: data)
                DispatchQueue.main.async {
                    if response.result == "Accepted"{
                        var index = 0
                        for friend in self?.userModel?.friends ?? ["NO FRIENDS"]{
                            if friend.contains(requestName){
                                self?.userModel?.friends?[index] = String(rUsername)
                                break
                            }
                            index += 1
                        }
                        self?.pressed_accept_request = false
                    }
                }
                
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
                            
    struct AResponse:Codable {
        let result: String
    }
    
    func removeFriend(requestName:String){
        pressed_remove_friend = true
        if self.num_friends == nil{
            self.num_friends = 0
        }
        else{
            self.num_friends! -= 1
        }
        
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/remove_friend"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/friend/remove_friend"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        guard let session = logged_in_user else{
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": requestName,
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let response = try JSONDecoder().decode(RResponse.self, from: data)
                if response.result == "Removed"{
                    DispatchQueue.main.async {
                        var ecount = 0;
                        let friendsList = self?.userModel?.friends ?? ["NO FRIENDS"]
                        if friendsList[0] != "NO FRIENDS"{
                            for friendIndex in friendsList.indices {
                                if ecount == 0 && friendIndex == 5{
                                    break
                                }
                                if friendsList[friendIndex] == requestName{
                                    self?.userModel?.friends?.remove(at: friendIndex)
                                }
                                ecount+=1
                            }
                        }
                        
                    }
                    self?.pressed_remove_friend = false
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    struct RResponse:Codable {
        let result: String
    }
    
    func sendInvite(inviteName:String){
        pressed_send_invite = true
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/send_invite"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/friend/send_invite"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        guard let session = logged_in_user else{
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": inviteName,
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(CGResponse.self, from: data)
                if response.first != "ALREADY EXISTS"{
                    DispatchQueue.main.async {
                        self?.first_player = response.first
                        self?.second_player = response.second
                        self?.game_id = response.gameId
                        self?.from_queue = false
                        self?.custom_game = true
                        self?.is_first = true
                        self?.in_game = true
                        self?.pressed_send_invite = false
                    }
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    struct CGResponse:Codable {
        let first: String
        let second: String
        let gameId: String
    }
    
    func call_get_user(){
        DispatchQueue.main.async { [weak self] in
            self?.globalFunctions.getUser(token:self?.logged_in_user ?? "None", this_user:nil, curr_user:nil)
        }
    }
    
    func show_hide_friend_request_actions(index:String){
        show_friend_request_actions_bool = !show_friend_request_actions_bool
        friend_requester_name = index
    }
    
    func show_hide_friend_actions(index:Int, friend:String){
        friends_indexes[index] = !(friends_indexes[index] ?? false)
        friend_name = friend
    }
 }
