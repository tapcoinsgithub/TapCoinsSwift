//
//  ContentView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import SwiftUI

@available(iOS 17.0, *)
struct ContentView: View {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("pGame") var pGame: String?
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("changing_password") private var changing_password: Bool?
    @StateObject private var viewModel = ContentViewModel()
    var newCustomColorsModel = CustomColorsModel()
    var body: some View {
        NavigationView{
            ZStack {
                if changing_password ?? false{
                    ChangePasswordView()
                }
                else{
                    if logged_in_user != nil{
                        if in_queue ?? false{
                            QueueView()
                        }
                        else{
                            if in_game ?? false {
                                GameView()
                            }
                            else{
                                HomeView()
                            }
                        }
                    }
                    else{
                        LoginView()
                            .navigationBarItems(leading: Button(action: {
                                viewModel.guestLoginTask()
                            }, label: {
                                HStack{
                                    Text(viewModel.glPressed ? "Logging in..." : "Continue as Guest")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                    Label("", systemImage: "person.crop.square.fill")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                }
                                
                            })
                                .background(newCustomColorsModel.colorSchemeOne)
                                .cornerRadius(8)
                            )
                    }
                }
                
            }
        }
    }
}
