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
    
//    func authenticateLocalPlayer() {
//        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
//
//        localPlayer.authenticateHandler = {(MenuViewController, error) -> Void in
//            if (MenuViewController != nil) {
//                self.present(MenuViewController, animated: true)
//            } else if (localPlayer.isAuthenticated) {
//                print("Local player is already authenticated")
//                self.gcEnabled = true
//
//                localPlayer.loadDefaultLeaderboardIdentifier(leaderboardIdentifier: String!, error: NSError!) -> Void in
//                if error != nil {
//                    print(error)
////                } else {
////                    self.
////                }
//    
//                
//                
//                
//            } else {
//                self.gcEnabled = false
//                print("Local player could not be authenticated, disabling Game Center")
//            }
//            
//        }
//    }
//    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
