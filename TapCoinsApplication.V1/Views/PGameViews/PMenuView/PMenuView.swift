//
//  PMenuView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct PMenuView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = PMenuViewModel()
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
                Spacer()
                Text("Choose Difficulty")
                    .font(.system(size: UIScreen.main.bounds.width * 0.1))
                    .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                    .fontWeight(.bold)
                Spacer()
                VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.2){
                    NavigationLink(isActive:$viewModel.easyModeNavIsActive, destination: {
                        PGameView()
                            .navigationBarBackButtonHidden(true)
                    }, label: {
                        Button(action: {
                            if viewModel.haptics_on ?? true{
                                HapticManager.instance.impact(style: .medium)
                            }
                            viewModel.easyModeNavIsActive = true
                        }, label: {
                            Text("Easy")
                                .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                                .fontWeight(.bold)
                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                .font(.system(size: UIScreen.main.bounds.width * 0.07))
                                .background(newCustomColorsModel.colorSchemeOne)
                                .cornerRadius(8)
                                .shadow(color: newCustomColorsModel.colorSchemeTen, radius: UIScreen.main.bounds.width * 0.02, x: 0, y: UIScreen.main.bounds.width * 0.04)
                        })
                    })
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded {
                                viewModel.got_difficulty(diff: "easy")
                            }
                    )
                    NavigationLink(isActive: $viewModel.mediumModeNavIsActive, destination: {
                        PGameView()
                            .navigationBarBackButtonHidden(true)
                    }, label: {
                        Button(action: {
                            if viewModel.haptics_on ?? true{
                                HapticManager.instance.impact(style: .medium)
                            }
                            viewModel.mediumModeNavIsActive = true
                        }, label: {
                            Text("Medium")
                                .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                                .fontWeight(.bold)
                                .foregroundColor(newCustomColorsModel.colorSchemeOne)
                                .font(.system(size: UIScreen.main.bounds.width * 0.07))
                                .background(newCustomColorsModel.colorSchemeFour)
                                .cornerRadius(8)
                                .shadow(color: newCustomColorsModel.colorSchemeTen, radius: UIScreen.main.bounds.width * 0.02, x: 0, y: UIScreen.main.bounds.width * 0.04)
                        })
                    })
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded {
                                viewModel.got_difficulty(diff: "medium")
                            }
                    )
                    NavigationLink(isActive: $viewModel.hardModeNavIsActive, destination: {
                        PGameView()
                            .navigationBarBackButtonHidden(true)
                    }, label: {
                        Button(action: {
                            if viewModel.haptics_on ?? true{
                                HapticManager.instance.impact(style: .medium)
                            }
                            viewModel.hardModeNavIsActive = true
                        }, label: {
                            Text("Hard")
                                .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                                .fontWeight(.bold)
                                .foregroundColor(newCustomColorsModel.colorSchemeOne)
                                .font(.system(size: UIScreen.main.bounds.width * 0.07))
                                .background(newCustomColorsModel.colorSchemeFive)
                                .cornerRadius(8)
                                .shadow(color: newCustomColorsModel.colorSchemeTen, radius: UIScreen.main.bounds.width * 0.02, x: 0, y: UIScreen.main.bounds.width * 0.04)
                        })
                    })
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded {
                                viewModel.got_difficulty(diff: "hard")
                            }
                    )
                }
                Spacer()
            }
        } // ZStack
    }

}
