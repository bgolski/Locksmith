//
//  MenuViewController.swift
//  Locksmith 
//
//  Created by Bradley Golski on 1/22/19.
//  Copyright © 2019 Bradley Golski. All rights reserved.
//

import UIKit
import GoogleMobileAds
import GameKit

class MenuViewController: UIViewController /* GKGameCenterControllerDelegate */ {
    
    var device: DeviceInfo?
    var gcEnabled = Bool()
    var gcDefaultLeaderboard = String()
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var titleView: UILabel!
    
    
    @IBAction func endlessButtonHandler(_ sender: Any) {
        performSegue(withIdentifier: "menuToEndless", sender: self)
        
    }
    
    
    @IBAction func statsButtonHandler(_ sender: Any) {
    performSegue(withIdentifier: "menuToStats", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        device = DeviceInfo()
        
        // Do any additional setup after loading the view.
        
        bannerView.adUnitID = "ca-app-pub-3672141075661360/2582947809"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        titleView.font = UIFont(name: "AvenirNext-Bold", size: (device?.retrieveTitleFontSize())!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
