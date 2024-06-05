//
//  BannerAd.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/15/24.
//

import Foundation
import GoogleMobileAds
import SwiftUI

struct BannerAd: UIViewRepresentable {
    @AppStorage("ad_loaded") var ad_loaded: Bool?

    var unitID: String

    func makeCoordinator() -> Coordinator {
        return Coordinator(adBanner: self)
    }

    func makeUIView(context: Context) -> GADBannerView {

        let adView = GADBannerView(adSize: GADAdSizeBanner)

        adView.adUnitID = unitID
        adView.rootViewController = UIApplication.shared.getRootViewController()
        adView.delegate = context.coordinator
        adView.load(GADRequest())

        return adView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
//        if uiView.frame.width > 0.0{
//            print("AD LOADED IS TRUE NOW")
//            ad_loaded = true
//        }
    }

    class Coordinator: NSObject, GADBannerViewDelegate {
        var adBanner: BannerAd

        init(adBanner: BannerAd) {
            self.adBanner = adBanner
        }
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
          print("bannerViewDidReceiveAd")
          NotificationCenter.default.post(name: Notification.Name("AdLoadedNotification"), object: nil)
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
          print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        }

        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
          print("bannerViewDidRecordImpression")
        }

        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillPresentScreen")
        }

        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillDIsmissScreen")
        }

        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewDidDismissScreen")
        }
    }
}

extension UIApplication {
    func getRootViewController()->UIViewController{

        guard let screen = self.connectedScenes.first as? UIWindowScene else{
            return.init()
        }

        guard let root = screen.windows.first?.rootViewController else{
            return.init()
        }
        return root
    }
}


// Banner Ad
