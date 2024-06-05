//
//  BackButtonView.swift
//  TapCoinsApplication.V1
//
//  Created by Eric Viera on 5/8/24.
//

import Foundation
import SwiftUI

struct BackButtonView: View {
    
    @AppStorage("darkMode") var darkMode: Bool?
    @Environment(\.presentationMode) var presentationMode
    var newCustomColorsModel = CustomColorsModel()
    var opposite:Bool = false
    
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "arrow.left.circle.fill") // You can use any image or view here
                .foregroundColor(darkMode ?? false ? 
                                 opposite ?  newCustomColorsModel.colorSchemeFour :
                                 newCustomColorsModel.colorSchemeOne : opposite ?
                                 newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour
                ) // Change the color of the back button
                    .font(.title)
        })
    }
}
