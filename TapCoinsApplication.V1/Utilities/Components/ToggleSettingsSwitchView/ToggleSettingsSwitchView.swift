//
//  ToggleSettingsSwitchView.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import SwiftUI

struct ToggleSettingsSwitchView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = ToggleSettingsSwitchViewModel()
    var newCustomColorsModel = CustomColorsModel()
    var toggle_setting_title:ToggleSettingTitles
    var toggle_label:String
    var body: some View {
        switch (toggle_setting_title){
        case ToggleSettingTitles.NotificationsToggle:
            Toggle(isOn:Binding(
                get: { viewModel.notifications_on ?? false },
                set: { viewModel.notifications_on = $0 }
            ),
            label: {
                Text(toggle_label).foregroundColor(.black)
            })
            .disabled(viewModel.is_guest)
            .onTapGesture {
                viewModel.turn_on_off_notifications()
            }
        case ToggleSettingTitles.SoundsToggle:
            Toggle(isOn: Binding(
                get: { viewModel.sound_on ?? false },
                set: { viewModel.sound_on = $0 }
            ),
                   label: {
                Text(toggle_label).foregroundColor(.black)
                   })
        case ToggleSettingTitles.HapticsToggle:
            Toggle(isOn: Binding(
                get: { viewModel.haptics_on ?? false },
                set: { viewModel.haptics_on = $0 }
            ),
                   label: {
                Text(toggle_label).foregroundColor(.black)
                   })
        case ToggleSettingTitles.LocationToggle:
            Toggle(isOn: Binding(
                get: { viewModel.location_on ?? false },
                set: { viewModel.location_on = $0 }
            ),
                   label: {
                Text(toggle_label).foregroundColor(.black)
                   })
            .disabled(viewModel.is_guest)
            .onTapGesture {
                if viewModel.location_on ?? false{
//                    LocationManager.instance.requestLocation()
                }
            }
        case ToggleSettingTitles.LightDarkModeToggle:
            Toggle(isOn: Binding(
                get: { viewModel.darkMode ?? false },
                set: { viewModel.darkMode = $0 }
            ),
                   label: {
                Text(toggle_label).foregroundColor(.black)
                   })
        case .TapDashToggle:
            Toggle(isOn: Binding(
                get: { viewModel.tapDash ?? false },
                set: { viewModel.tapDash = $0 }
            ),
                   label: {
                if viewModel.tapDashIsActive ?? false{
                    Text(viewModel.has_contact_info ?? false ? toggle_label : "Please add the phone number/email associated with your Zelle account to activate Streak Dash.").foregroundColor(.black)
                }
                else{
                    Text("Streak Dash has been disabled for the day, please come back tomorrow.").foregroundColor(.black)
                }
            })
            .disabled(viewModel.has_contact_info == false || viewModel.tapDashIsActive == false)
            .onTapGesture {
                if viewModel.has_contact_info == true && viewModel.tapDashIsActive ?? false {
                    viewModel.set_tap_dash()
                }
            }
        }
    }
}
