//
//  ProfileViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class ProfileViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("de_queue") private var de_queue: Bool?
    @AppStorage("num_friends") public var num_friends:Int?
    @AppStorage("loadedUser") var loaded_get_user:Bool?
    @AppStorage("tapDash") var tapDash:Bool?
    @Published var userModel: UserViewModel = UserViewModel(first_name: "NO FIRST NAME", last_name: "NO LAST NAME")
    @Published var sUsername:String = ""
    @Published var result:String = ""
    @Published var showRequest:Bool = false
    @Published var usernameRes:Bool = false
    @Published var smaller_screen:Bool = false
    @Published var show_logout_option:Bool = false
    @Published var league_title:String = "Noob"
    @Published var leagueColor:Color = CustomColorsModel().colorSchemeTwo
    @Published var leageForeground:Color = Color(.black)
    @Published var pressed_send_request:Bool = false
    @Published var invalid_entry:Bool = false
    private var globalFunctions = GlobalFunctions()
    
    init(){
        let convertedData = UserViewModel(self.userViewModel ?? Data())
        self.userModel = convertedData ?? UserViewModel(first_name: "NO FIRST NAME", last_name: "NO LAST NAME")
        set_league_data()
        for friend in self.userModel.friends ?? ["NO FRIENDS"]{
            if friend.contains("Friend request from"){
                if self.userModel.numFriends != nil && self.userModel.numFriends != 0{
                    self.userModel.numFriends! -= 1
                }
                else{
                    self.userModel.numFriends! = 0
                }
            }
            else if friend.contains("Pending request to"){
                if self.userModel.numFriends != nil && self.userModel.numFriends != 0{
                    self.userModel.numFriends! -= 1
                }
                else{
                    self.userModel.numFriends! = 0
                }
            }
        }
        num_friends = self.userModel.numFriends
        self.loaded_get_user = true
    }
    
    func set_league_data(){
        if self.tapDash ?? false{
            switch self.userModel.tap_dash_league {
            case League.NOOB.rawValue:
                league_title = "NOOB"
                leagueColor = CustomColorsModel().colorSchemeTwo
                leageForeground = Color(.black)
            case League.BAD.rawValue:
                league_title = "BAD"
                leagueColor = CustomColorsModel().colorSchemeFive
                leageForeground = Color(.black)
            case League.OKAY.rawValue:
                league_title = "OKAY"
                leagueColor = CustomColorsModel().colorSchemeSix
                leageForeground = Color(.black)
            case League.BETTER.rawValue:
                league_title = "BETTER"
                leagueColor = CustomColorsModel().colorSchemeThree
                leageForeground = Color(.white)
            case League.GOOD.rawValue:
                league_title = "GOOD"
                leagueColor = CustomColorsModel().colorSchemeSeven
                leageForeground = Color(.black)
            case League.SOLID.rawValue:
                league_title = "SOLID"
                leagueColor = CustomColorsModel().colorSchemeFour
                leageForeground = Color(.white)
            case League.SUPER.rawValue:
                league_title = "SUPER"
                leagueColor = CustomColorsModel().colorSchemeEight
                leageForeground = Color(.white)
            case League.MEGA.rawValue:
                league_title = "MEGA"
                leagueColor = CustomColorsModel().colorSchemeNine
            case League.GODLY.rawValue:
                league_title = "GODLY"
                leagueColor = CustomColorsModel().colorSchemeOne
            default:
                league_title = "NOOB"
                leagueColor = CustomColorsModel().colorSchemeTwo
            }
        }
        else{
            switch self.userModel.free_play_league {
            case League.NOOB.rawValue:
                league_title = "NOOB"
                leagueColor = CustomColorsModel().colorSchemeTwo
                leageForeground = Color(.black)
            case League.BAD.rawValue:
                league_title = "BAD"
                leagueColor = CustomColorsModel().colorSchemeFive
                leageForeground = Color(.black)
            case League.OKAY.rawValue:
                league_title = "OKAY"
                leagueColor = CustomColorsModel().colorSchemeSix
                leageForeground = Color(.black)
            case League.BETTER.rawValue:
                league_title = "BETTER"
                leagueColor = CustomColorsModel().colorSchemeThree
                leageForeground = Color(.white)
            case League.GOOD.rawValue:
                league_title = "GOOD"
                leagueColor = CustomColorsModel().colorSchemeSeven
                leageForeground = Color(.black)
            case League.SOLID.rawValue:
                league_title = "SOLID"
                leagueColor = CustomColorsModel().colorSchemeFour
                leageForeground = Color(.white)
            case League.SUPER.rawValue:
                league_title = "SUPER"
                leagueColor = CustomColorsModel().colorSchemeEight
                leageForeground = Color(.white)
            case League.MEGA.rawValue:
                league_title = "MEGA"
                leagueColor = CustomColorsModel().colorSchemeNine
            case League.GODLY.rawValue:
                league_title = "GODLY"
                leagueColor = CustomColorsModel().colorSchemeOne
            default:
                league_title = "NOOB"
                leagueColor = CustomColorsModel().colorSchemeTwo
            }
        }
    }
    
    func sendRequest(){
        self.pressed_send_request = true
        self.usernameRes = false
        if sUsername.count > 0{
            var url_string:String = ""
            
            if debug ?? true{
                print("DEBUG IS TRUE")
                url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/sfr"
            }
            else{
                print("DEBUG IS FALSE")
                url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/friend/sfr"
            }
            
            guard let url = URL(string: url_string) else{
                return
            }
            var request = URLRequest(url: url)
            
            guard let session = logged_in_user else{
                return
            }
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: AnyHashable] = [
                "username": sUsername,
                "token": session
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

            let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let response = try JSONDecoder().decode(rResponse.self, from: data)
                    DispatchQueue.main.async {
                        if response.result != "Success"{
                            self?.invalid_entry = true
                            self?.result = response.result + response.friends
                        }
                        else{
                            self?.usernameRes = true
                            self?.result = "Sent Friend Request"
                            self?.loaded_get_user = false
                            DispatchQueue.main.async { [weak self] in
                                self?.globalFunctions.getUser(token:self?.logged_in_user ?? "None", this_user:nil, curr_user:nil)
                            }
                            DispatchQueue.main.async { [weak self] in
                                self?.userModel = UserViewModel(self?.userViewModel ?? Data()) ?? UserViewModel(Data())!
                            }
                            if self?.userModel.is_guest == false {
//                                self?.result = self?.globalFunctions.addRequest(sender: self?.userModel.username ?? "None", receiver: self?.sUsername ?? "None", requestType: "FriendRequest") ?? "ErrorOccured"
                            }
                            else{
                                self?.result = "IS A GUEST"
                            }
                        }
                    }
                }
                catch{
                    print(error)
                }
            })
            task.resume()
        }
        else{
            self.result = "Invalid entry."
            self.pressed_send_request = false
            self.invalid_entry = true
        }
    }

    struct rResponse:Codable {
        let result: String
        let friends:String
    }
}
