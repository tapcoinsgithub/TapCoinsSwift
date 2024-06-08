//
//  SettingsView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = SettingsViewModel()
    @AppStorage("notifications") var notifications_on:Bool?
    @AppStorage("haptics") var haptics_on:Bool?
    @AppStorage("sounds") var sound_on:Bool?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("darkMode") var darkMode: Bool?
    var newCustomColorsModel = CustomColorsModel()
    var body: some View {
        ZStack{
            if darkMode ?? false {
                Color(.black).ignoresSafeArea()
            }
            else{
                newCustomColorsModel.colorSchemeTwo.ignoresSafeArea()
            }
            VStack{
                Text("Settings:")
                    .font(.system(size: UIScreen.main.bounds.width * 0.08))
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.08)
                    .foregroundColor(.black)
                    .background(newCustomColorsModel.colorSchemeTen)
                Spacer()
                List{
                    Section(header: Text("View and edit your account information such as username, password, phone number, etc.")){
                        NavigationLink(destination: {
                            AccountInformationView()
                                .navigationBarBackButtonHidden(true)
                                .navigationBarItems(leading: BackButtonView())
                        }, label: {
                            VStack{
                                Text("Account Information")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                    .fontWeight(.bold)
                                    .frame(width: UIScreen.main.bounds.width * 0.75, alignment: .leading)
                                    .foregroundColor(.black)
                                Rectangle()
                                    .fill(.black)
                                    .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.001)
                            }
                        })
                    }
                    Section(header: Text("Toggle app settings such as notifications, sound, and vibrations.")){
                        NavigationLink(destination: {
                            ToggleSettingsView()
                                .navigationBarBackButtonHidden(true)
                                .navigationBarItems(leading: BackButtonView())
                        }, label: {
                            VStack{
                                Text("Toggle Settings")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                    .fontWeight(.bold)
                                    .frame(width: UIScreen.main.bounds.width * 0.75, alignment: .leading)
                                    .foregroundColor(.black)
                                Rectangle()
                                    .fill(.black)
                                    .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.001)
                            }
                        })
                    }
                } // List
                .foregroundColor(darkMode ?? false ? Color(.white) : Color(.black))
                .scrollContentBackground(.hidden)
                HStack{
                    Button(action: {
                        if viewModel.userModel?.is_guest ?? false{
                            if viewModel.show_logout_option{
                                viewModel.show_logout_option = false
                            }
                            else{
                                viewModel.show_logout_option = true
                            }
                        }
                        else{
                            viewModel.pressed_logout = true
                            viewModel.logoutTask()
                            print("LOGOUT OPTION")
                        }
                    }, label: {
                        Text("Logout")
                            .fontWeight(.bold)
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                            .cornerRadius(10)
                    })
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                .background(newCustomColorsModel.colorSchemeTen)
                if viewModel.show_logout_option{
                    HStack{
                        Spacer()
                        VStack{
                            Text("Are you sure you want to logout?")
                                .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                .bold()
                                .underline()
                            Text("You will lose all of your account data. To save it go to 'Account Information' above and create an account.")
                                .foregroundColor(newCustomColorsModel.colorSchemeOne)
                            Rectangle()
                                .fill(newCustomColorsModel.colorSchemeOne)
                                .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.001)
                            HStack{
                                Button(action: {viewModel.show_logout_option = false}, label: {
                                    Text("Cancel")
                                        .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                        .background(newCustomColorsModel.colorSchemeOne)
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                        .cornerRadius(8)
                                }).padding()
                                Button(action: {
                                    viewModel.pressed_logout = true
                                    viewModel.logoutTask()
                                    
                                }, label: {
                                    Text("Logout")
                                        .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                        .background(newCustomColorsModel.colorSchemeOne)
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                        .cornerRadius(8)
                                }).padding()
                            }
                        }
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.75, height: viewModel.smaller_screen ? UIScreen.main.bounds.height * 0.24 : UIScreen.main.bounds.height * 0.26, alignment: .center)
                    .background(newCustomColorsModel.colorSchemeFour)
                    .border(newCustomColorsModel.colorSchemeFive, width: UIScreen.main.bounds.width * 0.005)
                    .offset(x: 0, y: viewModel.smaller_screen ? -25 : -40)
                }
                Spacer()
            } // VStack
        } // ZStack
    }
}