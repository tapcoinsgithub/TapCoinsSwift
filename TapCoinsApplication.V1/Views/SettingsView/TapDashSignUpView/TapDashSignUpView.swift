//
//  TapDashSignUpView.swift
//  TapCoinsApplication.V1
//
//  Created by Eric Viera on 6/28/24.
//

import Foundation
import SwiftUI

struct TapDashSignUpView: View {
    @AppStorage("darkMode") var darkMode: Bool?
    @StateObject private var viewModel = TapDashSignUpViewModel()
    @Environment(\.presentationMode) var presentationMode
    var newCustomColorsModel = CustomColorsModel()
    
    
    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeFour.ignoresSafeArea()
            if (viewModel.signUpPressed){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeOne))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
            else{
                VStack{
                    Text("TapDash Sign Up")
                        .font(.system(size: UIScreen.main.bounds.width * 0.1))
                        .foregroundColor(newCustomColorsModel.colorSchemeOne)
                        .underline(true)
                    Form{
                        Text("To sign up please agree to the Terms and Conditions below, then go back to the Account View page and input your first and last name and the email address and/or phone number associated with your Zelle account.")
                        Section(header: Text("")){
                            VStack{
                                Text("By clicking the checkbox you are agreeing to TapCoins Terms and Conditions.")
                                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                Toggle(isOn: $viewModel.tocIsChecked) {
                                    HStack{
                                        Text("I agree to the ")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                            .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                        Link("Terms and Conditions.", destination: URL(string: "https://app.websitepolicies.com/policies/view/rnacpu04") ?? URL(string: "")!).font(.system(size: UIScreen.main.bounds.width * 0.04)).underline(true)
                                    }
                                  }
                                  .toggleStyle(CheckboxToggleStyle())
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.6, alignment: .bottom)
                    Button(action: {viewModel.signUpPressed ? nil : viewModel.signUpTask()}, label: {
                        Text("Sign up")
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(newCustomColorsModel.colorSchemeOne)
                            .foregroundColor(newCustomColorsModel.colorSchemeFour)
                            .cornerRadius(8)
                    }).padding()
                }
            }
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
