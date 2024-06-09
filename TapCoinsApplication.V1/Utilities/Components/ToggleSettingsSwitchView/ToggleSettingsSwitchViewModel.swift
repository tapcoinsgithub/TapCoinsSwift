//
//  ToggleSettingsSwitchViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI
//import CloudKit
final class ToggleSettingsSwitchViewModel: ObservableObject {
    @AppStorage("notifications") var notifications_on:Bool?
    @AppStorage("haptics") var haptics_on:Bool?
    @AppStorage("sounds") var sound_on:Bool?
    @AppStorage("location_on") var location_on:Bool?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("darkMode") var darkMode: Bool?
    @AppStorage("tapDash") var tapDash:Bool?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("tapDashIsActive") var tapDashIsActive:Bool?
    @Published var userModel:UserViewModel?
    @Published var is_guest:Bool = false
    @Published var has_contact_info:Bool = false
    
    init(){
        self.userModel = UserViewModel(self.userViewModel ?? Data())
        if self.userModel?.is_guest == true{
            is_guest = true
        }
        if is_guest == true {
            notifications_on = false
        }
        if tapDashIsActive ?? false == false{
            tapDash = false
        }
        if self.userModel?.hasPhoneNumber ?? false || self.userModel?.hasEmailAddress ?? false{
            has_contact_info = true
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
    func turn_on_off_location(){
        
    }
    
    func set_tap_dash(){
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/game/tap_dash_toggle"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/game/tap_dash_toggle"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        
        guard let session = logged_in_user else{
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    if response.response == "success"{
                        print("success")
                    }
                    else{
                        print("something went wrong")
                    }
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    struct Response:Codable {
        let response: String
    }
}
