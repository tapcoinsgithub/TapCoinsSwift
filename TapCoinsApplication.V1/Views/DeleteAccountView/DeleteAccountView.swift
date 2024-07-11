//
//  DeleteAccountView.swift
//  TapCoinsApplication.V1
//
//  Created by Eric Viera on 5/8/24.
//

import Foundation
import SwiftUI

struct DeleteAccountView: View {
    @StateObject private var viewModel = DeleteAccountViewModel()
    var newCustomColorsModel = CustomColorsModel()
    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeFour.ignoresSafeArea()
            if (viewModel.delete_pressed || viewModel.pressed_confirm_password){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeOne))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
            else{
                if viewModel.confirmed_current_password{
                    VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.05){
                        if #available(iOS 16.0, *) {
                            Text("Are you sure you want to delete your account? All of your data will be lost including all of your streaks and wins.")
                                .frame(width: UIScreen.main.bounds.width * 0.8, alignment: .center)
                                .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                .foregroundColor(newCustomColorsModel.colorSchemeOne)
                                .bold()
                                .underline(true)
                        }
                        else{
                            Text("Are you sure you want to delete your account? All of your data will be lost including all of your streaks and wins.")
                                .frame(width: UIScreen.main.bounds.width * 0.8, alignment: .center)
                                .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                .foregroundColor(newCustomColorsModel.colorSchemeOne)
                        }
                        if viewModel.deleteAccountError {
                            Label("Unable to delete account.", systemImage: "xmark.octagon")
                                .foregroundColor(newCustomColorsModel.colorSchemeFive)
                        }
                        Button(action: {viewModel.delete_pressed ? nil : viewModel.deleteAccountTask()}, label: {
                            if #available(iOS 16.0, *) {
                                Text("Confirm")
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                                    .background(newCustomColorsModel.colorSchemeOne)
                                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                    .fontWeight(.bold)
                                    .cornerRadius(8)
                            }
                            else{
                                Text("Confirm")
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                                    .background(newCustomColorsModel.colorSchemeOne)
                                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                    .cornerRadius(8)
                            }
                            
                        }).padding()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.3, alignment: .center)
                    .padding(3)
                }
                else{
                    VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.05){
                        if #available(iOS 16.0, *) {
                            Text("Input password to delete account.")
                                .frame(width: UIScreen.main.bounds.width * 0.8, alignment: .center)
                                .font(.system(size: UIScreen.main.bounds.width * 0.037))
                                .foregroundColor(newCustomColorsModel.colorSchemeOne)
                                .bold()
                                .underline(true)
                        }
                        else{
                            Text("Input password to delete account.")
                                .frame(width: UIScreen.main.bounds.width * 0.8, alignment: .center)
                                .font(.system(size: UIScreen.main.bounds.width * 0.037))
                                .foregroundColor(newCustomColorsModel.colorSchemeOne)
                        }
                        SecureField("Password", text: $viewModel.password)
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                            .foregroundColor(Color(.black))
                            .background(Color(.white))
                        if viewModel.confirm_password_error {
                            Label("Invalid Password.", systemImage: "xmark.octagon")
                                .foregroundColor(newCustomColorsModel.colorSchemeFive)
                        }
                        Button(action: {viewModel.pressed_confirm_password ? nil : viewModel.confirmPasswordTask()}, label: {
                            if #available(iOS 16.0, *) {
                                Text("Confirm")
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                                    .background(newCustomColorsModel.colorSchemeOne)
                                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                    .fontWeight(.bold)
                                    .cornerRadius(8)
                            }
                            else{
                                Text("Confirm")
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                                    .background(newCustomColorsModel.colorSchemeOne)
                                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                    .cornerRadius(8)
                            }
                        }).padding()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.25, alignment: .center)
                    .padding(3)
                }
            }
        } // ZStack
    }
}
