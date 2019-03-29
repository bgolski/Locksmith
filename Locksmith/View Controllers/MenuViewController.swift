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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        device = DeviceInfo()
        
        // Do any additional setup after loading the view.
        
        bannerView.adUnitID = "ca-app-pub-3672141075661360/2582947809" /*"ca-app-pub-3940256099942544/2934735716"*/
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
