//
//  GameScene.swift
//  Locksmith
//
//  Created by Bradley Golski on 1/22/19.
//  Copyright © 2019 Bradley Golski. All rights reserved.
//
//
//import SpriteKit
//
//
//@available(iOS 10.0, *)
//class GameScene: SKScene {
//
//    var gameDelegate: GameDelegate?
//    var lock = SKShapeNode()
//    var needle = SKShapeNode()
//    var dot = SKShapeNode()
//    var path = UIBezierPath()
//    var rotationSpeed = 200
//    let impact = UIImpactFeedbackGenerator() //Haptic Feedback
//    let notification = UINotificationFeedbackGenerator()
//    let zeroAngle: CGFloat = 0.0
//
//    var clockwise = Bool()
//    var continueMode = Bool()
//    var maxLevel = UserDefaults.standard.integer(forKey: "maxLevel")
//
//    var started = false
//    var touches = false
//
//    var level = 1
//    var dots = 0
//    var gameCompleted = 0
//    var levelLabel = SKLabelNode()
//    var currentScoreLabel = SKLabelNode()
//
//    override func didMove(to view: SKView) {
//        if continueMode {
//            level = maxLevel
//        }
//        layoutGame()
//    }
//
//    func layoutGame() {
//        backgroundColor = SKColor(red: 26.0/255.0, green: 188.0/255.0, blue: 156.0/255.0, alpha: 1.0)
//
//        if level > maxLevel {
//            UserDefaults.standard.set(level, forKey: "maxLevel")
//        }
//
//        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: zeroAngle, endAngle: zeroAngle + CGFloat(Double.pi * 2), clockwise: true)
//        lock = SKShapeNode(path: path.cgPath)
//        lock.strokeColor = SKColor.gray
//        lock.lineWidth = 40.0
//        self.addChild(lock)
//
//        needle = SKShapeNode(rectOf: CGSize(width: 40.0 - 7.0, height: 7.0), cornerRadius: 3.5)
//        needle.fillColor = SKColor.white
//        needle.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 120.0)
//        needle.zRotation = 3.14 / 2
//        needle.zPosition = 2.0
//        self.addChild(needle)
//
//        levelLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
//        levelLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + self.frame.height/3)
//        levelLabel.fontColor = SKColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
//        levelLabel.text = "Level \(level)"
//
//        currentScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
//        currentScoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
//        currentScoreLabel.fontColor = SKColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
//        currentScoreLabel.text = "Tap!"
//
//        self.addChild(levelLabel)
//        self.addChild(currentScoreLabel)
//
//        newDot()
//        isUserInteractionEnabled = true
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        /* Called when a touch begins */
//        if !started {
//            self.gameDelegate?.gameStarted()
//            currentScoreLabel.text = "\(level - dots)"
//            runClockwise()
//            started = true
//            clockwise = true
//        } else {
//            dotTouched()
//        }
//    }
//
//    func runClockwise() {
//        let dx = needle.position.x - self.frame.width / 2
//        let dy = needle.position.y - self.frame.height / 2
//
//        let radian = atan2(dy, dx)
//
//        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 120, startAngle: radian, endAngle: radian + CGFloat(Double.pi * 2), clockwise: true)
//        let run = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, speed: CGFloat(rotationSpeed))
//        needle.run(SKAction.repeatForever(run).reversed())
//    }
//
//    func runCounterClockwise() {
//        let dx = needle.position.x - self.frame.width / 2
//        let dy = needle.position.y - self.frame.height / 2
//
//        let radian = atan2(dy, dx)
//
//        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 120, startAngle: radian, endAngle: radian + CGFloat(Double.pi * 2), clockwise: true)
//        let run = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, speed: CGFloat(rotationSpeed))
//        needle.run(SKAction.repeatForever(run))
//    }
//
//    func dotTouched() {
//        if touches == true {
//            touches = false
//            dots += 1
//            impact.impactOccurred()
//            updateLabel()
//            if dots >= level {
//                started = false
//                completed()
//                return
//            }
//            dot.removeFromParent()
//            newDot()
//            if clockwise {
//                runCounterClockwise()
//                clockwise = false
//            } else {
//                runClockwise()
//                clockwise = true
//            }
//        } else {
//            started = false
//            touches = false
//            gameOver()
//        }
//    }
//
//    func updateLabel() {
//        currentScoreLabel.text = "\(level - dots)"
//    }
//
//    func newDot() {
//        dot = SKShapeNode(circleOfRadius: 15.0)
//        dot.fillColor = SKColor(red: 31.0/255.0, green: 150.0/255.0, blue: 255.0/255.0, alpha: 1.0)
//        dot.strokeColor = SKColor.clear
//
//        let dx = needle.position.x - self.frame.width / 2
//        let dy = needle.position.y - self.frame.height / 2
//
//        let radian = atan2(dy, dx)
//
//        if clockwise {
//            let tempAngle = CGFloat.random(min: radian + 1.0, max: radian + 2.5)
//            let tempPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(Double.pi * 2), clockwise: true)
//            dot.position = tempPath.currentPoint
//        } else {
//            let tempAngle = CGFloat.random(min: radian - 1.0, max: radian - 2.5)
//            let tempPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(Double.pi * 2), clockwise: true)
//            dot.position = tempPath.currentPoint
//        }
//
//        self.addChild(dot)
//    }
//
//    func completed() {
//        isUserInteractionEnabled = false
//        needle.removeFromParent()
//        currentScoreLabel.text = "Lock Picked!"
//        notification.notificationOccurred(.success)
//        let actionRed = SKAction.colorize(with: UIColor(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.25)
//        let actionBack = SKAction.wait(forDuration: 0.5)
//        self.scene?.run(SKAction.sequence([actionRed,actionBack]), completion: { () -> Void in
//            self.removeAllChildren()
//            self.clockwise = false
//            self.dots = 0
//            self.level += 1
//            if (self.level % 2 == 0) {
//                self.rotationSpeed += 5
//            }
//            self.layoutGame()
//            self.gameDelegate?.gameFinished()
//        })
//
//
//
//    }
//
//    func gameOver() {
//        isUserInteractionEnabled = false
//        needle.removeFromParent()
//        currentScoreLabel.text = "Failure!"
//        notification.notificationOccurred(.error)
//        let actionRed = SKAction.colorize(with: UIColor(red: 149.0/255.0, green: 165.0/255.0, blue: 166.0/255.0, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.25)
//        let actionBack = SKAction.wait(forDuration: 0.5)
//        self.scene?.run(SKAction.sequence([actionRed,actionBack]), completion: { () -> Void in
//            self.removeAllChildren()
//            self.clockwise = false
//            self.dots = 0
//            self.layoutGame()
//            self.gameDelegate?.gameFinished()
//        })
//
//
//
//    }
//
//    override func update(_ currentTime: CFTimeInterval) {
//        /* Called before each frame is rendered */
//        if started {
//            if needle.intersects(dot) {
//                touches = true
//            } else {
//                if touches == true {
//                    if !needle.intersects(dot) {
//                        started = false
//                        touches = false
//                        gameOver()
//                    }
//                }
//            }
//        }
//
//    }
//}
