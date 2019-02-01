//
//  EndlessGameScene.swift
//  Locksmith
//
//  Created by Bradley Golski on 1/30/19.
//

import Foundation
import SpriteKit


protocol GameDelegate {
    func gameStarted()
    func gameFinished()
}


class EndlessGameScene: SKScene {
    var gameDelegate: GameDelegate?
    var lock = SKShapeNode()
    var needle = SKShapeNode()
    var dot = SKShapeNode()
    var path = UIBezierPath()
    var rotationSpeed = 200
    var highScore = 0;
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
    
    override func didMove(to view: SKView) {
        layoutGame()
    }
    
    func layoutGame() {
        backgroundColor = SKColor(red: 26.0/255.0, green: 188.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: zeroAngle, endAngle: zeroAngle + CGFloat(Double.pi * 2), clockwise: true)
        lock = SKShapeNode(path: path.cgPath)
        lock.strokeColor = SKColor.gray
        lock.lineWidth = 40.0
        self.addChild(lock)
        
        needle = SKShapeNode(rectOf: CGSize(width: 40.0 - 7.0, height: 7.0), cornerRadius: 3.5)
        needle.fillColor = SKColor.white
        needle.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 120.0)
        needle.zRotation = 3.14 / 2
        needle.zPosition = 2.0
        self.addChild(needle)
        
        currentScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        currentScoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        currentScoreLabel.fontColor = SKColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        currentScoreLabel.text = "Tap!"
        
        highScoreLabel = SKLabelNode(fontNamed: "AvenirNext")
        highScoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height - 150)
        highScoreLabel.fontColor = SKColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        highScoreLabel.fontSize = CGFloat(20)
        highScoreLabel.text = "High Score: \(highScore)"
        
        self.addChild(highScoreLabel)
        
        self.addChild(currentScoreLabel)
        
        newDot()
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        if !started {
            self.gameDelegate?.gameStarted()
            currentScoreLabel.text = "\(dots)"
            runClockwise()
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
                clockwise = false
            } else {
                runClockwise()
                clockwise = true
            }
        } else {
            started = false
            touches = false
            gameOver()
        }
    }
    
    func updateLabel() {
        currentScoreLabel.text = "\(dots)"
    }
    
    func newDot() {
        dot = SKShapeNode(circleOfRadius: 15.0)
        dot.fillColor = SKColor(red: 31.0/255.0, green: 150.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        dot.strokeColor = SKColor.clear
        
        let dx = needle.position.x - self.frame.width / 2
        let dy = needle.position.y - self.frame.height / 2
        
        let radian = atan2(dy, dx)
        
        let startAngle = (clockwise ? 1 : -1) * CGFloat.random(min: radian + 1.0, max: radian + 2.5)
        
        let tempPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 120, startAngle: startAngle, endAngle: startAngle + CGFloat(Double.pi * 2), clockwise: true)
        dot.position = tempPath.currentPoint
        
        self.addChild(dot)
    }
    
    func completed() {
        isUserInteractionEnabled = false
        needle.removeFromParent()
        currentScoreLabel.text = "Lock Picked!"
        notification.notificationOccurred(.success)
        let actionRed = SKAction.colorize(with: UIColor(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.25)
        let actionBack = SKAction.wait(forDuration: 0.5)
        self.scene?.run(SKAction.sequence([actionRed,actionBack]), completion: { () -> Void in
            self.removeAllChildren()
            self.clockwise = false
            self.dots = 0
            self.rotationSpeed += 5
            self.layoutGame()
            self.gameDelegate?.gameFinished()
        })

    
        
    }
    
    func gameOver() {
        isUserInteractionEnabled = false
        needle.removeFromParent()
        notification.notificationOccurred(.error)
        if (dots > highScore) {
            highScore = dots
            currentScoreLabel.text = "High Score!"
        } else {
            currentScoreLabel.text = "Failure!"
        }
        rotationSpeed = 200
        let actionRed = SKAction.colorize(with: UIColor(red: 149.0/255.0, green: 165.0/255.0, blue: 166.0/255.0, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.25)
        let actionBack = SKAction.wait(forDuration: 0.5)
        updateHighScore()
        self.scene?.run(SKAction.sequence([actionRed,actionBack]), completion: { () -> Void in
            self.removeAllChildren()
            self.clockwise = false
            self.dots = 0
            self.layoutGame()
            self.gameDelegate?.gameFinished()
        })
            
        }
    
    func updateHighScore() {
        if (dots > highScore) {
            highScoreLabel.text = "High Score: \(highScore)"
        }
        
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if started {
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
