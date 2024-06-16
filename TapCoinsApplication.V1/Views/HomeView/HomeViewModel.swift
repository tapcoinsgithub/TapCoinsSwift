//
//  HomeViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI
//import CloudKit
//import RecaptchaEnterprise

final class HomeViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("de_queue") private var de_queue: Bool?
    @AppStorage("notifications") var notifications_on:Bool?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("loadedUser") var loaded_get_user:Bool?
    @AppStorage("from_gq") private var from_gq: Bool?
    @AppStorage("tapDash") var tapDash:Bool?
    @AppStorage("tapDashLeft") var tapDashLeft:Int?
    @AppStorage("tap_dash_time_left") var tap_dash_time_left:String?
    @Published var iCloudAccountError:String?
    @Published var hasiCloudAccountError:Bool?
    @Published var isSignedInToiCloud:Bool?
    @Published var showFaceIdPopUp:Bool = false
    @Published var passedFaceId:Bool = false
    @Published var failedFaceId:Bool = false
    @Published var userModel:UserViewModel?
    @Published var iCloud_status:String = "No iCloud Status."
    @Published var failedFaceIdMessage: String = ""
    @Published var pressed_find_game:Bool = false
    @Published var pressed_face_id_button:Bool = false
    private var status_granted:Bool = false
    private var globalFunctions = GlobalFunctions()
    
    init() {
        DispatchQueue.main.async { [weak self] in
            self?.globalFunctions.getUserTask(token:self?.logged_in_user ?? "None", this_user:nil, curr_user:nil)
        }
        DispatchQueue.main.async { [weak self] in
            self?.userModel = UserViewModel(self?.userViewModel ?? Data())
        }
        DispatchQueue.main.async { [weak self] in
            if self?.userModel?.is_guest == false {
//                self?.getiCloudStatus()
            }
            else{
                self?.iCloud_status = "IS A GUEST"
            }
        }
    }

}
