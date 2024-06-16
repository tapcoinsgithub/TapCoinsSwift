//
//  CustomGameHandler.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SocketIO
import SwiftUI
//
class CustomGameHandler: NSObject{
    @AppStorage("false") private var debug: Bool?
    static let sharedInstance = CustomGameHandler()
    let socket = SocketManager(socketURL: URL(string: "https://tapcoins-custom-game-server-92c83a1c0b30.herokuapp.com")!, config: [.log(true), .compress])
    let devSocket = SocketManager(socketURL: URL(string: "ws://localhost:8763")!, config: [.log(true), .compress])
    var mSocket: SocketIOClient!
    override init(){
        super.init()
        if debug ?? true {
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
