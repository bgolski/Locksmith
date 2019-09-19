//
//  StatsViewController.swift
//  Locksmith
//
//  Created by Bradley Golski on 1/22/19.
//  Copyright © 2019 Bradley Golski. All rights reserved.
//

import UIKit


class StatsViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    var numberOfGames = 3
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(newUser!.retrieveLastNGames(n: numberOfGames).count, numberOfGames)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell" + String(indexPath.item))
        cell.textLabel?.text = String(describing: newUser!.retrieveLastNGames(n: numberOfGames)[indexPath.item]["score"]!)
        return cell
    }
    
    var device = DeviceInfo()
    var newUser: UserInfo?
    var defaults = UserDefaults()
    
    @IBOutlet weak var statsLabel: UILabel!
    
    @IBAction func backButtonHandler(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet weak var dotsClearedLabel: UILabel!
    
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    
    @IBOutlet weak var averagePlayedLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pastGamesLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newUser = UserInfo()
        
        highScoreLabel.text = "High Score: \(String(describing: UserInfo.highScore ?? 0))"
        highScoreLabel.font = UIFont(name: "Baskerville", size: (device.retrieveStatsFontSize()/2))
        
        dotsClearedLabel.text = "Dots Cleared: \(String(describing: UserInfo.dotsCleared ?? 0))"
        dotsClearedLabel.font = UIFont(name: "Baskerville", size: (device.retrieveStatsFontSize()/2))
        
        
        gamesPlayedLabel.text = "Games Played: \(String(describing: UserInfo.gamesPlayed ?? 0))"
        gamesPlayedLabel.font = UIFont(name: "Baskerville", size: (device.retrieveStatsFontSize()/2))
        
        averagePlayedLabel.text = "Average Score: \(String(describing: newUser!.retrieveAverageScore()/2))"
        averagePlayedLabel.font = UIFont(name: "Baskerville", size: (device.retrieveStatsFontSize()/2))
        
        pastGamesLabel.font = UIFont(name: "Baskerville", size: (device.retrieveStatsFontSize()/2))
        
        scrollView.isScrollEnabled = true

        for (index,game) in newUser!.retrieveLastNGames(n:3).reversed().enumerated() {
            let height:CGFloat = 20
            let gameView = UIView(frame: CGRect(x:0,y:CGFloat(index) * height, width:scrollView.bounds.width,height:20))
            
            let scoreLabel = UILabel(frame: CGRect(x:0,y:0,width: 20, height: height))
            scoreLabel.text = String(game["score"]!)
            scoreLabel.font = UIFont(name: "Baskerville", size: 20.0)
            scoreLabel.textColor = UIColor.white
            scoreLabel.textAlignment = .left
            gameView.addSubview(scoreLabel)
            
            let timeLabelWidth:CGFloat = 190
            let timeLabel = UILabel(frame: CGRect(x:gameView.bounds.width - timeLabelWidth,y:0,width: timeLabelWidth, height: height))
            
            let date = Date(timeIntervalSince1970: TimeInterval(game["time"]!))
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
            timeLabel.text = dateFormatter.string(from: date)
            timeLabel.font = UIFont(name: "Baskerville", size: 20.0)
            timeLabel.textAlignment = .right
            timeLabel.textColor = UIColor.white
            gameView.addSubview(timeLabel)
            
            
            scrollView.addSubview(gameView)
        }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
}
