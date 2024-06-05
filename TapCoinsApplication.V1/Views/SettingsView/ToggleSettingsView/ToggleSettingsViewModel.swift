//
//  ToggleSettingsViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class ToggleSettingsViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("notifications") var notifications_on:Bool?
    @AppStorage("haptics") var haptics_on:Bool?
    @AppStorage("sounds") var sound_on:Bool?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("tapDashIsActive") var tapDashIsActive:Bool?
    @Published var userModel:UserViewModel?
    @Published var smaller_screen:Bool = false
    @Published var is_guest:Bool = false
    
    init(){
        if UIScreen.main.bounds.height < 750.0{
            smaller_screen = true
        }
        self.userModel = UserViewModel(self.userViewModel ?? Data())
        if self.userModel?.is_guest == true{
            is_guest = true
        }
        if is_guest == true {
            notifications_on = false
        }
    }
    
    func turn_on_off_notifications(){
        if is_guest == false{
            if notifications_on == nil{
//                subscribeToNotifications()
            }
            else if notifications_on!{
//                unsubscribeToNotifications()
            }
            else {
//                subscribeToNotifications()
            }
        }
    }
}
