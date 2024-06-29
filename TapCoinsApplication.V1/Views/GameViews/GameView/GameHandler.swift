//
//  GameHandler.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SocketIO
import SwiftUI

class GameHandler: NSObject{
    static let sharedInstance = GameHandler()
    let gameSocket = ProcessInfo.processInfo.environment["GAME_SOCKET"] ?? "None"
    let socket = SocketManager(socketURL: URL(string: ProcessInfo.processInfo.environment["GAME_SOCKET"] ?? "None")!, config: [.log(true), .compress])
    var mSocket: SocketIOClient!
    override init(){
        super.init()
        mSocket = socket.defaultSocket
    }

    func getSocket() -> SocketIOClient {
        return mSocket
    }

    func establishConnection(){
        mSocket.connect()
    }

    func closeConnection(){
        mSocket.disconnect()
    }
}
