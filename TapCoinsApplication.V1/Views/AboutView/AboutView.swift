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
                                            Text("Coins")
                                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                                .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                                .fontWeight(.bold)
                                        }
                                        Rectangle()
                                            .fill(newCustomColorsModel.colorSchemeOne)
                                            .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.01)
                                    }
                                }
                                
                                Text("A high-speed multiplayer game where you have 10 seconds to tap as many coins as you can before your oppenent! Play against friends in Custom Games or build your streak up in public matches to see how many games you can win in a row! But be quick you only have 2 minutes between each game to continue your streak.")
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
                    }
                }
                Spacer()
            }
        } //ZStack
    }
    
}
