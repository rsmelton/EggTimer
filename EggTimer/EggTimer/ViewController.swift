//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let eggTimes = ["Soft": 3, "Medium": 4, "Hard": 5]
    var secondsRemaining = 0
    var timer = Timer()
    var alarm: AVAudioPlayer?
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var titleView: UILabel!
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        progressBar.progress = 0.0
        self.progressBar.progressTintColor = UIColor.systemYellow
        
        // Invalidate the timer first so we don't stack timers
        // every time we click one of the button options.
        timer.invalidate()
        
        // Checks to see if the alarm is currently playing
        // and if it is we want to stop it and reset it back
        // to current time as 0 since we clicked another egg
        if (alarm?.isPlaying != nil) {
            alarm?.pause()
            alarm?.currentTime = 0
        }
        
        // All the ! does is tell the CPU that we know for sure
        // the thing we are giving to the variable is not nil.
        // In doing this we know our hardness variable will get a
        // String since sender.currentTitle is a String? (string optional)
        let hardness = sender.currentTitle!
        
        // We now set the title to show which egg we are currently timing for.
        self.titleView.text = "Currently timing \(hardness) boiled egg(s)..."
        
        // Something similar happens here when we try and grab the
        // value from a key in the dictionary. You have to be careful
        // when grabbing the value in this case the integer from the key
        // cause we don't know if we will find a value with complete
        // certainty depending on if a valid string was given to hardness
        // or not. So we again apply the ! in this case since we know for
        // sure that we will provide a valid string.
        // print(eggTimes[hardness]!)
        secondsRemaining = eggTimes[hardness]!
        
        // Math so we can see the progress bar change a certain percent per second.
        let percentagePerSecond = Float((100.0 / Float(secondsRemaining)) / 100.0)
        print("Percentage Per Second: \(percentagePerSecond)")
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.secondsRemaining > 0 {
                print ("\(self.secondsRemaining) seconds")
                self.secondsRemaining  = self.secondsRemaining - 1
                self.progressBar.progress = self.progressBar.progress + percentagePerSecond
                } else {
                    self.titleView.text = "Your eggs are done!"
                    self.progressBar.progress = 1.0
                    self.progressBar.progressTintColor = UIColor.systemGreen
                    self.playSound()
                    self.timer.invalidate()
                }
            }
        
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "I_Love_Egg", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            alarm = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let alarm = alarm else { return }

            alarm.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
