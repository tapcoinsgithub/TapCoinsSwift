//
//  FriendsListItemView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct FriendsListItemView: View {
    @AppStorage("num_friends") public var num_friends:Int?
    @AppStorage("darkMode") var darkMode: Bool?
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = FriendsListItemViewModel()
    var newCustomColorsModel = CustomColorsModel()
    var friend:String
    var index:Int
    var curr_user_name:String
    var body: some View {
        VStack{
            if viewModel.friend_state == FriendItemState.NormalFriend {
                if viewModel.loading_the_switch {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint:darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour))
                        .scaleEffect(UIScreen.main.bounds.width * 0.003)
                }
                else{
                    VStack{
                        HStack(spacing: 0){
                            Text(viewModel.active_friends_index_list.contains(index) ? "🟢"  : "🔴")
                                .frame(width:UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.height * 0.1)
                            Rectangle()
                                .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                .frame(width: UIScreen.main.bounds.width * 0.001, height: UIScreen.main.bounds.height * 0.08)
                            VStack(spacing:0){
                                Button(action: {viewModel.show_hide_friend_actions(index:index, friend: friend)}, label:{
                                    HStack(spacing:0){
                                        Spacer()
                                        Text(viewModel.normalFriendName)
                                            .font(.system(size: UIScreen.main.bounds.width * 0.045))
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                            .fontWeight(.bold)
                                            .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.02)
                                            .padding()
                                        Image(systemName: viewModel.show_friend_actions_bool ? "arrowtriangle.up" : "arrowtriangle.down")
                                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                        Spacer()
                                    }
                                })
                                if viewModel.show_friend_actions_bool {
                                    HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                                        Button(action: {viewModel.pressed_send_invite ? nil : viewModel.sendInvite(inviteName: viewModel.normalFriendName)}, label: {
                                            HStack{
                                                Text("Custom game")
                                                Image(systemName: "arrow.up.square.fill")
                                                    .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                            }
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                        })
                                        .frame(width: UIScreen.main.bounds.width * 0.38, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                        .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                        .cornerRadius(UIScreen.main.bounds.width * 0.005)
                                        // Hide View to Mimick Deleting Friend
                                        Button(action: {
                                            if !viewModel.pressed_remove_friend{
                                                print("IN DYNAMIC FRIEND BUTTON")
                                                viewModel.removeFriendTask(friend: viewModel.normalFriendName)
                                            }
                                        }, label: {
                                            HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                                                Text("Remove Friend")
                                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                                Image(systemName: "delete.right.fill")
                                                    .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                            }
                                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                        })
                                        .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                        .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.02, alignment: .center)
                                }
                            }
                            
                            
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.08)
                        Rectangle()
                            .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                    } // VStack
                    .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
                }
            }
            else if viewModel.friend_state == FriendItemState.DynamicFriend{
                if friend.contains("Friend request from"){
                    VStack(spacing: 0){
                        VStack(spacing: 0){
                            Button(action: {viewModel.show_hide_friend_request_actions(index:friend)}, label:{
                                HStack(spacing: 0){
                                    Text(friend)
                                        .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.05)
                                        .font(.system(size: UIScreen.main.bounds.width * 0.045))
                                        .fontWeight(.bold)
                                        .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                        .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                    Image(systemName: viewModel.show_friend_request_actions_bool ? "envelope.open.fill" : "envelope.fill")
                                        .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.height * 0.05)
                                        .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                        .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                }
                            })
                        }
                        if viewModel.show_friend_request_actions_bool{
                            HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                                Button(action: {
                                    if !viewModel.pressed_decline_request{
                                        viewModel.declineRequestTask(friend: viewModel.friend_requester_name)
                                    }
                                }, label: {
                                    HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                                        Text("Decline Request")
                                            .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                        Image(systemName: "minus.square.fill")
                                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                    }
                                    .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                })
                                .frame(width: UIScreen.main.bounds.width * 0.49, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                .cornerRadius(UIScreen.main.bounds.width * 0.02)
                                Button(action: {viewModel.pressed_accept_request ? nil : viewModel.acceptRequestTask(friend: viewModel.friend_requester_name)}, label: {
                                    HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                                        Text("Accept Request")
                                            .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                        Image(systemName: "checkmark.square.fill")
                                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                    }
                                    .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                })
                                .frame(width: UIScreen.main.bounds.width * 0.49, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                .cornerRadius(UIScreen.main.bounds.width * 0.02)
                            }
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                        }
                        Rectangle()
                            .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                    }
                }
                else if friend.contains("Pending request"){
                    VStack(spacing: UIScreen.main.bounds.width * 0.01){
                        Text(friend)
                            .font(.system(size: UIScreen.main.bounds.width * 0.045))
                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                            .fontWeight(.bold)
                        Rectangle()
                            .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                    }
                }
                else if friend.contains("Game invite from"){
                    VStack(spacing: UIScreen.main.bounds.width * 0.01){
                        VStack(alignment: .center, spacing: 0){
                            Text(friend)
                                .font(.system(size: UIScreen.main.bounds.width * 0.045))
                                .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                .fontWeight(.bold)
                            HStack{
                                Button(action: {viewModel.pressed_accept_invite ? nil : viewModel.acceptInvite(inviteName: friend)}, label: {
                                    HStack{
                                        Text("Accept")
                                        Image(systemName: "checkmark.square.fill")
                                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                    .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                    .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)

                                })
                                // Turn game invite to normal friend
                                Button(action: {viewModel.pressed_decline_invite ? nil : viewModel.declineInviteTask(_inviteName: friend, curr_user_name: curr_user_name)}, label: {
                                    HStack{
                                        Text("Decline")
                                        Image(systemName: "xmark.square.fill")
                                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                    .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                    .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)

                                })
                            }
                        }
                        Rectangle()
                            .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                    }
                    .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
                }
                else{
                    VStack{
                        HStack(spacing: 0){
                            Text(viewModel.active_friends_index_list.contains(index) ? "🟢"  : "🔴")
                                .frame(width:UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.height * 0.1)
                            Rectangle()
                                .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                .frame(width: UIScreen.main.bounds.width * 0.001, height: UIScreen.main.bounds.height * 0.08)
                            VStack(spacing:0){
                                Button(action: {viewModel.show_hide_friend_actions(index:index, friend: friend)}, label:{
                                    HStack(spacing:0){
                                        Spacer()
                                        Text(friend)
                                            .font(.system(size: UIScreen.main.bounds.width * 0.045))
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                            .fontWeight(.bold)
                                            .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.02)
                                            .padding()
                                        Image(systemName: viewModel.show_friend_actions_bool ? "arrowtriangle.up" : "arrowtriangle.down")
                                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                        Spacer()
                                    }
                                })
                                if viewModel.show_friend_actions_bool {
                                    HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                                        Button(action: {viewModel.pressed_send_invite ? nil : viewModel.sendInvite(inviteName: friend)}, label: {
                                            HStack{
                                                Text("Custom game")
                                                Image(systemName: "arrow.up.square.fill")
                                                    .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                            }
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                        })
                                        .frame(width: UIScreen.main.bounds.width * 0.38, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                        .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                        .cornerRadius(UIScreen.main.bounds.width * 0.005)
                                        // Hide View to Mimick Deleting Friend
                                        Button(action: {
                                            if !viewModel.pressed_remove_friend{
                                                print("IN DYNAMIC FRIEND BUTTON")
                                                viewModel.removeFriendTask(friend: friend)
                                            }
                                        }, label: {
                                            HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                                                Text("Remove Friend")
                                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                                Image(systemName: "delete.right.fill")
                                                    .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                            }
                                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                        })
                                        .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                        .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.02, alignment: .center)
                                }
                            }
                            
                            
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.08)
                        Rectangle()
                            .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                    } // VStack
                    .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
                    
                }
            }
        }
    }
}
