//
//  UserAds.swift
//  Locksmith
//
//  Created by Bradley Golski on 2/22/19.
//

import Foundation
import GoogleMobileAds


class UserAds {
    var interstitial = GADInterstitial(adUnitID:
        /*"ca-app-pub-3940256099942544/4411468910"*/
        "ca-app-pub-3672141075661360/3005448192"
    )
    let request = GADRequest()
    
    func loadAd() {
        interstitial.load(request)
    }
    
}
