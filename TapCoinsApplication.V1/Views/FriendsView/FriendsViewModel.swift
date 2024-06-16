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
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("debug") private var debug: Bool?
    @Published var userModel:UserViewModel?
    @Published var show_friend_request_actions_bool:Bool = false
    @Published var friend_requester_name:String = ""
    @Published var show_friend_actions_bool:Bool = false
    @Published var friend_name:String = ""
    @Published var active_friends_index_list:[Int] = []
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
