//
//  QueueViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI
import Network
import SocketIO
final class QueueViewModel: ObservableObject{
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("Player1") var first_player: String?
    @AppStorage("Player2") var second_player: String?
    @AppStorage("GotFirst") var got_first:Bool?
    @AppStorage("GotSecond") var got_second:Bool?
    @AppStorage("gameId") var game_id: String?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("from_queue") var from_queue: Bool?
    @AppStorage("custom_game") var custom_game: Bool?
    @AppStorage("is_first") var is_first: Bool?
    @AppStorage("ad_loaded") var ad_loaded: Bool?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("de_queue") private var de_queue: Bool?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("from_gq") private var from_gq: Bool?
    @AppStorage("tapDash") var tapDash:Bool?
    @Published var loading_status:String = "Loading . . ."
    @Published var queue_pop:String = "_ players in queue"
    @Published var ad_has_loaded:Bool = false
    private var found_queue:Bool = false
    private var found_opponent:Bool = false
    private var got_gameId = false
    private var got_game = false
    private var connected = false
    private var put_in_queue = false;
    private var creating_game = false;
    private var created_game = false;
    private var find_game_bool = false;
    private var sent_create2game = false;
    private var in_create2game = false;
    private var removed_from_queue = false;
    private var mSocket = QueueHandler.sharedInstance.getSocket()
    private var player1:String = "None"
    private var player2:String = "None"
    private var queue_name:String = ""
    private var queue_count:Int = 0
    private var userModel: UserViewModel?
    private var checked_queue:Bool = false
    
    init() {
        self.custom_game = false
    }//init
    
    func connect_to_queue(){
        QueueHandler.sharedInstance.establishConnection()
        from_gq = true
        mSocket.on("statusChange") {data, ack in
            var error:Bool = false
            if self.connected == false{
                if data.count == 2{
                    let eventName = data[0]
                    print("EVENT NAME IS HERE")
                    print(eventName)
                    if eventName as! SocketIOStatus == SocketIOStatus.connected{
                        let token = self.logged_in_user ?? "None"
                        if (token != "None"){
                            self.userModel = UserViewModel(self.userViewModel ?? Data()) ?? UserViewModel(first_name: "NO FIRST NAME", last_name: "NO LAST NAME")
                            if self.tapDash ?? false{
                                let user_data = token + "|" + String(self.userModel?.tap_dash_league ?? 1)
                                let other_data = "|16|16"
                                let user_name = "|" + (self.userModel?.username ?? "None")
                                let data = user_data + other_data + user_name
                                print("DATA BELOW")
                                print(data)
                                self.mSocket.emit("put_in_queue", data)
                                self.connected = true
                                self.ad_loaded = false
                            }
                            else{
                                let user_data = token + "|" + String(self.userModel?.tap_dash_league ?? 1)
                                let other_data = "|16|16"
                                let user_name = "|" + (self.userModel?.username ?? "None")
                                let data = user_data + other_data + user_name
                                print("DATA BELOW")
                                print(data)
                                self.mSocket.emit("put_in_queue", data)
                                self.connected = true
                                self.ad_loaded = false
                            }
                       }
                        else{
                            print("1111111111")
                            error = true
                        }
                    }
                    else if eventName as! SocketIOStatus == SocketIOStatus.connecting {
                        print("STATUS IS CONNECTING")
                        return
                    }
                    else if eventName as! SocketIOStatus == SocketIOStatus.disconnected {
                        print("2222222222")
                        error = true
                    }
                }
                else{
                    print("3333333333")
                    error = true
                }
            }
            if error{
                QueueHandler.sharedInstance.closeConnection()
                self.in_queue = false
                self.connected = false
                self.in_game = false
                self.ad_loaded = false
            }
        }
        mSocket.on("CHECKQUEUE") {dataArr, ack in
            if self.checked_queue == false{
                self.checked_queue = true
                self.loading_status = "Adjusting Queue..."
                let data_string = dataArr[0] as! String
                let check_queue_arr = data_string.split(separator: "|").map { String($0)}
                if check_queue_arr[0] == "Length"{
                    self.queue_pop = check_queue_arr[1] + " player(s) in queue."
                    self.checked_queue = false
                    self.loading_status = "Finding Opponent"
                }
            }
        }
        mSocket.on("PUTINQUEUE") {(dataArr, ack) -> Void in
            if (self.put_in_queue == false){
                let data_string = dataArr[0] as! String
                let in_queue_arr = data_string.split(separator: "|").map { String($0)}
                if (in_queue_arr[0] == "SUCCESS"){
                    self.put_in_queue = true
                    self.loading_status = "Finding Opponent"
                    self.queue_pop = in_queue_arr[1] + " player(s) in queue."
                }
            }
        }
        mSocket.on("FOUNDGAME1") {(dataArr, ack) -> Void in
            if (self.find_game_bool == false){
                print("IN FOUND GAME")
                let found_game = dataArr[0] as! String
                let player_arr = found_game.split(separator: "|").map { String($0)}
                print(player_arr)
                self.player1 = player_arr[0]
                self.player2 = player_arr[1]
                print(self.player1)
                print(self.player2)
                if (self.player2 != "None"){
                    if (self.player1 != "None"){
                        self.find_game_bool = true
                        self.loading_game(is_player_1: true)
                    }
                }
            }
        }
        mSocket.on("CREATEDGAME") {(dataArr, ack) -> Void in
            if (self.in_create2game == false){
                print("IN CREATED GAME")
                self.in_create2game = true
                let players_string = dataArr[0] as! String
                let players_split = players_string.split(separator: "|").map { String($0)}
                self.player1 = players_split[0]
                self.player2 = players_split[1]
                self.game_id = players_split[2]
                self.loading_game(is_player_1: false)
            }
        }
        mSocket.on("LEFTSERVER") {(dataArr, ack) -> Void in
            // Send users data back to queue server repeatedly and
            // return it here to check the newly updated value of
            // ad_loaded until the ad_loaded is true and it can then
            // put the users into the game.
            print("AD LOADED VALUE BELOW")
            print(self.ad_loaded)
            QueueHandler.sharedInstance.closeConnection()
            self.in_queue = false
            self.in_game = true
            self.ad_loaded = false
        }
        mSocket.on("DISCONNECT") {(dataArr, ack) -> Void in
            self.return_home()
        }
    }
    
