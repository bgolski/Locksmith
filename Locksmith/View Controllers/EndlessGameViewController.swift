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


class EndlessGameViewController: UIViewController, GameDelegate, GADRewardBasedVideoAdDelegate {
    
    var user = UserInfo()
    var device = DeviceInfo()
    var delegate: StartOverDelegate?
    var gameScene: EndlessGameScene?
    var tryAgainViewController: TryAgainViewController?
    var pauseViewController: PauseViewController?
    var interstitial: GADInterstitial! // Initiating the ad object
    var continueMode: Bool?
    var newImage: UIImage?
    var gamesCompleted = 0
    var rewardBasedAd: GADRewardBasedVideoAd!
    var adWatched = false
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func shareButtonHandler(_ sender: Any) {
        if let image = newImage {
            share(image: image)
        }
    }
    
    @IBOutlet weak var menuButton:UIButton!
    
    @IBAction func menuButtonHandler(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pauseButton(_ sender: Any) {
            pauseButton.isHidden = true
            self.pauseViewController = PauseViewController()
            if let pauseViewController = self.pauseViewController {
                pauseViewController.modalPresentationStyle = .overCurrentContext
                pauseViewController.modalTransitionStyle = .crossDissolve
                pauseViewController.scene = self
                pauseViewController.gameScene = self.gameScene
                present(pauseViewController, animated: true)
        }
    }
    
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rewardBasedAd = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedAd.delegate = self
        rewardBasedAd.load(GADRequest(), withAdUnitID: "ca-app-pub-3672141075661360/4079453189")
        
        shareButton.isHidden = true
        pauseButton.isHidden = true
        let scene = EndlessGameScene(size: view.bounds.size)
        // Configure the view
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        skView.tag = 20
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill

        self.gameScene = scene
        
        scene.gameDelegate = self
        
    
        
        skView.presentScene(scene)
    }
    
    func gameStarted() {
        shareButton.isHidden = true
        pauseButton.isHidden = false
        interstitial = createAndLoadInterstitial()
        rewardBasedAd.load(GADRequest(), withAdUnitID: "ca-app-pub-3672141075661360/4079453189")
    }
    
    func gameFinished(dots: Int, highScore: Int) {
        shareButton.isHidden = false
        pauseButton.setImage(#imageLiteral(resourceName: "pause-40"), for: .normal)
        pauseButton.isHidden = true
        if (Double(dots) >= (Double(highScore) * 0.50) && adWatched == false && rewardBasedAd.isReady) {
            adWatched = true
            self.tryAgainViewController = TryAgainViewController()
            if let tryAgainViewController = self.tryAgainViewController{
                tryAgainViewController.modalPresentationStyle = .overCurrentContext
                tryAgainViewController.modalTransitionStyle = .crossDissolve
                tryAgainViewController.scene = self
                present(tryAgainViewController, animated: true)
            }
        } else {
            gamesCompleted += 1
            adWatched = false
            if (gamesCompleted % 2 == 0) {
                if interstitial.isReady {
                    interstitial.present(fromRootViewController: self)
                    interstitial = GADInterstitial(adUnitID:"ca-app-pub-3672141075661360/3005448192")
                    let request = GADRequest()
                    interstitial.load(request)
                } else {
                    print("Error loading ad")
                }
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
    
    // function which is triggered when handleTap is called
    @objc func handleYes(_ sender: UITapGestureRecognizer) {
        if rewardBasedAd.isReady {
            rewardBasedAd.present(fromRootViewController: self)
        }
    }
    
    @objc func removeSubview() {
        if let viewWithTag = self.view.viewWithTag(50) {
            viewWithTag.removeFromSuperview()
        }else{
            print("Failed to load ad!")
        }
        self.view.isUserInteractionEnabled = true
    }
    
    
    func snapPic() {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 1.0)
        self.view.drawHierarchy(in: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), afterScreenUpdates: false)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
    }
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3672141075661360/3005448192")
        interstitial.delegate = self as? GADInterstitialDelegate
        interstitial.load(GADRequest())
        return interstitial
    }
    
    //REWARD AD FUNCTIONS
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad has completed.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
        self.tryAgainViewController?.dismiss(animated: true)
        self.menuButton.isEnabled = true
        self.shareButton.isEnabled = true
        self.gameScene?.restartingGame()
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
    }
    
    
    
    
    
    
}
