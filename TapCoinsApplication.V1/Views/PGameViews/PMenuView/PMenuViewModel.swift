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
    @AppStorage("haptics") var haptics_on:Bool?
    @Published var easyModeNavIsActive:Bool = false
    @Published var mediumModeNavIsActive:Bool = false
    @Published var hardModeNavIsActive:Bool = false
    
    func got_difficulty(diff:String){
        pGame = diff
    }
}
