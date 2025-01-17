//
//  HomeView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

//@available(iOS 17.0, *)
struct HomeView: View {
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("darkMode") var darkMode: Bool?
    @AppStorage("betaMode") var betaMode: Bool?
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject var timerManager = TimerManager()
    var newCustomColorsModel = CustomColorsModel()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack{
            if darkMode ?? false {
                Color(.black).ignoresSafeArea()
            }
            else{
                newCustomColorsModel.colorSchemeTwo.ignoresSafeArea()
            }
            if viewModel.loadedAllUserData ?? false{
                VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                    VStack(alignment: .center, spacing: 0){
                        HStack(alignment: .center, spacing: 0.0){
                            Text("TAP")
                                .font(.system(size: UIScreen.main.bounds.width * 0.15))
                                .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                .fontWeight(.bold)
                            Text("C")
                                .font(.system(size: UIScreen.main.bounds.width * 0.15))
                                .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                .fontWeight(.bold)
                            Image("Custom_Color_1_TC")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.12, alignment: .center)
                                .cornerRadius(100)
                            Text("INS")
                                .font(.system(size: UIScreen.main.bounds.width * 0.15))
                                .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                .fontWeight(.bold)
                        }
                        VStack(alignment: .center, spacing: 0.0){
                            Rectangle()
                                .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.01)
                            if viewModel.tapDash ?? false{
                                HStack{
                                    if betaMode ?? false {
                                        Text("TapCoins is currently in Beta Mode. All TapCoins you earn will be voided at the end of each day and you will not be compensated. This is in effect until Beta Mode is deactivated. Thank you for understanding and have fun.")
                                            .font(.system(size: UIScreen.main.bounds.width * 0.035))
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                            .fontWeight(.bold)
                                    }
                                    else{
                                        VStack{
                                            HStack(alignment: .center, spacing: 0){
                                                Spacer()
                                                Text("Time Left: ")
                                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                                    .fontWeight(.bold)
                                                Spacer()
                                                Text(viewModel.tap_dash_time_left ?? "Done")
                                                    .font(.system(size: UIScreen.main.bounds.width * 0.045))
                                                    .fontWeight(.bold)
                                                Spacer()
                                            }
                                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                            HStack(alignment: .center, spacing: 0){
                                                Spacer()
                                                Text("TapCoins Left: ")
                                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                                    .fontWeight(.bold)
                                                Spacer()
                                                Text(String(viewModel.tapDashLeft ?? 0))
                                                    .font(.system(size: UIScreen.main.bounds.width * 0.045))
                                                    .fontWeight(.bold)
                                                Spacer()
                                            }
                                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                        }
                                        VStack{
                                            HStack(alignment: .center, spacing: 0){
                                                Spacer()
                                                Text("Active Users: ")
                                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                                    .fontWeight(.bold)
                                                Spacer()
                                                Text(String(viewModel.activeTapDashUsers ?? "Loading"))
                                                    .font(.system(size: UIScreen.main.bounds.width * 0.045))
                                                    .fontWeight(.bold)
                                                Spacer()
                                            }
                                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                            HStack(alignment: .center, spacing: 0){
                                                Spacer()
                                                Text("TapCoins USD = $0.03")
                                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                                    .fontWeight(.bold)
                                                Spacer()
                                            }
                                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                                        }
                                    }
                                }.background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                Rectangle()
                                    .fill(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.01)
                            }
                        }
                        
                    }
                    Button(action: {
                        print("BUTTON PRESSED")
                        if viewModel.pressed_find_game == false{
                            viewModel.pressed_find_game = true
                            in_queue = true
                            viewModel.pressed_find_game = false
                        }
                    }, label: {
                        Text(viewModel.tapDash ?? false ? "TapDash" : "Free Play")
                            .font(.system(size: UIScreen.main.bounds.width * 0.1))
                            .fontWeight(.bold)
                            .frame(width: UIScreen.main.bounds.width * 0.65, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                            .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                            .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: UIScreen.main.bounds.height * 0.02, height: UIScreen.main.bounds.height * 0.02)))
                            .shadow(color: newCustomColorsModel.colorSchemeTen, radius: UIScreen.main.bounds.width * 0.02, x: 0, y: UIScreen.main.bounds.width * 0.04)
                    })
                    HomePageButton(_label: "Practice")
                    HomePageButton(_label: "Profile")
                    HomePageButton(_label: "About")
                    HStack(alignment: .bottom){
                        HomePageButton(_label: "Settings")
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                }
                Spacer()
            }
            else{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeFour))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
        }
        .onAppear {
            if viewModel.tapDash ?? false  && betaMode == false{
                self.timerManager.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            }
        }
        .onDisappear {
            if viewModel.tapDash ?? false && betaMode == false{
                self.timerManager.timer.upstream.connect().cancel()
            }
        }
        .onReceive(timerManager.timer) { _ in
            if viewModel.tapDash ?? false && betaMode == false{
                viewModel.countDownTapDashTimer()
            }
        }
    }
}
