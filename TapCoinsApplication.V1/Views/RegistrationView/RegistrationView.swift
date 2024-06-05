//
//  RegistrationView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct RegistrationView: View {
    
    @StateObject private var viewModel = RegistrationViewModel()
    var newCustomColorsModel = CustomColorsModel()
    
    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeTwo.ignoresSafeArea()
            if (viewModel.reg_pressed){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeFour))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
            else{
                VStack(alignment: .center, spacing: 0){
                    ScrollView{
                        Text("Register")
                            .font(.system(size: UIScreen.main.bounds.width * 0.14))
                            .foregroundColor(newCustomColorsModel.colorSchemeFour)
                        Form{
                            Section(header: Text("")){
                                TextField("First Name (optional)", text: $viewModel.first_name)
                                TextField("Last Name (optional)", text: $viewModel.last_name)
                            }
                            if viewModel.register_error{
                                Label(viewModel.register_error_string, systemImage: "info.circle")
                                    .foregroundColor(newCustomColorsModel.colorSchemeFive)
                            }
                            Section{
                                TextField("Username", text: $viewModel.username)
                                if viewModel.is_uName_error{
                                    Label(viewModel.username_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                }
                                SecureField("Password", text: $viewModel.password)
                                if viewModel.is_password_error{
                                    Label(viewModel.password_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                }
                                SecureField("Confirm password", text: $viewModel.confirm_password)
                                if viewModel.is_password_error{
                                    Label(viewModel.password_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.6, alignment: .bottom)
                        .scrollContentBackground(.hidden)
                        Button(action: {viewModel.reg_pressed ? nil : viewModel.register()}, label: {
                            Text("Register")
                                .frame(width: 200, height: 50, alignment: .center)
                                .background(newCustomColorsModel.colorSchemeFour)
                                .foregroundColor(newCustomColorsModel.colorSchemeTwo)
                                .cornerRadius(8)
                        })
                        HStack{
                            Text("By registering you agree to our ")
                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                .font(.system(size: UIScreen.main.bounds.width * 0.04))
                            Link("Privacy Policy", destination: URL(string: "https://app.websitepolicies.com/policies/view/dgg6h68x") ?? URL(string: "")!)
                        }
                        .padding()
                    }
                }
            }
        } // ZStack
    }
}
