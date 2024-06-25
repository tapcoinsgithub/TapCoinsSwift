//
//  LoginView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    @Environment(\.presentationMode) var presentationMode
    var newCustomColorsModel = CustomColorsModel()
    
    
    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeFour.ignoresSafeArea()
            if (viewModel.log_pressed){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeOne))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
            else{
                VStack{
                    Text("Login")
                        .font(.system(size: UIScreen.main.bounds.width * 0.16))
                        .foregroundColor(newCustomColorsModel.colorSchemeOne)
                    Form{
                        Section(header: Text("")){
                            TextField("Username", text: $viewModel.username).foregroundColor(.black)
                            if viewModel.is_error{
                                Label(viewModel.user_error?.rawValue ?? "Something went wrong.", systemImage: "xmark.octagon")
                                    .foregroundColor(newCustomColorsModel.colorSchemeFive)
                            }
                            SecureField("Password", text: $viewModel.password).foregroundColor(.black)
                            if viewModel.is_error {
                                Label(viewModel.password_error?.rawValue ?? "Something went wrong.", systemImage: "xmark.octagon")
                                    .foregroundColor(newCustomColorsModel.colorSchemeFive)
                            }
                        }
                        .listRowBackground(Color.white)
                    }
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.3, alignment: .bottom)
                    .scrollContentBackground(.hidden)
                    Button(action: {viewModel.log_pressed ? nil : viewModel.loginTask()}, label: {
                        Text("Login")
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(newCustomColorsModel.colorSchemeOne)
                            .foregroundColor(newCustomColorsModel.colorSchemeFour)
                            .cornerRadius(8)
                    }).padding()
                    VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                        HStack{
                            NavigationLink(destination: ForgotUsernameView()
                                .navigationBarBackButtonHidden(true)
                                .navigationBarItems(leading: RedBackButtonView()), label: {Text("Forgot username").foregroundColor(newCustomColorsModel.colorSchemeOne).underline(true)})
                            NavigationLink(destination: ForgotPasswordView().navigationBarBackButtonHidden(true).navigationBarItems(leading: RedBackButtonView()), label: {Text("Forgot password").foregroundColor(newCustomColorsModel.colorSchemeOne).underline(true)})
                        }
                        HStack{
                            Text("Don't have an account? ").foregroundColor(newCustomColorsModel.colorSchemeOne)
                            NavigationLink(destination: {
                                RegistrationView()
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarItems(leading: BackButtonView())
                            }, label: {
                                Text("Register!")
                                    .underline(true)
                                    .foregroundColor(newCustomColorsModel.colorSchemeOne)
                            })
                        }
                    }
                    
                }
            }
        }
    }
}
