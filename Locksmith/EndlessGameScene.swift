//
//  EndlessGameScene.swift
//  Locksmith
//
//  Created by Bradley Golski on 1/30/19.
//

import Foundation
import SpriteKit
import FirebaseDatabase
import GoogleMobileAds

protocol GameDelegate {
    func gameStarted()
    func gameFinished()
}


class EndlessGameScene: SKScene {
    var newUser: UserInfo?
    var ads: UserAds?
    var gameDelegate: GameDelegate?
    var lock = SKShapeNode()
    var needle = SKShapeNode()
    var dot = SKShapeNode()
    var path = UIBezierPath()
    var rotationSpeed = 200
    let zeroAngle: CGFloat = 0.0
    var clockwise = Bool()
    let impact = UIImpactFeedbackGenerator() //Haptic Feedback
    let notification = UINotificationFeedbackGenerator()
    var started = false
    var touches = false
    var dots = 0
    var gameCompleted = 0
    var currentScoreLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
//    var safeImage = UIImageView(image: #imageLiteral(resourceName: "LockHandles"))
    var scoreLabel = UILabel()
    var bgRed = 28.0
    var bgBlue = 243.0
    var bgGreen = 219.0
    
    override func didMove(to view: SKView) {
        newUser = UserInfo()
        ads = UserAds()
        layoutGame()
        
    }
    
    func layoutGame() {
        
        var height:CGFloat, width:CGFloat
        
        if #available(iOS 11.0, *) {
            width = self.frame.width
            height = (self.frame.height/2)
        } else {
            width = self.frame.width
            height = self.frame.height
        }
        // iPhone XS Max - 32px
        // iPhone 5s     - 22px
        
        // 32   w
        // -- = -- (32-22)m=(w-ow) (32-22)/(w-ow)=m     w*m = font size
        // 22   ow

