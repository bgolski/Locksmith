//
//  MenuViewController.swift
//  Locksmith 
//
//  Created by Bradley Golski on 1/22/19.
//  Copyright © 2019 Bradley Golski. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MenuViewController: UIViewController {
    
    var device: DeviceInfo?
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var lockImage: UIImageView!
    
    @IBOutlet weak var titleView: UILabel!
    
    
    @IBAction func endlessButtonHandler(_ sender: Any) {
        performSegue(withIdentifier: "menuToEndless", sender: self)
        
    }
    
    
    @IBAction func statsButtonHandler(_ sender: Any) {
    performSegue(withIdentifier: "menuToStats", sender: self)
    }
//    
//    @IBAction func playButtonHandler(sender: AnyObject) {
//        let gvc = storyboard?.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
//        gvc.continueMode = false
//        present(gvc, animated: true, completion: nil)
//    }
//    
//    @IBAction func continueButtonHandler(sender: AnyObject) {
//        let gvc = storyboard?.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController
//        gvc.continueMode = true
//        present(gvc, animated: true, completion: nil)
//    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
