//
//  YellowBackButtonView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct YellowBackButtonView: View {
    @AppStorage("haptics") var haptics_on:Bool?
    @Environment(\.presentationMode) var presentationMode
    var newCustomColorsModel = CustomColorsModel()
    
    var body: some View {
        Button(action: {
            if haptics_on ?? true{
                HapticManager.instance.impact(style: .medium)
            }
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "arrow.left.circle.fill") // You can use any image or view here
                .foregroundColor(newCustomColorsModel.colorSchemeOne) // Change the color of the back button
                    .font(.title)
        })
    }
}
