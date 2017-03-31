//
//  ViewController.swift
//  StopWatch
//
//  Created by Parth on 3/28/17.
//  Copyright © 2017 Bhoiwala. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var millisecondsLabel: UILabel!
    
    @IBOutlet weak var lapsTableView: UITableView!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var lapResetButton: UIButton!
    
    var seconds = Int()
    var minutes = Int()
    var centiseconds = Int()
    var isClockRunning = false
    var resetButtons = false
    var timer = Timer()
    var lapTimes = [String]()
    
    @IBAction func startBtn(_ sender: UIButton) {
        if(!isClockRunning){
            isClockRunning = true
            timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(incrementCounter), userInfo: nil, repeats: true)
        }else{
            isClockRunning = false
            timer.invalidate()
        }
        refreshAllButtons()
        //print("start is clicked")
    }
    
  

    @IBAction func lapBtn(_ sender: UIButton) {
        if(isClockRunning){
            recordLap()
        }else{
            resetEverything()
        }
        refreshAllButtons()
    }
    
    
    func incrementCounter(){
        centiseconds += 1
        if(centiseconds > 99){
            centiseconds = 0
            seconds += 1
        }
        if(seconds > 59){
            seconds = 0
            minutes += 1
        }
        if(minutes > 59){
            seconds = 0
            minutes = 0
        }
        refreshClock()
    }
    
    func refreshClock(){
        secondsLabel.text = String(format:"%02d", seconds)
        minutesLabel.text = String(format:"%02d", minutes)
        millisecondsLabel.text = String(format:"%02d", centiseconds)
    }
    
    func resetEverything(){
        timer.invalidate()
        resetButtons = true
        isClockRunning = false
        centiseconds = 0
        seconds = 0
        minutes = 0
        refreshClock()
        lapTimes.removeAll()
        lapsTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func recordLap(){
        print("lap recorded")
        let lapTime = String(format:"%02d",minutes) + ":" + String(format:"%02d",seconds) + "." + String(format:"%02d",centiseconds)
        lapTimes.append(lapTime)
        lapsTableView.reloadData()
    }
    
    
    func refreshAllButtons(){
        if(isClockRunning){
            startPauseButton.setTitle("STOP", for: .normal)
            startPauseButton.backgroundColor = UIColor(rgb: 0x666666)
            lapResetButton.setTitle("LAP", for: .normal)
            lapResetButton.backgroundColor = UIColor(rgb: 0x666666)
        }else{
            if(resetButtons){
                resetButtons = false
                startPauseButton.setTitle("START", for: .normal)
                lapResetButton.setTitle("LAP", for: .normal)
            }else{
                startPauseButton.setTitle("RESUME", for: .normal)
                lapResetButton.setTitle("RESET", for: .normal)
            }
            startPauseButton.backgroundColor = UIColor(rgb: 0x333333)
            lapResetButton.backgroundColor = UIColor(rgb: 0x333333)
        }
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return lapTimes.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = lapTimes[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "Courier", size: 22)
        cell.textLabel?.textAlignment = .center
        return cell
    }

    
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

