//
//  PMenuViewModel.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

final class PMenuViewModel: ObservableObject{
    @AppStorage("pGame") var pGame: String?
    
    func got_difficulty(diff:String){
        pGame = diff
    }
}
