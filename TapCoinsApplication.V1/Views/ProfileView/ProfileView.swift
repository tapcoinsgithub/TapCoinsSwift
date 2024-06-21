//
//  ProfileView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @AppStorage("num_friends") public var num_friends:Int?
    @AppStorage("darkMode") var darkMode: Bool?
    @StateObject private var viewModel = ProfileViewModel()
    var newCustomColorsModel = CustomColorsModel()

    var body: some View {
        ZStack{
            if darkMode ?? false {
                Color(.black).ignoresSafeArea()
            }
            else{
                newCustomColorsModel.colorSchemeTwo.ignoresSafeArea()
            }
            if viewModel.gotProfileView{
                VStack(spacing: UIScreen.main.bounds.width * 0.01){
                    Spacer()
                    VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.009){
                        Text(viewModel.userModel.username ?? "No USERNAME")
                            .font(.system(size: UIScreen.main.bounds.width * 0.12))
                            .foregroundColor(darkMode ?? false ? .white : .black)
                            .fontWeight(.bold)
                        Rectangle()
                            .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.005)
                    }
                    Text(viewModel.tapDash ?? false ? " TAPDASH RANK: " + viewModel.league_title : " FREE PLAY RANK: " + viewModel.league_title)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.033, alignment: .leading)
                        .background(viewModel.leagueColor)
                        .foregroundColor(viewModel.leageForeground)
                        .border(Color(.black), width: UIScreen.main.bounds.width * 0.005)
                        .padding()
                    
                        VStack(spacing: UIScreen.main.bounds.width * 0.02){
                            if viewModel.showRequest{
                                HStack{
                                    Spacer()
                                    if viewModel.userModel.is_guest ?? false{
                                        VStack{
                                            Text("Guest cannot add friends!")
                                                .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                                .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                                .fontWeight(.bold)
                                            Text("Go to the settings and add your account information first.")
                                                .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                                .underline()
                                            Button(action: {
                                                if viewModel.haptics_on ?? true{
                                                    HapticManager.instance.impact(style: .medium)
                                                }
                                                viewModel.showRequest = false
                                            }, label: {
                                                Text("Exit")
                                                    .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                                                    .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                                    .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                                    .fontWeight(.bold)
                                                    .cornerRadius(8)
                                            }).padding()
                                        }
                                    }
                                    else{
                                        HStack{
                                            Spacer()
                                            VStack{
                                                Text("Search for username")
                                                    .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                                    .underline()
                                                TextField("Search", text: $viewModel.sUsername)
                                                    .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                                Rectangle()
                                                    .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                                    .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.001)
                                                if viewModel.usernameRes{
                                                    Text(viewModel.result)
                                                        .foregroundColor(newCustomColorsModel.colorSchemeSeven)
                                                        .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                                }
                                                if viewModel.invalid_entry{
                                                    Text(viewModel.result)
                                                        .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                                        .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                                }
                                                HStack{
                                                    Button(action: {
                                                        if viewModel.haptics_on ?? true{
                                                            HapticManager.instance.impact(style: .medium)
                                                        }
                                                        viewModel.showRequest = false
                                                    }, label: {
                                                        Text("Cancel")
                                                            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                                            .cornerRadius(8)
                                                            .shadow(color: newCustomColorsModel.colorSchemeTen, radius: UIScreen.main.bounds.width * 0.005, x: 0, y: UIScreen.main.bounds.width * 0.02)
                                                    }).padding()
                                                    Button(action: {
                                                        if viewModel.haptics_on ?? true{
                                                            HapticManager.instance.impact(style: .medium)
                                                        }
                                                        viewModel.pressed_send_request ? nil : viewModel.sendRequestTask()
                                                    }, label: {
                                                        Text("Send")
                                                            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                                            .cornerRadius(8)
                                                            .shadow(color: newCustomColorsModel.colorSchemeTen, radius: UIScreen.main.bounds.width * 0.005, x: 0, y: UIScreen.main.bounds.width * 0.02)
                                                    }).padding()
                                                }
                                            }
                                            Spacer()
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            else{
                                Spacer()
                                Text(viewModel.tapDash ?? false ? "TapDash Stats" : "Free Play Stats")
                                    .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                    .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                    .underline()
                                HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.2){
                                    if viewModel.tapDash ?? false || viewModel.userModel.tap_coin ?? 0 > 0{
                                        VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.008){
                                            Text("Today's TapCoins:")
                                                .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                                .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                                .underline()
                                            Text(String(viewModel.userModel.tap_coin  ?? 0))
                                                .bold()
                                                .font(.system(size: UIScreen.main.bounds.width * 0.044))
                                            Rectangle()
                                                .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                                .frame(width: UIScreen.main.bounds.width * 0.28, height: UIScreen.main.bounds.height * 0.005)
                                            Text("1 TapCoin = $0.10")
                                                .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                                .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                        }
                                    }
                                }
                                HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.2){
                                    VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.008){
                                        Text("Total Games:")
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                            .underline()
                                        Text(String(viewModel.tapDash ?? false ? viewModel.userModel.tap_dash_games ?? 0 : viewModel.userModel.free_play_games ?? 0 ))
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .bold()
                                            .font(.system(size: UIScreen.main.bounds.width * 0.044))
                                        Rectangle()
                                            .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.005)
                                    }
                                    VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.008){
                                        Text("Best Streak:")
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                            .underline()
                                        Text(String(viewModel.tapDash ?? false ? viewModel.userModel.tap_dash_best_streak ?? 0 : viewModel.userModel.free_play_best_streak ?? 0))
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .bold()
                                            .font(.system(size: UIScreen.main.bounds.width * 0.044))
                                        Rectangle()
                                            .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.005)
                                    }
                                }
                                HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.2){
                                    VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.008){
                                        Text("Total Wins:")
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                            .underline()
                                        Text(String(viewModel.tapDash ?? false ? viewModel.userModel.tap_dash_wins ?? 0 : viewModel.userModel.free_play_wins ?? 0))
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .bold()
                                            .font(.system(size: UIScreen.main.bounds.width * 0.044))
                                        Rectangle()
                                            .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.005)
                                    }
                                    VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.008){
                                        Text("Total Losses:")
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                            .underline()
                                        Text(String(viewModel.tapDash ?? false ? viewModel.userModel.tap_dash_losses ?? 0 : viewModel.userModel.free_play_losses ?? 0 ))
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .bold()
                                            .font(.system(size: UIScreen.main.bounds.width * 0.044))
                                        Rectangle()
                                            .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.005)
                                    }
                                }
                                Spacer()
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.28, alignment: .center)
                        .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                        .border(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour, width: UIScreen.main.bounds.width * 0.04)
                        .cornerRadius(UIScreen.main.bounds.width * 0.06)
                    Spacer()
                    BannerAd(unitID: "ca-app-pub-3940256099942544/2435281174") // Fake Ad Unit
                    Spacer()
                    HStack{
                        VStack(alignment: .leading, spacing: 0.0){
                            HStack(alignment: .center, spacing: 0.0){
                                Text("Friends: ")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                    .fontWeight(.bold)
                                    .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                    .padding(UIScreen.main.bounds.width * 0.003)
                                Text(String(num_friends ?? 0))
                                    .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                    .fontWeight(.bold)
                                    .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                    .padding(UIScreen.main.bounds.width * 0.003)
                            }
                            Rectangle()
                                .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.01)
                            Spacer().frame(height: UIScreen.main.bounds.height * 0.009)
                            Button(action: {
                                if viewModel.haptics_on ?? true{
                                    HapticManager.instance.impact(style: .medium)
                                }
                                viewModel.showRequest = !viewModel.showRequest
                            }, label: {
                                Text("Add Friend")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                    .fontWeight(.bold)
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                    .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                    .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                    .cornerRadius(10)
                            })
                            Spacer().frame(height: UIScreen.main.bounds.height * 0.009)
                            NavigationLink(isActive:$viewModel.friendsViewNavIsActive,destination: {
                                FriendsView()
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarItems(leading: BackButtonView(opposite: true))
                            }, label: {
                                Button(action: {
                                    if viewModel.haptics_on ?? true{
                                        HapticManager.instance.impact(style: .medium)
                                    }
                                    viewModel.friendsViewNavIsActive = true
                                }, label: {
                                    HStack{
                                        Text("View Friends")
                                            .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                            .fontWeight(.bold)
                                        if viewModel.userModel.hasRQ ?? false{
                                            Text("!")
                                                .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                                .fontWeight(.bold)
                                                .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.02, alignment: .center)
                                                .background(newCustomColorsModel.colorSchemeFive)
                                                .foregroundColor(newCustomColorsModel.colorSchemeOne)
                                                .cornerRadius(30)
                                        }
                                        else if viewModel.userModel.hasGI ?? false{
                                            Text("!")
                                                .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                                .fontWeight(.bold)
                                                .frame(width: UIScreen.main.bounds.height * 0.02, height: UIScreen.main.bounds.height * 0.02, alignment: .center)
                                                .background(newCustomColorsModel.colorSchemeFive)
                                                .foregroundColor(newCustomColorsModel.colorSchemeOne)
                                                .cornerRadius(30)
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                    .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                    .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                    .cornerRadius(10)
                                })
                                
                            })
                        }.padding()
                    }
                }
            }
            else{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeFour))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
        }
    } //Some View
} //View
