//
//  GlobalValues.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

//@AppStorage("Player1") var first_player: String?
//@AppStorage("Player2") var second_player: String?
//@AppStorage("gameId") var game_id: String?
//@AppStorage("from_queue") var from_queue: Bool?
//@AppStorage("custom_game") var custom_game: Bool?
//@AppStorage("is_first") var is_first: Bool?
//@AppStorage("in_game") var in_game: Bool?
//@AppStorage("user") private var userViewModel: Data?
//@AppStorage("num_friends") public var num_friends:Int?


//    func addRequest(sender:String, receiver:String, requestType: String) -> String{
//        var newRequest: CKRecord?
//        if requestType == "FriendRequest"{
//            newRequest = CKRecord(recordType: "FriendRequest")
//        }
//        else if requestType == "GameInvite"{
//            newRequest = CKRecord(recordType: "GameInvite")
//        }
//        else{
//            newRequest = nil
//        }
//        if newRequest == nil{
//            return "NilRequest"
//        }
//        newRequest!["sender"] = sender
//        newRequest!["receiver"] = receiver
//        let result = (newRequest!["sender"] ?? "No Sender") + " | " + (newRequest!["receiver"] ?? "No Receiver")
//        if saveRequest(record: newRequest!){
//            return result
//        }
//        else{
//            return "SaveFail"
//        }
//    }
//
//    func saveRequest(record:CKRecord) -> Bool{
//        var passed = false
//        CKContainer(identifier: "iCloud.com.ericviera.TapTapCoin").publicCloudDatabase.save(record) { [self] returnedRecord, returnedError in
//            if returnedError != nil{
//                passed = false
//            }
//            if returnedRecord != nil{
//                passed = true
//            }
//        }
//        return passed
//    }
