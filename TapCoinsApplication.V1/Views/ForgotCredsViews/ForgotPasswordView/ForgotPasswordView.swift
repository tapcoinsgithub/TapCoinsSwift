//
//  ForgotPasswordView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View {

    @StateObject private var viewModel = ForgotPasswordViewModel()
    @Environment(\.presentationMode) var presentationMode
    var newCustomColorsModel = CustomColorsModel()

    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeTwo.ignoresSafeArea()
            if viewModel.send_pressed{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeFour))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
            else{
                VStack{
                    Spacer()
                    if viewModel.successfully_sent{
                        Text("Input the code and your new password.")
                            .foregroundColor(newCustomColorsModel.colorSchemeFour)
                            .font(.system(size: UIScreen.main.bounds.width * 0.05))
                            .padding()
                        Rectangle()
                            .fill(newCustomColorsModel.colorSchemeFour)
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.01)
                        if #available(iOS 16.0, *) {
                            Form{
                                Section(header: Text("")){
                                    if viewModel.is_error{
                                        Label(viewModel.error, systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                    TextField("Code", text: $viewModel.code)
                                    SecureField("Password", text: $viewModel.password)
                                    if viewModel.is_match_error{
                                        Label("Passwords must match", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                    if viewModel.is_password_error{
                                        Label("Password can't be blank.", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                    SecureField("Confirm Password", text: $viewModel.c_password)
                                    if viewModel.is_match_error{
                                        Label("Passwords must match", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                }
                            }.scrollContentBackground(.hidden)
                        }
                        else{
                            Form{
                                Section(header: Text("")){
                                    if viewModel.is_error{
                                        Label(viewModel.error, systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                    TextField("Code", text: $viewModel.code)
                                    SecureField("Password", text: $viewModel.password)
                                    if viewModel.is_match_error{
                                        Label("Passwords must match", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                    if viewModel.is_password_error{
                                        Label("Password can't be blank.", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                    SecureField("Confirm Password", text: $viewModel.c_password)
                                    if viewModel.is_match_error{
                                        Label("Passwords must match", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                }
                            }
                        }
                        Spacer()
                        if viewModel.submitted{
                            Label("New password saved successfully!", systemImage: "checkmark.seal.fill")
                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                        }
                        else{
                            Label("Message sent!", systemImage: "checkmark.circle.fill")
                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                .padding()
                            Text("If you did not see a message please press")
                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                            Text("send again.")
                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                        }
                        Spacer()
                        Button(action: {viewModel.send_pressed ? nil : viewModel.submitTask()}, label: {
                            Text("Submit")
                                .frame(width: 200, height: 50, alignment: .center)
                                .background(newCustomColorsModel.colorSchemeFour)
                                .foregroundColor(newCustomColorsModel.colorSchemeTwo)
                                .cornerRadius(8)
                        }).padding()
                        Button(action: {viewModel.send_pressed ? nil : viewModel.sendCodeTask()}, label: {
                            Text("Send Again")
                                .frame(width: 200, height: 50, alignment: .center)
                                .background(newCustomColorsModel.colorSchemeFour)
                                .foregroundColor(newCustomColorsModel.colorSchemeTwo)
                                .cornerRadius(8)
                        }).padding()
                    }
                    else{
                        Spacer()
                        Text("Input the phone number or email address associated with your account and we will send you a code to reset your password.")
                            .foregroundColor(newCustomColorsModel.colorSchemeFour)
                            .font(.system(size: UIScreen.main.bounds.width * 0.05))
                            .padding()
                        Rectangle()
                            .fill(newCustomColorsModel.colorSchemeFour)
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.01)
                        if #available(iOS 16.0, *) {
                            Form{
                                Section(header: Text("")){
                                    TextField("Phone number", text: $viewModel.phone_number)
                                    if viewModel.is_phone_error{
                                        Label("Invalid phone number", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                }
                                Section(header: Text("")){
                                    TextField("Email address", text: $viewModel.email_address)
                                    if viewModel.is_email_error{
                                        Label("Invalid email address", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                }

                            }
                            .scrollContentBackground(.hidden)
                        }else{
                            Form{
                                Section(header: Text("")){
                                    TextField("Phone number", text: $viewModel.phone_number)
                                    if viewModel.is_phone_error{
                                        Label("Invalid phone number", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                }
                                Section(header: Text("")){
                                    TextField("Email address", text: $viewModel.email_address)
                                    if viewModel.is_email_error{
                                        Label("Invalid email address", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                }
                            }
                        }
                        Spacer()
                        if viewModel.is_error {
                            Label(viewModel.error, systemImage: "xmark.octagon")
                                .foregroundColor(newCustomColorsModel.colorSchemeFive)
                        }
                        Spacer()
//                        NavigationLink(destination: {
//                            SecurityQuestionsView()
//                                .navigationBarBackButtonHidden(true)
//                                .navigationBarItems(leading: RedBackButtonView())
//                        }, label: {
//                            Text("Click here to answer security questions instead.")
//                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
//                                .underline(true)
//                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.13, alignment: .center)
//                                .cornerRadius(UIScreen.main.bounds.width * 0.02)
//                        })
                        Button(action: {viewModel.send_pressed ? nil : viewModel.sendCodeTask()}, label: {
                            Text("Send")
                                .frame(width: 200, height: 50, alignment: .center)
                                .background(newCustomColorsModel.colorSchemeFour)
                                .foregroundColor(newCustomColorsModel.colorSchemeTwo)
                                .cornerRadius(8)
                        }).padding()

                    }

                }
            }
            
        } // ZStack
    }
}
