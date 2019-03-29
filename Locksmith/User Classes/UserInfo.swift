//
//  UserInfo.swift
//  Locksmith
//
//  Created by Bradley Golski on 2/22/19.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

//struct Game() {
//    var score: Int
//    var time: Int
//}

class UserInfo {
    let db = Firestore.firestore()
    var deviceType =  ""
    var uuid: String = ""
    var defaults = UserDefaults.standard
    static var highScore: Int?
    static var dotsCleared: intmax_t?
    static var gamesPlayed: intmax_t?
    static var games: [[String: Int]] = []
    init() {
        Auth.auth().signInAnonymously() { (authResult, error) in
            if let error = error {
                print("Failed to instantiate user", error)
                return
            }
             self.uuid = authResult!.user.uid
            let docRef = self.db.collection("users").document("\(self.uuid)")

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    UserInfo.highScore = document.get("highscore") as! intmax_t?
                    UserInfo.dotsCleared = document.get("dotscleared") as! intmax_t?
                    UserInfo.gamesPlayed = document.get("gamesplayed") as! intmax_t?
                    UserInfo.games = document.get("games") as! [[String:Int]]
                    print("Document DOES exist")
                } else {
                    self.defaults = UserDefaults.standard
                    self.db.collection("users").document("\(self.uuid)").setData(
                        [ "uuid": "\(self.uuid)",
                            "device": "\(self.deviceType)",
                            "highscore": UserInfo.highScore ?? 0,
                            "dotscleared": UserInfo.dotsCleared ?? 0,
                            "gamesplayed": UserInfo.gamesPlayed ?? 0,
                            "games": UserInfo.games
                        ])
                    self.defaults.set(0, forKey: "highScore")
                    self.defaults.set(0, forKey: "dotsCleared")
                    self.defaults.set(0, forKey: "gamesPlayed")
                    print("Document does not exist")
                }
            }

            print("Successfully signed in anonymously with uid: \(authResult!.user.uid)")
           
            
            
            self.deviceType = UIDevice.modelName
        }
    }
    
    func retrieveHighScore() -> Int {
        if let highScore = UserInfo.highScore {
            return highScore
        }
        return -1
    }
    
    
    func setHighScore(newHighScore: intmax_t) {
        UserInfo.highScore = newHighScore
        defaults.set(UserInfo.highScore, forKey: "highScore")
    }
    
    func setDotsCleared(newDots: intmax_t) {
        UserInfo.dotsCleared = retrieveDotsCleared() + newDots
        defaults.set(UserInfo.dotsCleared, forKey: "dotsCleared")
    }
    
    func retrieveDotsCleared() -> Int {
        if let dotsCleared = UserInfo.dotsCleared {
            
            print("Dots cleared: \(dotsCleared)")
            return dotsCleared
        }
        return 0
    }
    
    func setGamesPlayed() {
        UserInfo.gamesPlayed = retrieveGamesPlayed() + 1
        defaults.set(UserInfo.gamesPlayed, forKey: "gamesPlayed")
    }
    
    func retrieveGamesPlayed() -> Int {
        if let gamesPlayed = UserInfo.gamesPlayed {
            print("games played: \(gamesPlayed)")
            return gamesPlayed
        }
        return 0
    }
    
    func retrieveGames() -> [[String: Int]] {
        return UserInfo.games
    }
    
    func retrieveLastNGames(n: Int) -> [[String:Int]] {
        var startingIndex:Int
        
        if(UserInfo.games.count < n){
            startingIndex = 0
        }else{
            startingIndex = UserInfo.games.count - n
        }
        
        return Array(UserInfo.games[startingIndex...])
    }
    
    func retrieveAverageScore() -> Double {
        if(retrieveGamesPlayed() != 0) {
        return Double(retrieveDotsCleared() / retrieveGamesPlayed())
        }
        return 0
    }
    
    func updateData(score: Int) {
        let time = Int(Date().timeIntervalSince1970)
        let game = [
            "score": score,
            "time": time
        ]
        UserInfo.games.append(game)
        db.collection("users").document("\(uuid)").updateData(
            [ "uuid": "\(self.uuid)",
                "device": "\(self.deviceType)",
                "highscore": UserInfo.highScore ?? 0,
                "dotscleared": UserInfo.dotsCleared ?? 0,
                "gamesplayed": UserInfo.gamesPlayed ?? 0,
                "games": FieldValue.arrayUnion([game])
            ])
        (defaults.set(Double(retrieveDotsCleared() / retrieveGamesPlayed()), forKey: "averageScore"))
        
    }
}
