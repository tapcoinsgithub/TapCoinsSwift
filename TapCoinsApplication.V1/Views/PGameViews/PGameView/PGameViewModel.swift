//
//  PGameViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI
final class PGameViewModel: ObservableObject {
    @AppStorage("pGame") var pGame: String?
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("user") private var userViewModel: Data?
    @Published var coins = [true, false, true, false, true, false, true, false, true, false]
    @Published var gameStart = "READY"
    @Published var username = ""
    @Published var winner = ""
    @Published var change_value1 = ""
    @Published var change_value2 = ""
    @Published var change_text1 = ""
    @Published var change_text2 = ""
    @Published var gameStarted = false
    @Published var endGame = false
    @Published var changing_diff = false
    @Published var smaller_screen = false
    @Published var fPoints = 0
    @Published var sPoints = 0
    @Published var coin_values = [
        "00":"Custom_Color_1_TC",
        "10":"Custom_Color_1_TC",
        "20":"Custom_Color_1_TC",
        "30":"Custom_Color_1_TC",
        "01":"Custom_Color_1_TC",
        "11":"Custom_Color_1_TC",
        "21":"Custom_Color_1_TC",
        "02":"Custom_Color_1_TC",
        "12":"Custom_Color_1_TC",
        "22":"Custom_Color_1_TC",
        "32":"Custom_Color_1_TC",
        "03":"Custom_Color_1_TC",
        "13":"Custom_Color_1_TC",
        "23":"Custom_Color_1_TC",
        "04":"Custom_Color_1_TC",
        "14":"Custom_Color_1_TC",
        "24":"Custom_Color_1_TC",
        "34":"Custom_Color_1_TC",
        "05":"Custom_Color_1_TC",
        "15":"Custom_Color_1_TC",
        "25":"Custom_Color_1_TC",
        "06":"Custom_Color_1_TC",
        "16":"Custom_Color_1_TC",
        "26":"Custom_Color_1_TC",
        "36":"Custom_Color_1_TC",
        "07":"Custom_Color_1_TC",
        "17":"Custom_Color_1_TC",
        "27":"Custom_Color_1_TC",
        "08":"Custom_Color_1_TC",
        "18":"Custom_Color_1_TC",
        "28":"Custom_Color_1_TC",
        "38":"Custom_Color_1_TC",
        "09":"Custom_Color_1_TC",
        "19":"Custom_Color_1_TC",
        "29":"Custom_Color_1_TC",
    ]
    private var opp_values = [String]()
    private var easyTime = 0.17
    private var mediumTime = 0.15
    private var hardTime = 0.12
    
    init(){
        if UIScreen.main.bounds.height < 750.0{
            smaller_screen = true
        }
        let convertedData = UserViewModel(self.userViewModel ?? Data())
        self.username = convertedData?.username ?? "No Username"
        set_opps()
        count_down()
    }
    
    func set_opps(){
        for (key,_) in coin_values{
            opp_values.append(key)
        }
    }
    
    func count_down(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.gameStart = "SET"
            self.startingGame()
        }
    }
    
    func startingGame(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.gameStart = "GO"
            self.startGame()
        }
    }
    
    func startGame(){
        gameStarted = true
        if (pGame! == "easy"){
            generate_index(wait:easyTime)
        }
        else if (pGame! == "medium"){
            generate_index(wait:mediumTime)
        }
        else if (pGame! == "hard"){
            generate_index(wait:hardTime)
        }
        
    }
    
    func user_tap(x:Int, y:Int){
        let c_Index = String(x) + String(y)
        self.coin_values[c_Index] = "Custom_Color_3_TC"
        self.fPoints = self.fPoints + 1
        self.check_endGame()
    }
    
    func generate_index(wait:Double){
        DispatchQueue.main.asyncAfter(deadline: .now() + wait) {
            let index = Int.random(in: 0..<self.opp_values.count)
            if self.check_index(_index:index){
                self.computer_tap(index: index)
            }
            else{
                self.generate_index(wait: 0.0)
            }
        }
    }
    
    func check_index(_index:Int) -> Bool {
        let check_val = (self.coin_values[opp_values[_index]] ?? "") as String
        if check_val == "Custom_Color_3_TC"{
            return false
        }
        return true
    }
    
    func computer_tap(index:Int){
        if (pGame == "easy"){
            if (self.coin_values[opp_values[index]] == "Custom_Color_1_TC"){
                self.coin_values[opp_values[index]] = "Custom_Color_2_TC"
                self.sPoints = self.sPoints + 1
                self.opp_values.remove(at: index)
                self.check_endGame()
                if (self.endGame == false){
                    generate_index(wait:easyTime)
                }
            }
            else{
                self.opp_values.remove(at: index)
                self.check_endGame()
                if (self.endGame == false){
                    generate_index(wait:easyTime)
                }
            }
        }
        else if (pGame == "medium"){
            if (self.coin_values[opp_values[index]] == "Custom_Color_1_TC"){
                self.coin_values[opp_values[index]] = "Custom_Color_2_TC"
                self.sPoints = self.sPoints + 1
                self.opp_values.remove(at: index)
                self.check_endGame()
                if (self.endGame == false){
                    generate_index(wait:mediumTime)
                }
            }
            else{
                self.opp_values.remove(at: index)
                self.check_endGame()
                if (self.endGame == false){
                    generate_index(wait:mediumTime)
                }
            }
        }
        else if (pGame == "hard"){
            if (self.coin_values[opp_values[index]] == "Custom_Color_1_TC"){
                self.coin_values[opp_values[index]] = "Custom_Color_2_TC"
                self.sPoints = self.sPoints + 1
                self.opp_values.remove(at: index)
                self.check_endGame()
                if (self.endGame == false){
                    generate_index(wait:hardTime)
                }
            }
            else{
                self.opp_values.remove(at: index)
                self.check_endGame()
                if (self.endGame == false){
                    generate_index(wait:hardTime)
                }
            }
        }
        else{
            pGame = "None"
        }
    }
    
    func check_endGame(){
        let sum = fPoints + sPoints
        if (sum == 35){
            if (fPoints > sPoints){
                winner = username
            }
            else{
                winner = "Computer"
            }
            endGame = true
        }
    }

    func return_home(){
        pGame = nil
    }
    
    func play_again(){
        var dict = [String:String]()
        for (key,_) in coin_values{
            dict[key] = "Custom_Color_1_TC"
        }
        coin_values = dict
        gameStart = "READY"
        fPoints = 0
        sPoints = 0
        gameStarted = false
        endGame = false
        set_opps()
        count_down()
    }
    
    func change_difficulty(change:String){
        if (change == "Change"){
            changing_diff = true
            if (pGame == "easy"){
                change_value1 = "medium"
                change_text1 = "Medium"
                change_value2 = "hard"
                change_text2 = "Hard"
            }
            else if (pGame == "medium"){
                change_value1 = "easy"
                change_text1 = "Easy"
                change_value2 = "hard"
                change_text2 = "Hard"
            }
            else if (pGame == "hard"){
                change_value1 = "easy"
                change_text1 = "Easy"
                change_value2 = "medium"
                change_text2 = "Medium"
            }
        }
        else{
            play_again()
            changing_diff = false
            pGame = change
        }
    }
}