    deinit {
        self.in_queue = false
    }

    func loading_game(is_player_1:Bool) {
        if (creating_game == false){
            creating_game = true
            loading_status =  "Found Opponent"
            if (is_player_1){
                DispatchQueue.main.async { [weak self] in
                    guard let loading_player1 = self?.player1 else {
                           return
                    }
                    guard let loading_player2 = self?.player2 else {
                           return
                    }
                    self?.getUsersAndGame(user1Token: loading_player1, user2Token: loading_player2, curr_user: 1)
                }
            }
            else{
                DispatchQueue.main.async { [weak self] in
                    guard let loading_player1 = self?.player1 else {
                           return
                    }
                    guard let loading_player2 = self?.player2 else {
                           return
                    }
                    self?.getUsersAndGame(user1Token: loading_player1, user2Token: loading_player2, curr_user: 2)
                }
            }
            from_queue = true
            is_first = false
        }
    }
    
    func createGame(first:String, second:String){
        guard let session = logged_in_user else{
            return
        }
        
        if first == "None"{
            return
        }
        else if second == "None"{
            return
        }
        
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/game/createGame"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/game/createGame"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "first": first,
            "second": second,
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Game_Id.self, from: data)
                    self?.game_id = response.gameId
                    self?.got_gameId = true
                    self?.is_first = true
                    if (self?.sent_create2game == false){
                        self?.sent_create2game = true;
                        let msg1 = second + "|"
                        let msg2 = (self?.player1 ?? "None") + "|" + (self?.player2 ?? "None")
                        let message = msg1 + msg2 + "|" + response.gameId
                        print("CREATED GAME")
                        print(message)
                        self?.mSocket.emit("created_game", message)
                    }
                }
                catch{
                    print(error)
                    self?.de_queue = true
                    self?.in_game = false
                    self?.in_queue = false
                }
            }
        })
        task.resume()
    }
    
    func getUsersAndGame(user1Token:String, user2Token:String, curr_user:Int){
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/game/get_user_and_game"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/game/get_user_and_game"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        
        if user1Token == "None" {
            return
        }
        
        if user2Token == "None" {
            return
        }
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "player1_token": user1Token,
            "player2_token": user2Token,
            "de_queue": false
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    if response.response == true{
                        if curr_user == 1{
                            self?.first_player = response.player1_username
                            self?.second_player = response.player2_username
                            print("USER 1 GOT USER DATA")
                            self?.createGame(first: user1Token, second: user2Token)
                        }
                        else{
                            print("USER 2 GOT USER DATA")
                            self?.first_player = response.player1_username
                            self?.second_player = response.player2_username
                            let msg = user1Token + "|" + user2Token
                            self?.mSocket.emit("remove_from_server", msg)
                        }
                    }
                    else{
                        self?.de_queue = true
                        self?.in_game = false
                        self?.in_queue = false
                    }
                }
                catch{
                    print(error)
                    self?.de_queue = true
                    self?.in_game = false
                    self?.in_queue = false
                }
            }
        })
        task.resume()
        return
    }
    
    func game_made() -> Bool{
        if (got_first ?? false){
            if (got_second ?? false){
                if (got_gameId){
                    loading_status = "Created Game"
                    from_queue = true
                    created_game = true
                    return true
                }
            }
        }
        return false
    }
    
    func return_home(){
        var url_string:String = ""
        
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/game/end_user_streak"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/game/end_user_streak"
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
            "token": session,
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(EndStreakResponse.self, from: data)
                    if response.result == true{
                        print("ENDED USERS STREAK SUCCESSFULLY")
                        print("ENDED USERS STREAK SUCCESSFULLY")
                        print("ENDED USERS STREAK SUCCESSFULLY")
                        print("ENDED USERS STREAK SUCCESSFULLY")
                    }
                    else{
                        print("UNABLE TO END THE USERS STREAK")
                        print("UNABLE TO END THE USERS STREAK")
                        print("UNABLE TO END THE USERS STREAK")
                        print("UNABLE TO END THE USERS STREAK")
                    }
                    QueueHandler.sharedInstance.closeConnection()
                    self?.in_queue = false
                    self?.connected = false
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    struct Response:Codable {
        let response: Bool
        let player1_username: String
        let player2_username: String
    }
    
    struct Game_Id:Codable {
        let gameId: String
        let first: String
    }
    
    struct QResponse:Codable {
        let q_name:String
        let q_count:Int
    }
    
    struct EndStreakResponse:Codable {
        let result: Bool
    }
}