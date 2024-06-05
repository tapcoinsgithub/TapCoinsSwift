//
//  PGameView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI
import zlib

struct PGameView: View {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("pGame") var pGame: String?
    @AppStorage("haptics") var haptics_on:Bool?
    @AppStorage("darkMode") var darkMode: Bool?
    @StateObject private var viewModel = PGameViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var int_ex = 0
    var newCustomColorsModel = CustomColorsModel()

    var body: some View {
        ZStack{
            if darkMode ?? false {
                Color(.black).ignoresSafeArea()
            }
            else{
                newCustomColorsModel.colorSchemeTwo.ignoresSafeArea()
            }
                    HStack{
                        HStack{
                            Text(viewModel.username)
                                .font(.system(size: UIScreen.main.bounds.width * 0.06))
                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                            Text(String(viewModel.fPoints))
                                .font(.system(size: UIScreen.main.bounds.width * 0.06))
                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                        }
                        Rectangle()
                            .fill(Color(.black))
                            .frame(width: UIScreen.main.bounds.width * 0.03, height: UIScreen.main.bounds.height * 0.06)
                        HStack{
                            Text("Computer")
                                .font(.system(size: UIScreen.main.bounds.width * 0.06))
                                .foregroundColor(newCustomColorsModel.colorSchemeFive)
                            Text(String(viewModel.sPoints))
                                .font(.system(size: UIScreen.main.bounds.width * 0.06))
                                .foregroundColor(newCustomColorsModel.colorSchemeFive)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.06)
                    .background(newCustomColorsModel.colorSchemeSix)
                    .offset(x: 0.0, y: UIScreen.main.bounds.height * -0.4)
                    .padding()
            
            VStack(alignment: .center, spacing:viewModel.smaller_screen ? UIScreen.main.bounds.width * 0.005 : UIScreen.main.bounds.width * 0.01){
                Spacer()
                ForEach(viewModel.coins.indices, id:\.self){ index in
                    if viewModel.coins[index]{
                        HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                            PCoinView(viewModel: viewModel, x_val: 0, y_val: index)
                            PCoinView(viewModel: viewModel, x_val: 1, y_val: index)
                            PCoinView(viewModel: viewModel, x_val: 2, y_val: index)
                            PCoinView(viewModel: viewModel, x_val: 3, y_val: index)
                        }

                    }
                    else{
                        HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                            PCoinView(viewModel: viewModel, x_val: 0, y_val: index)
                            PCoinView(viewModel: viewModel, x_val: 1, y_val: index)
                            PCoinView(viewModel: viewModel, x_val: 2, y_val: index)
                        }//HStack
                    } //Else
                }//ForEach
            }//VStack
            if (viewModel.gameStarted == false){
                Text(viewModel.gameStart)
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                    .background(newCustomColorsModel.colorSchemeFour)
                    .foregroundColor(newCustomColorsModel.colorSchemeTwo)
                    .cornerRadius(10)
            }

            if (viewModel.endGame){
                VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                    if (viewModel.changing_diff){
                        Text("Choose Difficulty").foregroundColor(newCustomColorsModel.colorSchemeFive)
                        Button(action: {
                            viewModel.change_difficulty(change: viewModel.change_value1)
                        }, label: {
                            Text(viewModel.change_text1)
                        })
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                            .background(newCustomColorsModel.colorSchemeFour)
                            .foregroundColor(newCustomColorsModel.colorSchemeOne)
                            .cornerRadius(5)
                        Button(action: {
                            viewModel.change_difficulty(change: viewModel.change_value2)
                        }, label: {
                            Text(viewModel.change_text2)
                        })
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                            .background(newCustomColorsModel.colorSchemeFour)
                            .foregroundColor(newCustomColorsModel.colorSchemeOne)
                            .cornerRadius(5)
                    }
                    else{
                        Text(viewModel.winner + " is the winner!")
                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                        Button(action: {
                            viewModel.play_again()
                        }, label: {
                            Text("Play again")
                        })
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.08, alignment: .center)
                        .background(newCustomColorsModel.colorSchemeFour)
                            .foregroundColor(newCustomColorsModel.colorSchemeOne)
                            .cornerRadius(5)
                        Button(action: {
                            viewModel.change_difficulty(change: "Change")
                        }, label: {
                            Text("Change difficulty")
                        })
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.08, alignment: .center)
                            .background(newCustomColorsModel.colorSchemeFour)
                            .foregroundColor(newCustomColorsModel.colorSchemeOne)
                            .cornerRadius(5)
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Return Home")
                        })
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.08, alignment: .center)
                            .background(newCustomColorsModel.colorSchemeFour)
                            .foregroundColor(newCustomColorsModel.colorSchemeOne)
                            .cornerRadius(5)
                    }

                }
                .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.33, alignment: .center)
                .background(newCustomColorsModel.colorSchemeOne)
                .cornerRadius(10)
            }
        }//ZStack view
    } //body view
} //PGameView
