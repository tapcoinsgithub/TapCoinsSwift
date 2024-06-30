//
//  QueueHandler.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SocketIO
import SwiftUI

class QueueHandler: NSObject{
    static let sharedInstance = QueueHandler()
    let socket = SocketManager(socketURL: URL(string: GlobalVariables().queueSocket)!, config: [.log(true), .compress])
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
