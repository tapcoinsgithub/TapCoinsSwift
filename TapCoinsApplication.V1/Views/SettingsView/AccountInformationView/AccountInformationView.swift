//
//  AccountInformationView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct AccountInformationView: View {
    @AppStorage("darkMode") var darkMode: Bool?
    @StateObject private var viewModel = AccountInformationViewModel()
    var newCustomColorsModel = CustomColorsModel()
    var body: some View {
        ZStack{
            if darkMode ?? false {
                Color(.black).ignoresSafeArea()
            }
            else{
                newCustomColorsModel.colorSchemeTwo.ignoresSafeArea()
            }
            if viewModel.show_code_screen{
                VStack{
                    if viewModel.show_text_code{
                        Text(viewModel.confirm_code_message).foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                    }
                    else if viewModel.show_email_code{
                        Text(viewModel.confirm_code_message).foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                    }
                    Rectangle()
                        .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.01)
                    Form{
                        Section(header: Text("")){
                            if viewModel.is_error{
                                Label(viewModel.error, systemImage: "xmark.octagon")
                                    .foregroundColor(newCustomColorsModel.colorSchemeFive)
                            }
                            TextField("Code", text: $viewModel.code)
                        }
                    }.scrollContentBackground(.hidden)
                    if viewModel.saved_phone_number {
                        Text("Phone Number has been saved!").foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                    }
                    if viewModel.successfully_sent_code {
                        Text("Successfully sent a new code.").foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                    }
                    Spacer()
                    Text("If you did not receive a code then press 'Send Again' below.").foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                    Button(action: {viewModel.send_code_pressed ? nil : viewModel.confirmCodeTask()}, label: {
                        Text("Submit")
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                            .cornerRadius(8)
                    }).padding()
                    Button(action: {viewModel.send_code_pressed ? nil : viewModel.sendCodeTask()}, label: {
                        Text("Send Again")
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                            .cornerRadius(8)
                    }).padding()
                }
            }
            else{
                VStack{
                    Text("Account Information")
                        .font(.system(size: UIScreen.main.bounds.width * 0.05))
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.08)
                        .foregroundColor(.black)
                        .background(newCustomColorsModel.colorSchemeTen)
                    if viewModel.saved{
                        Label(viewModel.message, systemImage: "checkmark.seal")
                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                    }
                    if viewModel.show_guest_message{
                        Label(viewModel.message, systemImage: "xmark.seal")
                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                    }
                    VStack{
                        Text("View or Change your account information below.").foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                        Text("Tap 'Update password' to change your password.").foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                    }
                    if viewModel.set_page_data{
                        Form{
                            Section(header: Text("First name").foregroundColor(.black)){
                                TextField(viewModel.first_name, text: $viewModel.first_name)
                            }
                            Section(header: Text("Last name").foregroundColor(.black)){
                                TextField(viewModel.last_name, text: $viewModel.last_name)
                            }
                            Section(header: Text("Enter either the phone number and/or email associated with your zelle account in order to participate in TapDash.").foregroundColor(.black)){
                                TextField(viewModel.phone_number == "" ? "Phone Number" : viewModel.phone_number, text: $viewModel.phone_number)
                                if viewModel.is_phone_error || viewModel.phone_number == "Invalid"{
                                    Label(viewModel.phone_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                }
                                TextField(viewModel.email_address == "" ? "Email Address" : viewModel.email_address, text: $viewModel.email_address)
                                if viewModel.is_email_error{
                                    Label(viewModel.email_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                }
                            }
                            Section(header: Text("Username (this is what public users will see)").foregroundColor(.black)){
                                TextField(viewModel.username, text: $viewModel.username)
                                if viewModel.is_uName_error{
                                    Label(viewModel.username_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                }
                            }
                            Section{
                                if viewModel.is_guest{
                                    if viewModel.gsave_pressed ?? false{
                                        NavigationLink(destination: CreatePasswordView().navigationBarBackButtonHidden(true)
                                            .navigationBarItems(leading: RedBackButtonView())
                                                       , label: {Text("Create password").foregroundColor(.black).underline(true)})
                                    }
                                    else{
                                        Button(action: {
                                            viewModel.message = "Must save data before creating a password."
                                            viewModel.show_guest_message = true
                                        }, label: {Text("Create password").foregroundColor(.black).underline(true)})
                                    }
                                }
                                else{
                                    NavigationLink(destination: CreatePasswordView().navigationBarBackButtonHidden(true)
                                        .navigationBarItems(leading: RedBackButtonView()), label: {Text("Update password").foregroundColor(.black).underline(true)})
                                }
                                NavigationLink(destination: SecurityQuestionsComponentView(is_settings:true).navigationBarBackButtonHidden(true)
                                    .navigationBarItems(leading: RedBackButtonView()), label: {Text("Show Security Questions").foregroundColor(.black).underline(true)})
                                if viewModel.is_guest == false {
                                    NavigationLink(destination: DeleteAccountView().navigationBarBackButtonHidden(true)
                                        .navigationBarItems(leading: RedBackButtonView()), label: {Text("Delete Account").foregroundColor(newCustomColorsModel.colorSchemeFive).underline(true)})
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.6, alignment: .bottom)
                        .background(newCustomColorsModel.colorSchemeTen)
                    }
                    else{
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeOne))
                            .scaleEffect(UIScreen.main.bounds.width * 0.01)
                    }
                    
                    Button(action: {viewModel.save_pressed ? nil : viewModel.saveTask()}, label: {
                        Text("Save")
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                            .cornerRadius(8)
                    })
                }.scrollContentBackground(.hidden)
            }
        } // ZStack
    }
}