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
    @Published var pressed_accept_invite:Bool = false
    @Published var pressed_decline_invite:Bool = false
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
    
    func sendInvite(inviteName:String){
        pressed_send_invite = true
        var url_string:String = ""
        
        if debug ?? false{
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
            self?.globalFunctions.getUserTask(token:self?.logged_in_user ?? "None", this_user:nil, curr_user:nil)
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