        backgroundColor = SKColor(red: 28.0/255.0, green: 219.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        
//        safeImage.alpha = 1
//        print("height : \(safeImage.frame.size.height)")
//        safeImage.frame = CGRect(x: self.frame.width / 2, y: self.frame.height / 2, width: 225, height: 225)
//        safeImage.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
//
//        self.view?.addSubview(safeImage)
        
        path = UIBezierPath(arcCenter: CGPoint(x: width/2, y: height), radius: 120, startAngle: zeroAngle, endAngle: zeroAngle + CGFloat(Double.pi * 2), clockwise: true)
        lock = SKShapeNode(path: path.cgPath)
        lock.strokeColor = SKColor.gray
        lock.lineWidth = 40.0
        self.addChild(lock)
        needle = SKShapeNode(rectOf: CGSize(width: 40.0 - 7.0, height: 7.0), cornerRadius: 3.5)
        needle.fillColor = SKColor.white
        needle.position = CGPoint(x: width/2, y: height + 120.0)
        needle.zRotation = 3.14 / 2
        needle.zPosition = 2.0
        self.addChild(needle)
        scoreLabel.center = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.font = UIFont(name: "AvenirNext-Bold", size: 30.0)
        scoreLabel.textColor = UIColor(displayP3Red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        scoreLabel.text = "Tap!"
        scoreLabel.frame = CGRect(x: frame.midX, y: frame.midY, width: self.frame.width / 2, height: 53)
        scoreLabel.center = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.textAlignment = .center
        
        self.view?.addSubview(scoreLabel)
        highScoreLabel = SKLabelNode(fontNamed: "AvenirNext")
        highScoreLabel.position = CGPoint(x: width/2, y: self.frame.height - (self.frame.height * 0.2))
        highScoreLabel.fontColor = SKColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        highScoreLabel.fontSize = CGFloat(20)
        
        self.addChild(highScoreLabel)
        
        self.addChild(currentScoreLabel)
        
        newDot()
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        if !started {
            runClockwise()
            self.gameDelegate?.gameStarted()
            scoreLabel.text = "\(dots)"
            started = true
            clockwise = true
        } else {
            dotTouched()
        }
    }
    
    func runClockwise() {
        let dx = needle.position.x - self.frame.width / 2
        let dy = needle.position.y - self.frame.height / 2
        
        let radian = atan2(dy, dx)
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 120, startAngle: radian, endAngle: radian + CGFloat(Double.pi * 2), clockwise: true)
        let run = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, speed: CGFloat(rotationSpeed))
        needle.run(SKAction.repeatForever(run).reversed())
    }
    
    func runCounterClockwise() {
        let dx = needle.position.x - self.frame.width / 2
        let dy = needle.position.y - self.frame.height / 2
        
        let radian = atan2(dy, dx)
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 120, startAngle: radian, endAngle: radian + CGFloat(Double.pi * 2), clockwise: true)
        let run = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, speed: CGFloat(rotationSpeed))
        needle.run(SKAction.repeatForever(run))
    }
    
    func dotTouched() {
        if touches == true {
            touches = false
            dots += 1
            impact.impactOccurred()
            rotationSpeed += 5
            updateLabel()
            dot.removeFromParent()
            newDot()
            if clockwise {
                runCounterClockwise()
                updateBackgroundColor()
                clockwise = false
            } else {
                runClockwise()
                updateBackgroundColor()
                clockwise = true
            }
        } else {
            started = false
            touches = false
            gameOver()
        }
    }
    
    func updateLabel() {
        scoreLabel.text = "\(dots)"
    }
    
    func newDot() {
        dot = SKShapeNode(circleOfRadius: 15.0)
//        dot.fillColor = SKColor(red: 31.0/255.0, green: 150.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        dot.fillColor = SKColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        dot.strokeColor = SKColor.clear
        
        let dx = needle.position.x - self.frame.width / 2
        let dy = needle.position.y - self.frame.height / 2
        
        let radian = atan2(dy, dx)
        
        let startAngle = (clockwise ? 1 : -1) * CGFloat.random(min: radian + 2.0, max: radian + 2.0)
        
        
        let tempPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 120, startAngle: startAngle, endAngle: startAngle + CGFloat(Double.pi * 2), clockwise: true)
        dot.position = tempPath.currentPoint
        self.addChild(dot)
    }
    
    func gameOver() {
        isUserInteractionEnabled = false
        needle.removeFromParent()
        notification.notificationOccurred(.error)
        
        if let user = self.newUser{
            if (dots > user.retrieveHighScore()) {
                scoreLabel.text = "High Score!"
                updateHighScore(highScore: dots)
            } else {
                scoreLabel.text = "Failure!"
            }
        }
        
        rotationSpeed = 200
        let actionRed = SKAction.colorize(with: UIColor(red: 149.0/255.0, green: 165.0/255.0, blue: 166.0/255.0, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.25)
        let actionBack = SKAction.wait(forDuration: 0.5)
        
        self.scene?.run(SKAction.sequence([actionRed,actionBack]), completion: { () -> Void in
           self.backgroundColor = SKColor(red: 28.0/255.0, green: 219.0/255.0, blue: 243.0/255.0, alpha: 1.0)
            self.removeAllChildren()
            self.clockwise = false
            self.dots = 0
            self.bgRed = 28.0
            self.bgGreen = 219.0
            self.bgBlue = 243.0
            self.layoutGame()
            self.gameDelegate?.gameFinished()
        })
        }
    
    func updateHighScore(highScore: intmax_t) {
        newUser?.setHighScore(newHighScore: highScore)
    }
    
    func updateBackgroundColor() {
        // Change bg vars
        if (dots > 10) {
            bgRed += 4
            bgBlue -= 3
            bgGreen -= 3
            backgroundColor = SKColor(red: CGFloat(bgRed)/255.0, green: CGFloat(bgGreen)/255.0, blue: CGFloat(bgBlue)/255.0, alpha: 1.0)
            
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if started {
            if let user = self.newUser {
                if (user.retrieveHighScore() != -1) {
                    self.highScoreLabel.text = "High Score: \(String(describing: user.retrieveHighScore()))"
                }
            }
            if needle.intersects(dot) {
                touches = true
            } else {
                if touches == true {
                    if !needle.intersects(dot) {
                        started = false
                        touches = false
                        gameOver()
                    }
                }
            }
        }
    }
}
