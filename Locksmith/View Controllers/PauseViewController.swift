//
//  PauseViewController.swift
//  Locksmith
//
//  Created by Bradley Golski on 4/21/19.
//

import Foundation
import UIKit

class PauseViewController: UIViewController {
    
    var scene: EndlessGameViewController?
    var gameScene: EndlessGameScene?
    var countdownTimer = Timer()
    var totalTime = 2
    let pauseView = UIView()
    
    
    override func viewDidLoad() {
        gameScene?.needle.isPaused = true
        pauseView.isUserInteractionEnabled = true
        pauseView.frame = CGRect(x: CGFloat(self.view.bounds.size.width / 2), y: (self.view.bounds.size.height / 2), width: self.view.bounds.width - 50, height: self.view.bounds.height / 4)
        pauseView.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.size.height / 2)
        
        pauseView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        pauseView.layer.shadowOpacity = 1
        pauseView.layer.shadowOffset = CGSize.zero
        pauseView.layer.shadowRadius = 15
        pauseView.layer.cornerRadius = 15
        pauseView.backgroundColor = UIColor(red: (179/255.0), green: (232/255.0), blue: (148/255.0), alpha: 1.0)
        pauseView.tag = 50
        
        let pauseLabel = UILabel()
        pauseLabel.frame = CGRect(x: 0, y: (pauseView.frame.width / 8), width: pauseView.frame.width, height: 40)
        pauseLabel.textAlignment = .center
        pauseLabel.font = UIFont(name: "Baskerville-Medium", size: (40))
        pauseLabel.numberOfLines = 2
        pauseLabel.text = "Paused"
        pauseLabel.textColor = UIColor.white
        pauseView.addSubview(pauseLabel)
        
        
        let pauseButton = UIButton() //ADDING THE BUTTON
        pauseButton.isUserInteractionEnabled = true
        pauseButton.isEnabled = true
        pauseButton.frame = CGRect(x: CGFloat(self.view.bounds.size.width / 4), y: (self.view.bounds.size.height / 8), width: (self.view.bounds.width / 3) - 2.5, height: pauseView.bounds.height / 3)
        pauseButton.center = CGPoint(x: pauseView.bounds.size.width / 2, y: pauseView.bounds.height - (pauseView.bounds.size.height / 4))
        pauseButton.backgroundColor = UIColor(red: 52.0/255.0, green: 69.0/255.0, blue: 107.0/255.0, alpha: 1.0)
        pauseButton.setTitle("Resume", for: .normal)
        pauseButton.setTitleColor(UIColor.white, for: .normal)
        pauseButton.layer.cornerRadius = 10
        
        let yesTap = UITapGestureRecognizer(target: self, action: #selector(self.resumeGame(_:)))
        pauseButton.addGestureRecognizer(yesTap) // GETTING THE TAP TO REGISTER
        pauseButton.isUserInteractionEnabled = true
        pauseView.addSubview(pauseButton)
        
        
        
        
        self.view?.addSubview(pauseView)
        
        
        
    view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.3)
    view.isOpaque = false
    }
    
    func startTimer() {
        gameScene?.scoreLabel.text = "3"
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        gameScene?.scoreLabel.text = "\(totalTime)"
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        self.scene?.pauseButton.isHidden = false
        self.dismiss(animated: true)
        gameScene?.needle.isPaused = false
        gameScene?.scoreLabel.text = "\(gameScene?.dots ?? 0)"
        totalTime = 2
    }
    
    @objc func resumeGame(_ sender: UITapGestureRecognizer) {
        startTimer()
        pauseView.removeFromSuperview()
    }

}
