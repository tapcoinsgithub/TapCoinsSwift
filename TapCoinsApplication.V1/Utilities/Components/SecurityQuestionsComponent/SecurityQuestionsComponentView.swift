//
//  SecurityQuestionsComponentView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct SecurityQuestionsComponentView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = SecurityQuestionsComponentViewModel()
    var newCustomColorsModel = CustomColorsModel()
    var is_settings:Bool
    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeFour.ignoresSafeArea()
            if viewModel.saved_questions_answers{
                VStack(alignment: .center){
                    HStack(alignment: .center){
                        Text("Saved Questions and Answers.")
                            .background(newCustomColorsModel.colorSchemeOne)
                    }
                }
            }
            else{
                if viewModel.is_loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeOne))
                        .scaleEffect(UIScreen.main.bounds.width * 0.01)
                }
                else{
                    if is_settings{
                        if viewModel.confirmed_password {
                            ScrollView{
                                VStack(spacing: UIScreen.main.bounds.width * 0.05){
                                    Text("Select two security questions.")
                                        .font(.system(size: UIScreen.main.bounds.width * 0.07))
                                    Text("Security questions will allow you to recover your account in case of a forgoten username or password.")
                                    Text("First Security Question and Answer:")
                                    Picker(selection: $viewModel.question_1, label: Text("Picker1")){
                                        ForEach(0..<5) { index in
                                            Text(viewModel.got_security_questions ? viewModel.options1[index] : String(index))
                                                .lineLimit(nil)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .tag(index)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    TextField(viewModel.answer_1, text: $viewModel.answer_1)
                                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.05)
                                        .border(.black, width: UIScreen.main.bounds.width * 0.008)
                                        .background(.white)
                                        .foregroundStyle(Color(.black))
                                    Text("Second Security Question and Answer:")
                                    Picker(selection: $viewModel.question_2, label: Text("Picker2")){
                                        ForEach(0..<5) { index in
                                            Text(viewModel.got_security_questions ? viewModel.options2[index] : String(index))
                                                .lineLimit(nil)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .tag(index)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    TextField(viewModel.answer_2, text: $viewModel.answer_2)
                                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.05)
                                        .border(.black, width: UIScreen.main.bounds.width * 0.008)
                                        .background(.white)
                                        .foregroundStyle(Color(.black))
                                    if viewModel.saveQAError {
                                        Label("Something went wrong.", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    }
                                    Button(action: {viewModel.pressed_check_and_set_sqs ? nil : viewModel.check_and_set_sqs()}, label: {
                                        if #available(iOS 16.0, *){
                                            Text("Save")
                                                .foregroundStyle(newCustomColorsModel.colorSchemeOne)
                                                .bold(true)
                                        }
                                        else{
                                            Text("Save")
                                                .foregroundStyle(newCustomColorsModel.colorSchemeOne)
                                        }
                                    })
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                    .background(newCustomColorsModel.colorSchemeFour)
                                    .cornerRadius(UIScreen.main.bounds.width * 0.02)
                                    Spacer()
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.8, alignment: .center)
                                .background(newCustomColorsModel.colorSchemeOne)
                                .cornerRadius(UIScreen.main.bounds.width * 0.05)
                            }
                        }
                        else{
                            VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.05){
                                if #available(iOS 16.0, *){
                                    Text("Confirm Password to edit Security Questions")
                                        .frame(width: UIScreen.main.bounds.width * 0.8, alignment: .center)
                                        .font(.system(size: UIScreen.main.bounds.width * 0.037))
                                        .foregroundColor(newCustomColorsModel.colorSchemeOne)
                                        .bold()
                                        .underline(true)
                                }
                                else{
                                    Text("Confirm Password to edit Security Questions")
                                        .frame(width: UIScreen.main.bounds.width * 0.8, alignment: .center)
                                        .font(.system(size: UIScreen.main.bounds.width * 0.037))
                                        .foregroundColor(newCustomColorsModel.colorSchemeOne)
                                }
                                
                                SecureField("Password", text: $viewModel.password)
                                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                                    .foregroundColor(Color(.black))
                                    .background(Color(.white))
                                if viewModel.password_error {
                                    Label("Invalid Password.", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                }
                                Button(action: {viewModel.pressed_confirm_password ? nil : viewModel.confirmPasswordTask()}, label: {
                                    if #available(iOS 16.0, *){
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
                    else{
                        ScrollView{
                            VStack(spacing: UIScreen.main.bounds.width * 0.05){
                                Spacer()
                                Text("Select two security questions.")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.07))
                                Text("Security questions will allow you to recover your account in case of a forgoten username or password.")
                                Text("First Security Question and Answer:")
                                Picker(selection: $viewModel.question_1, label: Text("Picker1")){
                                    ForEach(0..<5) { index in
                                        Text(viewModel.got_security_questions ? viewModel.options1[index] : String(index))
                                            .lineLimit(nil)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .tag(index)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                TextField(viewModel.answer_1, text: $viewModel.answer_1)
                                    .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.05)
                                    .border(.black, width: UIScreen.main.bounds.width * 0.008)
                                    .background(.white)
                                    .foregroundStyle(Color(.black))
                                Text("Second Security Question and Answer:")
                                Picker(selection: $viewModel.question_2, label: Text("Picker2")){
                                    ForEach(0..<5) { index in
                                        Text(viewModel.got_security_questions ? viewModel.options2[index] : String(index))
                                            .lineLimit(nil)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .tag(index)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                TextField(viewModel.answer_2, text: $viewModel.answer_2)
                                    .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.05)
                                    .border(.black, width: UIScreen.main.bounds.width * 0.008)
                                    .background(.white)
                                    .foregroundStyle(Color(.black))
                                HStack{
                                    Button(action: {viewModel.pressed_check_and_set_sqs ? nil : viewModel.check_and_set_sqs()}, label: {
                                        if #available(iOS 16.0, *){
                                            Text("Save")
                                                .foregroundColor(.black)
                                                .bold(true)
                                        }
                                        else{
                                            Text("Save")
                                                .foregroundColor(.black)
                                        }
                                    })
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                    .background(newCustomColorsModel.colorSchemeSeven)
                                    .cornerRadius(UIScreen.main.bounds.width * 0.02)
                                    
                                    Button(action: {
                                        print("Skipping")
                                        viewModel.show_security_questions = false
                                    }, label: {
                                        if #available(iOS 16.0, *){
                                            Text("Skip")
                                                .foregroundColor(.black)
                                                .bold(true)
                                        }
                                        else{
                                            Text("Skip")
                                                .foregroundColor(.black)
                                        }
                                    })
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                    .background(newCustomColorsModel.colorSchemeSix)
                                    .cornerRadius(UIScreen.main.bounds.width * 0.02)
                                }
                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.8, alignment: .center)
                            .background(newCustomColorsModel.colorSchemeOne)
                            .cornerRadius(UIScreen.main.bounds.width * 0.05)
                        }
                    } // Is Settings Else
                } // Is Loading Else
                
            } // Saved Questions Answers Else

        } // ZStack
    }
}
