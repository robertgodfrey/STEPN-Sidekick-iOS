//
//  MainAd.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 10/1/22.
//
import Foundation
import AppLovinSDK
import FBAudienceNetwork
import SwiftUI

class MainAd: UIViewController, MAAdViewAdDelegate
{
    var adView: MAAdView!

    func createBannerAd() {
        FBAdSettings.setDataProcessingOptions([])
        adView = MAAdView(adUnitIdentifier: ProcessInfo.processInfo.environment["MAIN_AD_ID"] ?? "")
        adView.delegate = self

        // Calculate dimensions
        let x: CGFloat = 0
        let y: CGFloat = 0

        // Banner height on iPhone and iPad is 50 and 90, respectively
        let height: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 90 : 50

        // Stretch to the width of the screen for banners to be fully functional
        let width: CGFloat = UIScreen.main.bounds.width

        adView.frame = CGRect(x: x, y: y, width: width, height: height)

        // Set background or background color for banners to be fully functional
        adView.backgroundColor = UIColor(Color("Light Green"))

        view.addSubview(adView)

        // Load the first ad
        adView.loadAd()
    }

    // MARK: MAAdDelegate Protocol
    func didLoad(_ ad: MAAd) {}

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {}

    func didClick(_ ad: MAAd) {}

    func didFail(toDisplay ad: MAAd, withError error: MAError) {}


    // MARK: MAAdViewAdDelegate Protocol
    func didExpand(_ ad: MAAd) {}

    func didCollapse(_ ad: MAAd) {}


    // MARK: Deprecated Callbacks
    func didDisplay(_ ad: MAAd) { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }
    func didHide(_ ad: MAAd) { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }
}

struct BannerAd: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> MainAd {
        let view = MainAd()
        view.createBannerAd()
        return view
    }

    func updateUIViewController(_ uiViewController: MainAd, context: Context) {

    }
}

struct SwiftUIBannerAd: View {
    @State var height: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 90 : 50
    @State var width: CGFloat = UIScreen.main.bounds.width

    public var body: some View {
            //Ad
            BannerAd()
                .frame(width: width, height: height, alignment: .center)
    }

}
