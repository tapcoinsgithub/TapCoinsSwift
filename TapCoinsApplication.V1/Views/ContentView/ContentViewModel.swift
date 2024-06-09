//
//  ContentViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class ContentViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("de_queue") private var de_queue: Bool?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("changing_password") private var changing_password: Bool?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("darkMode") var darkMode: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @Published var glPressed:Bool = false
    
    init() {
//        in_game = false
//        in_queue = false
//        logged_in_user = nil
        debug = true
        if debug ?? false {
            print("DEBUG IS TRUE")
        }
        else{
            print("DEBUG IS FALSE")
        }
        if logged_in_user == nil{
            changing_password = false
        }
    }
    
    func guestLogin(){
        glPressed = true
        var url_string:String = ""
        if debug ?? false{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/guestLogin"
        }
        else{
            url_string = "https://tapcoins-api-318ee530def6.herokuapp.com/tapcoinsapi/user/guestLogin"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "guest":"login",
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(GLResponse.self, from: data)
                    if response.error == false{
                        self?.logged_in_user = response.token
                        self?.glPressed = false
                    }
                    else{
                        self?.glPressed = false
                    }
                }
                catch{
                    self?.glPressed = false
                }
            }
        })
        task.resume()
    }
    
    struct GLResponse:Codable {
        let response:String
        let username:String
        let error:Bool
        let token:String
    }
}
