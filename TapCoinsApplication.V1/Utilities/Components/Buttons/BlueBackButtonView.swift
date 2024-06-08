//
//  BlueBackButtonView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct BlueBackButtonView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var newCustomColorsModel = CustomColorsModel()
    
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "arrow.left.circle.fill") // You can use any image or view here
                .foregroundColor(newCustomColorsModel.colorSchemeFour) // Change the color of the back button
                    .font(.title)
        })
    }
}