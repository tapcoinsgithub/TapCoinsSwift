//
//  HomePageButtonView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct HomePageButton : View {
    @AppStorage("darkMode") var darkMode: Bool?
    var newCustomColorsModel = CustomColorsModel()
    var _label:String
    var body: some View {
            NavigationLink(destination: {
                if _label ==  "Settings"{
                    SettingsView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: BackButtonView())
                }
                else if _label == "Practice"{
                    PMenuView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: BackButtonView())
                }
                else if _label == "Profile"{
                    ProfileView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: BackButtonView())
                }
                else if _label == "About"{
                    AboutView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: RedBackButtonView())
                }
            }, label: {
                if _label == "Settings"{
                    Image(systemName: "gearshape.fill")
                        .background(darkMode ?? false ? Color(.black) : newCustomColorsModel.colorSchemeTwo)
                    .foregroundColor(newCustomColorsModel.colorSchemeTen)
                           .font(.system(size: UIScreen.main.bounds.width * 0.15))
                           .offset(x: UIScreen.main.bounds.width * -0.125)
                }
                else{
                    Text(_label)
                        .font(.system(size: UIScreen.main.bounds.width * 0.1))
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width * 0.65, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                        .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                        .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: UIScreen.main.bounds.height * 0.02, height: UIScreen.main.bounds.height * 0.02)))
                        .shadow(color: newCustomColorsModel.colorSchemeTen, radius: UIScreen.main.bounds.width * 0.02, x: 0, y: UIScreen.main.bounds.width * 0.04)
                }
            })
    }
}
