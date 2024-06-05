//
//  GlobalEnums.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation

enum League: Int, CaseIterable {
    case NOOB = 1
    case BAD = 2
    case OKAY = 3
    case BETTER = 4
    case GOOD = 5
    case SOLID = 6
    case SUPER = 7
    case MEGA = 8
    case GODLY = 9
}

enum Error_States:String {
    case Required = "Required"
    case RequiredLogin = "RequiredLogin"
    case Invalid_Phone_Number = "Invalid phone number."
    case Invalid_Username = "Username already exists."
    case Password_Match = "Passwords must match."
    case No_Match_User = "Could not find username."
    case No_Match_Password = "Incorrect Password."
    case Specific_Password_Error = "SPE"
    case Invalid_Email_Address = "Invalid email address."
}

enum Error_Types: String, CaseIterable  {
    case BlankPassword, PreviousPassword, TimeLimitCode, SomethingWentWrong
    
    var index: Int { Error_Types.allCases.firstIndex(of: self) ?? 0 }
}

enum CloudKitError: String, LocalizedError{
    case iCloudAccountNotFound
    case iCloudAccountNotDetermined
    case iCloudAccountRestricted
    case iCloudAccountUnknown
}

enum ToggleSettingTitles:Int{
    case NotificationsToggle = 0
    case SoundsToggle = 1
    case HapticsToggle = 2
    case LocationToggle = 3
    case LightDarkModeToggle = 4
    case TapDashToggle = 5
}

enum FriendItemState:Int {
    case NormalFriend = 0
    case DynamicFriend = 1
    case NoFriend = 2
}

enum PostDataError:Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

enum UserErrors:Error {
    case invalidSession
}
