//
//  UserInfo.swift
//  Locksmith
//
//  Created by Bradley Golski on 2/22/19.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserInfo {
    var ref: DatabaseReference!
    var uuid: String = ""
    var highScore: intmax_t? = -1
//    var dotsCleared: intmax_t!
    init() {
        ref = Database.database().reference()
        Auth.auth().signInAnonymously() { (authResult, error) in
            if let error = error {
                print("Failed to instantiate user", error)
                return
            }
            print("Successfully signed in anonymously with uid")
            self.uuid = authResult!.user.uid
            self.ref.child("\(self.uuid)").child("highscore").observeSingleEvent(of: .value, with: { (snapshot) in
                self.highScore = snapshot.value as? intmax_t
                print(snapshot)
            })
        }
    }
    
    func retrieveHighScore() -> intmax_t{
        if let highScore = self.highScore {
            return highScore
        }
        return -1
    }
    
    
    func setHighScore(newHighScore: intmax_t) {
        highScore = newHighScore
        ref.child("\(uuid)/highscore").setValue(highScore)
    }
}

//    func sendDotsCleared(dots: intmax_t) {
//        var currentDots: intmax_t?
//        ref.child("\(uuid)").child("dotsCleared").observeSingleEvent(of: .value, with: { (snapshot) in
//            currentDots = snapshot.value as? intmax_t
//        })
//        var finalDots = currentDots + dots
//
//    }
