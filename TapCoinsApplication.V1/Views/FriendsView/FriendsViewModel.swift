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
    @Published var userModel:UserViewModel?
    @Published var show_friend_request_actions_bool:Bool = false
    @Published var friend_requester_name:String = ""
    @Published var show_friend_actions_bool:Bool = false
    @Published var friend_name:String = ""
    private var first_time:Bool = true
    private var globalFunctions = GlobalFunctions()
    @Published var friends_indexes:[Int:Bool] = [:]
    @Published var gotFriendsData:Bool = false
    
    init(){
        self.userModel = UserViewModel(self.userViewModel ?? Data())
        self.gotFriendsData = true
        self.set_friend_indexes()
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
    
    func show_hide_friend_request_actions(index:String){
        show_friend_request_actions_bool = !show_friend_request_actions_bool
        friend_requester_name = index
    }
    
    func show_hide_friend_actions(index:Int, friend:String){
        friends_indexes[index] = !(friends_indexes[index] ?? false)
        friend_name = friend
    }
 }
