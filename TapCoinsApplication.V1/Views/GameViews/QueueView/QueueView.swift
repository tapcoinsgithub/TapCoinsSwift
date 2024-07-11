//
//  QueueView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct QueueView: View {
    @StateObject private var viewModel = QueueViewModel()
    @State private var adLoaded: Bool = false
    var newCustomColorsModel = CustomColorsModel()

    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeFive.ignoresSafeArea()
            VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.2){
                Spacer()
                Text(viewModel.loading_status)
                    .fontWeight(.bold)
                    .font(.system(size: UIScreen.main.bounds.width * 0.11))
                    .foregroundColor(newCustomColorsModel.colorSchemeOne)
                Text(viewModel.queue_pop)
                    .fontWeight(.bold)
                    .font(.system(size: UIScreen.main.bounds.width * 0.08))
                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeOne))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
//                BannerAd(unitID: "ca-app-pub-3940256099942544/2435281174")
//                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name("AdLoadedNotification"))) { _ in
//                        viewModel.connect_to_queue()
//                    }
//                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.2)
                Button(action: {
                    if viewModel.haptics_on ?? true{
                        HapticManager.instance.impact(style: .medium)
                    }
                    viewModel.returnHomeTask()
                }, label: {
                    Text("Home")
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.06, alignment: .center)
                        .background(newCustomColorsModel.colorSchemeFour)
                        .foregroundColor(newCustomColorsModel.colorSchemeOne)
                        .cornerRadius(UIScreen.main.bounds.width * 0.05)
                })
                Spacer()
            }
        }
    }
}
