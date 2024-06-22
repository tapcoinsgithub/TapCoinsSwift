//
//  ChangePasswordView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct ChangePasswordView: View {
    @AppStorage("session") var logged_in_user: String?
    @StateObject private var viewModel = ChangePasswordViewModel()
    @StateObject private var contentViewModel = ContentViewModel()
    @Environment(\.presentationMode) var presentationMode
    var newCustomColorsModel = CustomColorsModel()
    
    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeFour.ignoresSafeArea()
            VStack{
                Text("Change Password")
                    .font(.system(size: UIScreen.main.bounds.width * 0.1))
                    .foregroundColor(newCustomColorsModel.colorSchemeOne)
                if viewModel.submit_pressed{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeOne))
                        .scaleEffect(UIScreen.main.bounds.width * 0.01)
                }
                else{
                    Form{
                        Section(header: Text("")){
                            if viewModel.is_error{
                                Label(viewModel.error, systemImage: "xmark.octagon")
                                    .foregroundColor(newCustomColorsModel.colorSchemeFive)
                            }
                            Text("New Password:")
                            SecureField("Password", text: $viewModel.password)
                            if viewModel.is_match_error{
                                Label("Passwords must match", systemImage: "xmark.octagon")
                                    .foregroundColor(newCustomColorsModel.colorSchemeFive)
                            }
                            if viewModel.is_password_error{
                                Label("Password can't be blank.", systemImage: "xmark.octagon")
                                    .foregroundColor(newCustomColorsModel.colorSchemeFive)
                            }
                            Text("Confirm New Password:")
                            SecureField("Confirm Password", text: $viewModel.c_password)
                            if viewModel.is_match_error{
                                Label("Passwords must match", systemImage: "xmark.octagon")
                                    .foregroundColor(newCustomColorsModel.colorSchemeFive)
                            }
                        }
                        .listRowBackground(Color.white)
                    }
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.3, alignment: .bottom)
                    .scrollContentBackground(.hidden)
                }
                if viewModel.submitted {
                    Text("New password saved!")
                        .foregroundColor(newCustomColorsModel.colorSchemeOne)
                }
                VStack{
                    Button(action: {
                        print("SUBMITTING")
                        if !viewModel.submit_pressed{
                            print("SUBMIT PRESSED IS FALSE")
                            viewModel.changePasswordTask()
                        }
                    }, label: {
                        Text("Submit")
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(newCustomColorsModel.colorSchemeOne)
                            .foregroundColor(newCustomColorsModel.colorSchemeFour)
                            .cornerRadius(8)
                    }).padding()
                    
                    Button(action: {
                        print("LEAVING")
                        if !viewModel.submit_pressed{
                            logged_in_user = nil
                            viewModel.changing_password = false
                        }
                    }, label: {
                        Text("Return Home")
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(newCustomColorsModel.colorSchemeFour)
                            .foregroundColor(newCustomColorsModel.colorSchemeOne)
                            .cornerRadius(8)
                    }).padding()
                }
            }
            
            
        }
    }
}
