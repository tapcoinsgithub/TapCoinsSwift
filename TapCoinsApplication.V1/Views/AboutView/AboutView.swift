//
//  AboutView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct AboutView: View {
    @AppStorage("darkMode") var darkMode: Bool?
    @Environment(\.presentationMode) var presentationMode
    var newCustomColorsModel = CustomColorsModel()
    
    let customGameStringVar = Text("Custom Games").font(.system(size: UIScreen.main.bounds.width * 0.055))
        .foregroundColor(CustomColorsModel().colorSchemeSeven)
    let tapDashStringVar = Text("TapDash").font(.system(size: UIScreen.main.bounds.width * 0.055))
        .foregroundColor(CustomColorsModel().colorSchemeFive)
    let tapCoinStringVar = Text("TapCoin").font(.system(size: UIScreen.main.bounds.width * 0.055))
        .foregroundColor(CustomColorsModel().colorSchemeOne)
    let tapCoinsStringVar = Text("TapCoins").font(.system(size: UIScreen.main.bounds.width * 0.055))
        .foregroundColor(CustomColorsModel().colorSchemeOne)
    
    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeFour.ignoresSafeArea()
            HStack{
                Spacer()
                VStack{
                    Text("About")
                        .font(.system(size: UIScreen.main.bounds.width * 0.1))
                        .foregroundColor(newCustomColorsModel.colorSchemeOne)
                        .underline()
                    ScrollView{
                        VStack{
                            VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.14){
                                HStack(alignment: .center, spacing: 0.0){
                                    Text("TAP")
                                        .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                        .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                        .fontWeight(.bold)
                                    Text("C")
                                        .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                        .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                        .fontWeight(.bold)
                                    Image("Custom_Color_1_TC")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: UIScreen.main.bounds.width * 0.07, height: UIScreen.main.bounds.width * 0.07, alignment: .center)
                                        .cornerRadius(100)
                                    Text("INS")
                                        .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                        .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                        .fontWeight(.bold)
                                }
                                
                                Text("TapCoins is a high-speed one vs one game where you have 15 seconds to tap as many coins as you can before your oppenent! Play against friends in \(customGameStringVar) or sign up with phone or email to enter \(tapDashStringVar) mode and play to win \(tapCoinsStringVar) and earn real money! For more information on \(tapDashStringVar) scroll below.")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.055))
                                    .foregroundColor(darkMode ?? false ? Color(.white) : Color(.black))
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.6, alignment: .center)
                            .background(darkMode ?? false ? Color(.black) : newCustomColorsModel.colorSchemeTwo)
                            .cornerRadius(UIScreen.main.bounds.width * 0.03)
                            VStack{
                                Rectangle()
                                    .fill(newCustomColorsModel.colorSchemeOne)
                                    .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.005)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.2, alignment: .center)
                        }
                        VStack{
                            VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.08){
                                VStack(alignment: .center){
                                    HStack{
                                        Image("Custom_Color_3_TC")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1, alignment: .center)
                                            .cornerRadius(100)
                                        Image("Custom_Color_1_TC")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1, alignment: .center)
                                            .cornerRadius(100)
                                        Image("Custom_Color_2_TC")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1, alignment: .center)
                                            .cornerRadius(100)
                                    }
                                    VStack(alignment: .leading, spacing: 0){
                                        HStack(alignment: .center, spacing: 0.0){
                                            Text("Tap")
                                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                                .fontWeight(.bold)
                                            Text("Dash")
                                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                                .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                                .fontWeight(.bold)
                                        }
                                        Rectangle()
                                            .fill(newCustomColorsModel.colorSchemeOne)
                                            .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.01)
                                    }
                                }
                                Text("1/3")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                    .foregroundColor(darkMode ?? false ? Color(.white) : Color(.black))
                                Text("\(tapDashStringVar) mode, when active, allows you to win \(tapCoinsStringVar). A \(tapCoinStringVar) is a representation of a 3 game win streak that is won by a user while \(tapDashStringVar) mode is active. A \(tapCoinStringVar) also has a monetary value which may fluctate on a daily basis.")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                    .foregroundColor(darkMode ?? false ? Color(.white) : Color(.black))
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.6, alignment: .center)
                            .background(darkMode ?? false ? Color(.black) : newCustomColorsModel.colorSchemeTwo)
                            .cornerRadius(UIScreen.main.bounds.width * 0.03)
                            VStack{
                                Rectangle()
                                    .fill(newCustomColorsModel.colorSchemeOne)
                                    .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.005)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.2, alignment: .center)
                        }
                        VStack{
                            VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.08){
                                VStack(alignment: .center){
                                    HStack{
                                        Image("Custom_Color_3_TC")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1, alignment: .center)
                                            .cornerRadius(100)
                                        Image("Custom_Color_1_TC")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1, alignment: .center)
                                            .cornerRadius(100)
                                        Image("Custom_Color_2_TC")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1, alignment: .center)
                                            .cornerRadius(100)
                                    }
                                    VStack(alignment: .leading, spacing: 0){
                                        HStack(alignment: .center, spacing: 0.0){
                                            Text("Tap")
                                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                                .fontWeight(.bold)
                                            Text("Dash")
                                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                                .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                                .fontWeight(.bold)
                                        }
                                        Rectangle()
                                            .fill(newCustomColorsModel.colorSchemeOne)
                                            .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.01)
                                    }
                                }
                                Text("2/3")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                    .foregroundColor(darkMode ?? false ? Color(.white) : Color(.black))
                                Text("\(tapDashStringVar) is only available from 12pm EST to 6pm EST and there is a limited amount of \(tapCoinsStringVar) available daily, so be quick! After \(tapDashStringVar) is completed for the day you will be sent your winnings by the end of the day. If an issue occurs we will either email or text you with the appropriate response.")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                    .foregroundColor(darkMode ?? false ? Color(.white) : Color(.black))
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.6, alignment: .center)
                            .background(darkMode ?? false ? Color(.black) : newCustomColorsModel.colorSchemeTwo)
                            .cornerRadius(UIScreen.main.bounds.width * 0.03)
                            VStack{
                                Rectangle()
                                    .fill(newCustomColorsModel.colorSchemeOne)
                                    .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.005)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.2, alignment: .center)
                        }
                        VStack{
                            VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.08){
                                VStack(alignment: .center){
                                    HStack{
                                        Image("Custom_Color_3_TC")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1, alignment: .center)
                                            .cornerRadius(100)
                                        Image("Custom_Color_1_TC")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1, alignment: .center)
                                            .cornerRadius(100)
                                        Image("Custom_Color_2_TC")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1, alignment: .center)
                                            .cornerRadius(100)
                                    }
                                    VStack(alignment: .leading, spacing: 0){
                                        HStack(alignment: .center, spacing: 0.0){
                                            Text("Tap")
                                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                                .fontWeight(.bold)
                                            Text("Dash")
                                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                                .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                                .fontWeight(.bold)
                                        }
                                        Rectangle()
                                            .fill(newCustomColorsModel.colorSchemeOne)
                                            .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.01)
                                    }
                                }
                                Text("3/3")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                    .foregroundColor(darkMode ?? false ? Color(.white) : Color(.black))
                                Text("To sign up for free go to the Settings -> Account Information and click 'Sign Up for TapDash!'. Then enter the email address and/or the phone number associated with your Zelle account as well as a valid first and last name. Once saved you can activate \(tapDashStringVar) in Settings -> Toggle Settings and start earning some \(tapCoinsStringVar)!")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                    .foregroundColor(darkMode ?? false ? Color(.white) : Color(.black))
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.6, alignment: .center)
                            .background(darkMode ?? false ? Color(.black) : newCustomColorsModel.colorSchemeTwo)
                            .cornerRadius(UIScreen.main.bounds.width * 0.03)
                            VStack{
                                Rectangle()
                                    .fill(newCustomColorsModel.colorSchemeOne)
                                    .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.005)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.2, alignment: .center)
                        }
                        
                    }
                }
                Spacer()
            }
        } //ZStack
    }
    
}
