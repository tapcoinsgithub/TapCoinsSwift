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
    @AppStorage("debug") private var debug: Bool?
    static let sharedInstance = GameHandler()
    let socket = SocketManager(socketURL: URL(string: "https://tapcoins-game-server-5df63863242c.herokuapp.com")!, config: [.log(true), .compress])
    let devSocket = SocketManager(socketURL: URL(string: "ws://localhost:8764")!, config: [.log(true), .compress])
    var mSocket: SocketIOClient!
    override init(){
        super.init()
        if debug ?? false {
            mSocket = devSocket.defaultSocket
        }
        else{
            mSocket = socket.defaultSocket
        }
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
