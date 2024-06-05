//
//  FriendsView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct FriendsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = FriendsViewModel()
    @AppStorage("darkMode") var darkMode: Bool?
    var newCustomColorsModel = CustomColorsModel()
    var body: some View {
        ZStack{
            if darkMode ?? false{
                Color(.black).ignoresSafeArea()
            }
            else{
                newCustomColorsModel.colorSchemeTwo.ignoresSafeArea()
            }
            VStack{
                Text("Friends")
                    .font(.system(size: UIScreen.main.bounds.width * 0.1))
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.08)
                    .foregroundColor(darkMode ?? false ? newCustomColorsModel.colorSchemeFour : newCustomColorsModel.colorSchemeOne)
                    .background(darkMode ?? false ? newCustomColorsModel.colorSchemeOne : newCustomColorsModel.colorSchemeFour)

                ScrollView{
                    VStack{
                        if viewModel.userModel?.fArrayCount == 0{
                            HStack{
                                Text("No friends yet")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.06))
                                    .foregroundColor(newCustomColorsModel.colorSchemeFive)
                                    .fontWeight(.bold)
                            }
                            Rectangle()
                                .fill(newCustomColorsModel.colorSchemeFive)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                        }
                        else{
                            ForEach(Array(viewModel.userModel?.friends?.enumerated() ?? ["NO FRIENDS"].enumerated()), id: \.element) { index, friend in
                                FriendsListItemView(friend: friend, index: index, curr_user_name: viewModel.userModel?.username ?? "No username")
                            }
                        }
                    }
                }
            }
        } //ZStack
    }
}
