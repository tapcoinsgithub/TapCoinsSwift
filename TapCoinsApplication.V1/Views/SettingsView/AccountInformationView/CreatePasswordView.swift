//
//  CreatePasswordView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct CreatePasswordView: View {
    @StateObject private var viewModel = AccountInformationViewModel()
    var newCustomColorsModel = CustomColorsModel()
    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeFour.ignoresSafeArea()
            if (viewModel.save_p_pressed){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeOne))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
            else{
                if viewModel.confirmed_current_password || viewModel.is_guest {
                    VStack{
                        Spacer()
                        VStack{
                            Text("Create Password")
                                .foregroundColor(newCustomColorsModel.colorSchemeOne)
                                .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                .padding()
                        }
                        Rectangle()
                            .fill(newCustomColorsModel.colorSchemeOne)
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.01)
                        if #available(iOS 16.0, *){
                            Form{
                                Section(header: Text("New Password").foregroundColor(newCustomColorsModel.colorSchemeOne)){
                                    if viewModel.is_error{
                                        Label(viewModel.error, systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                    SecureField("password", text: $viewModel.password)
                                    if viewModel.is_match_error{
                                        Label("Passwords must match", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                    if viewModel.is_password_error{
                                        Label("Password can't be blank.", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                }
                                Section(header: Text("Confirm New Password").foregroundColor(newCustomColorsModel.colorSchemeOne)){
                                    SecureField("confirm password", text: $viewModel.cpassword)
                                    if viewModel.is_match_error{
                                        Label("Passwords must match", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                }
                            }
                            .scrollContentBackground(.hidden)
                        }
                        else{
                            Form{
                                Section(header: Text("New Password").foregroundColor(newCustomColorsModel.colorSchemeOne)){
                                    if viewModel.is_error{
                                        Label(viewModel.error, systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                    SecureField("password", text: $viewModel.password)
                                    if viewModel.is_match_error{
                                        Label("Passwords must match", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                    if viewModel.is_password_error{
                                        Label("Password can't be blank.", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                }
                                Section(header: Text("Confirm New Password").foregroundColor(newCustomColorsModel.colorSchemeOne)){
                                    SecureField("confirm password", text: $viewModel.cpassword)
                                    if viewModel.is_match_error{
                                        Label("Passwords must match", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                }
                            }
                        }
                        
                        if viewModel.psaved{
                            Spacer()
                            Label("Password Saved.", systemImage: "checkmark.circle.fill")
                                .foregroundColor(newCustomColorsModel.colorSchemeOne)
                            Spacer()
                        }
                        Button(action: {viewModel.save_p_pressed ? nil : viewModel.savePasswordTask()}, label: {
                            Text("Save")
                                .frame(width: 200, height: 50, alignment: .center)
                                .background(newCustomColorsModel.colorSchemeOne)
                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                .cornerRadius(8)
                        }).padding()
                    }// VStack
                }
                else{
                    VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.05){
                        if #available(iOS 16.0, *){
                            Text("Confirm Password to change password.")
                                .frame(width: UIScreen.main.bounds.width * 0.8, alignment: .center)
                                .font(.system(size: UIScreen.main.bounds.width * 0.037))
                                .foregroundColor(newCustomColorsModel.colorSchemeOne)
                                .bold()
                                .underline(true)
                        }
                        else{
                            Text("Confirm Password to change password.")
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
                            if #available(iOS 16.0, *){
                                Text("Confirm")
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                                    .background(newCustomColorsModel.colorSchemeOne)
                                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
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
