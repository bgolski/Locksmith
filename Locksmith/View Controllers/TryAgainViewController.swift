//
//  ModalViewController.swift
//  Locksmith
//
//  Created by Bradley Golski on 3/28/19.
//

import Foundation
import UIKit
import GoogleMobileAds


class TryAgainViewController: UIViewController {
    
    
    
    var scene: EndlessGameViewController?
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.65)
        view.isOpaque = false
        scene?.shareButton.isEnabled = false
        scene?.menuButton.isEnabled = false
        
        let tryAgainView = UIView()
        tryAgainView.isUserInteractionEnabled = true
        tryAgainView.frame = CGRect(x: CGFloat(self.view.bounds.size.width / 2), y: (self.view.bounds.size.height / 2), width: self.view.bounds.width - 50, height: self.view.bounds.height / 4)
        tryAgainView.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.size.height / 2)
        
        tryAgainView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        tryAgainView.layer.shadowOpacity = 1
        tryAgainView.layer.shadowOffset = CGSize.zero
        tryAgainView.layer.shadowRadius = 15
        tryAgainView.layer.cornerRadius = 15
        //        tryAgainView.layer.masksToBounds = true;
        tryAgainView.backgroundColor = UIColor(red: (179/255.0), green: (232/255.0), blue: (148/255.0), alpha: 1.0)
        tryAgainView.tag = 50
        
        let continueLabel = UILabel()
        continueLabel.frame = CGRect(x: 0, y: (tryAgainView.frame.width / 8), width: tryAgainView.frame.width, height: 40)
        continueLabel.textAlignment = .center
        continueLabel.font = UIFont(name: "AvenirNext-Medium", size: (26))
        continueLabel.numberOfLines = 2
        continueLabel.text = "Watch A Video To Continue?"
        continueLabel.textColor = UIColor.white
        tryAgainView.addSubview(continueLabel)
        
        let yesButton = UIButton() //ADDING THE BUTTON
        yesButton.isUserInteractionEnabled = true
        yesButton.isEnabled = true
        yesButton.frame = CGRect(x: CGFloat(self.view.bounds.size.width / 4), y: (self.view.bounds.size.height / 8), width: (self.view.bounds.width / 3) - 2.5, height: tryAgainView.bounds.height / 3)
        yesButton.center = CGPoint(x: tryAgainView.bounds.size.width / 4, y: tryAgainView.bounds.height - (tryAgainView.bounds.size.height / 4))
        yesButton.backgroundColor = UIColor(red: 52.0/255.0, green: 69.0/255.0, blue: 107.0/255.0, alpha: 1.0)
        yesButton.setTitle("Yes", for: .normal)
        yesButton.setTitleColor(UIColor.white, for: .normal)
        yesButton.layer.cornerRadius = 10
        
        let yesTap = UITapGestureRecognizer(target: self, action: #selector(self.handleYes(_:)))
        yesButton.addGestureRecognizer(yesTap) // GETTING THE TAP TO REGISTER
        yesButton.isUserInteractionEnabled = true
        
        tryAgainView.addSubview(yesButton)
        
        
        let noButton = UIButton()
        noButton.isUserInteractionEnabled = true
        noButton.isEnabled = true
        noButton.frame = CGRect(x: CGFloat(self.view.bounds.size.width / 4), y: (self.view.bounds.size.height / 8), width: (self.view.bounds.width / 3) - 2.5, height: tryAgainView.bounds.height / 3)
        noButton.center = CGPoint(x: tryAgainView.bounds.size.width - (tryAgainView.bounds.size.width / 4), y: tryAgainView.bounds.height - (tryAgainView.bounds.size.height / 4))
        noButton.backgroundColor = UIColor(red: 52.0/255.0, green: 69.0/255.0, blue: 107.0/255.0, alpha: 1.0)
        noButton.setTitle("No", for: .normal)
        noButton.setTitleColor(UIColor.white, for: .normal)
        noButton.layer.cornerRadius = 10
        
        let aSelector : Selector = #selector(EndlessGameViewController.removeSubview)
        let tapGesture = UITapGestureRecognizer(target:self, action: aSelector)
        noButton.addGestureRecognizer(tapGesture)
        
        tryAgainView.addSubview(noButton)
        
        
        
        
        self.view?.addSubview(tryAgainView)
        
        
    }
    
    // function which is triggered when handleTap is called
    @objc func handleYes(_ sender: UITapGestureRecognizer) {
        if (scene?.rewardBasedAd.isReady)! {
            scene?.rewardBasedAd.present(fromRootViewController: self)
        }
    }
    
    @objc func removeSubview() {
        scene?.shareButton.isEnabled = true
        scene?.menuButton.isEnabled = true
           self.dismiss(animated: true)
        }
    
}
