//
//  UserViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct UserViewModel: Codable {
    var first_name: String
    var last_name: String
    var username: String?
    var phone_number: String?
    var email_address: String?
    var friends:Array<String>?
    var active_friends_index_list:Array<Int>?
    var hasInvite:Bool?
    var free_play_wins: Int?
    var free_play_losses: Int?
    var free_play_best_streak: Int?
    var free_play_win_streak: Int?
    var free_play_games: Int?
    var free_play_league: Int?
    var tap_dash_wins: Int?
    var tap_dash_losses: Int?
    var tap_dash_best_streak: Int?
    var tap_dash_win_streak: Int?
    var tap_dash_games: Int?
    var tap_dash_league: Int?
    var tap_coin: Int?
    var numFriends: Int?
    var fArrayCount: Int?
    var hasST: Bool?
    var hasRQ: Bool?
    var hasGI: Bool?
    var hasPhoneNumber: Bool?
    var hasEmailAddress: Bool?
    var is_guest: Bool?
    var has_security_questions: Bool?
    var tap_dash_sign_up: Bool?
}

// Conform the struct to UserDefaultsStorable
extension UserViewModel {
    init?(_ storageValue: Data) {
        if let decoded = try? JSONDecoder().decode(UserViewModel.self, from: storageValue) {
            self = decoded
        } else {
            return nil
        }
    }

    var storageValue: Data {
        if let encoded = try? JSONEncoder().encode(self) {
            return encoded
        } else {
            fatalError("Failed to encode MyData")
        }
    }
}

struct TableUserModel: Identifiable {
    var username:String
    var id: String {
        username
    }
    var wins:Int
    var losses:Int
    var win_percentage:Int
    var total_games:Int
    var league: Int
}
struct TableUserModelCodable: Codable {
    var username:String?
    var wins:Int?
    var losses:Int?
    var win_percentage:Int?
    var total_games:Int?
    var league: Int?
}
