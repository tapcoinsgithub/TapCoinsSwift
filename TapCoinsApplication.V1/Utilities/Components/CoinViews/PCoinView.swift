//
//  PCoinView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct PCoinView : View {
    @AppStorage("haptics") var haptics_on:Bool?
    @AppStorage("sounds") var sound_on:Bool?
    @StateObject var viewModel: PGameViewModel
    var x_val:Int
    var y_val:Int
    var body: some View {
        Button(action: {
            if (viewModel.gameStarted){
                if (viewModel.coin_values[String(x_val) + String(y_val)]! == "Custom_Color_1_TC"){
                    viewModel.user_tap(x:x_val, y:y_val)
                    if haptics_on ?? true{
                        HapticManager.instance.impact(style: .medium)
                    }
                    if sound_on ?? true{
                        SoundManager.instance.playSound(sound_link: "bell")
                    }
                }
            }
        }, label: {
            Image(viewModel.coin_values[String(x_val) + String(y_val)]!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.14 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.14 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                .cornerRadius(100)
        })
    }
}
