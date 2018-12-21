//
//  MainViewController.swift
//  Add 1
//
//  Created by Charles Martin Reed on 12/20/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit
import MBProgressHUD

class MainViewController: UIViewController {
    
    //MARK:- @IBOutlets
    @IBOutlet weak var numbersLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    
    //MARK:- Properties
    var hud: MBProgressHUD?
    var score: Int = 0
    var timer: Timer?
    var seconds: Int = 60
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:- Timer setup
        
        //MARK:- MBProgressHUD setup
        //show thumbs up for correct answer, thumbs down for incorrect
        hud = MBProgressHUD(view: self.view)
        if hud != nil {
            self.view.addSubview(hud!)
        }
        
        setRandomNumberLabel()
        updateScoreLabel()
        
        print("Loaded view")
        
        //respond to user input
        inputField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    
    
    //MARK:- Game logic
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let inputText = inputField.text else { return }
        guard let numbersText = numbersLabel.text else { return }

        //1. Check whether length of text is at least 4. If not, user is still entering text.
        if inputText.count < 4 {
            return //exit
        }

        //2. Get the values from our numbers label and input field and compare them
        let numbers = Int(numbersText)!
        let input = Int(inputText)!

        //testing purposes only
        print("Comparing: \(numbersText) - \(inputText) == \(input - numbers)")

        if input - numbers == 1111 {
            print("Correct!") //testing purposes only
            showHUDWithAnswer(isRight: true)
            //score += 1
        } else {
            print("Incorrect!") //testing purposes only
            showHUDWithAnswer(isRight: false)
            //score -= 1
        }
    
        //3. Trigger new numbers to start new turn
        setRandomNumberLabel()
        updateScoreLabel()
        
        //NOTE: creates timer only when first answer is given
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleGameTimer), userInfo: nil, repeats: true)
        }
    }
    
    //MARK:- MBProgressHUD helper method
    func showHUDWithAnswer(isRight: Bool) {
        var imageView: UIImageView?
        
        if isRight {
            imageView = UIImageView(image: UIImage(named: "thumbs-up"))
            score += 1
        } else {
            imageView = UIImageView(image: UIImage(named: "thumbs-down"))
            score -= 1
        }
        
        if let imageView = imageView {
            hud?.mode = MBProgressHUDMode.customView
            hud?.customView = imageView
            hud?.show(animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.hud?.hide(animated: true)
            }
        }
    }
    
    //MARK:- Timer handling
    @objc func handleGameTimer() -> Void {
        if seconds > 0 && seconds <= 60 {
            seconds -= 1
            updateTimeLabel()
        } else if seconds == 0 {
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    func updateTimeLabel() {
        if(timeLabel != nil)
        {
            let min:Int = (seconds / 60) % 60
            let sec:Int = seconds % 60

            let min_p:String = String(format: "%02d", min)
            let sec_p:String = String(format: "%02d", sec)

            timeLabel!.text = "\(min_p):\(sec_p)"
        }
       
    }

    func updateScoreLabel() {
        scoreLabel.text = "\(score)"
    }

    func setRandomNumberLabel() {
        inputField.text = ""
        numbersLabel.text = generateRandomString()
    }

    func generateRandomString() -> String {
        var result = ""
        for _ in 1...4 {
            let random = Int.random(in: 0...8)
            result += String(random)
        }

        return result
    }

}
