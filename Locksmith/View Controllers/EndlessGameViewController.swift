//
//  EndlessGameViewController.swift
//  Locksmith
//
//  Created by Bradley Golski on 1/30/19.
//

import Foundation
import UIKit
import SpriteKit
import GoogleMobileAds
import FirebaseDatabase

class EndlessGameViewController: UIViewController, GameDelegate {
    
    var interstitial: GADInterstitial! // Initiating the ad object
    var continueMode: Bool?
    var newImage: UIImage?
    var gamesCompleted = 0;
    
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func shareButtonHandler(_ sender: Any) {
        if let image = newImage {
            share(image: image)
        }
    }
    @IBAction func menuButtonHandler(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        interstitial.load(request)
        
        shareButton.isHidden = true
        //BREAKS WHEN IT HITS THIS LINE
       // let dbRef = Database.database().reference()
        
        
        
        let scene = EndlessGameScene(size: view.bounds.size)
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill

        
        scene.gameDelegate = self
        
        skView.presentScene(scene)
    }
    
    func gameStarted() {
        shareButton.isHidden = true
    }
    
    func gameFinished() {
        shareButton.isHidden = false
        gamesCompleted += 1
        if (gamesCompleted % 2 == 0) {
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            }
        }
        snapPic()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func share(image: UIImage) {
        let avc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        present(avc, animated: true, completion: nil)
    }
    
    func snapPic() {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 1.0)
        self.view.drawHierarchy(in: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), afterScreenUpdates: false)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
    }
}
