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
    @AppStorage("loadedAllUserData") var loadedAllUserData:Bool?
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
            self?.globalFunctions.getAllUserInfoTask()
            self?.userModel = UserViewModel(self?.userViewModel ?? Data())
            if self?.userModel?.is_guest == false {
//                self?.getiCloudStatus()
            }
            else{
                self?.iCloud_status = "IS A GUEST"
            }
        }
    }
    
    func countDownTapDashTimer(){
        print("Hello World")
        let timeLeftSplit = tap_dash_time_left?.split(separator: ":")
        var hour:Int = 0
        var minute:Int = 0
        var second:Int = 0
        if let hourString = timeLeftSplit?[0], hourString != "00" {
            hour = Int(hourString) ?? 0
        }
        if let minuteString = timeLeftSplit?[1], minuteString != "00" {
            minute = Int(minuteString) ?? 0
        }
        if let secondString = timeLeftSplit?[2], secondString != "00" {
            second = Int(secondString) ?? 0
        }
        if second == 0 {
            if minute == 0 {
                if hour == 0 {
                    tap_dash_time_left = "Done"
                    return
                }
                else{
                    hour -= 1
                }
                minute = 59
            }
            else{
                minute -= 1
            }
            second = 59
        }
        else{
            second -= 1
        }
        let newHr = hour == 0 ? "00" : hour < 10 ? "0" + String(hour) : String(hour)
        let newMin = minute == 0 ? "00" : minute < 10 ? "0" + String(minute) : String(minute)
        let newSec = second == 0 ? "00" : second < 10 ? "0" + String(second) : String(second)
        tap_dash_time_left = newHr + ":" + newMin + ":" + newSec
    }

}
