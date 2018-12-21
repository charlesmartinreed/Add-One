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
    var seconds: Int = 2
    
    var resultsView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK:- Timer setup
        
        //MARK:- MBProgressHUD setup
        //show thumbs up for correct answer, thumbs down for incorrect
        hud = MBProgressHUD(view: self.view)
        if hud != nil {
            self.view.addSubview(hud!)
        }
        
        startNewRound()

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
        startNewTimer()
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
    
    func startNewTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleGameTimer), userInfo: nil, repeats: true)
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
                seconds = 60
                
                //when the timer is 0, show the user the results and offer option to start new round
                showResults()
            }
        }
        
        
    }
    
    //MARK:- End of round game logic
    func showResults() {
        
        inputField.isHidden = true
        resultsView = UIView()
        resultsView.translatesAutoresizingMaskIntoConstraints = false
        
        let scoreLabel = UILabel()
        scoreLabel.text = "You earned \(score) points! Play again?"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 24)
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        scoreLabel.numberOfLines = 0
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let continueButton = UIButton()
        continueButton.backgroundColor = .blue
        continueButton.layer.cornerRadius = 12
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "HVD_Comic_Serif_Pro", size: 18)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        let quitButton = UIButton()
        quitButton.backgroundColor = .blue
        quitButton.layer.cornerRadius = 12
        quitButton.setTitle("Quit", for: .normal)
        quitButton.setTitleColor(.white, for: .normal)
        quitButton.titleLabel?.font = UIFont(name: "HVD_Comic_Serif_Pro", size: 18)
        quitButton.translatesAutoresizingMaskIntoConstraints = false
        
        //add targets for buttons
        continueButton.addTarget(self, action: #selector(startNewRound), for: .touchUpInside)
        quitButton.addTarget(self, action: #selector(endGame), for: .touchUpInside)
        
        view.addSubview(resultsView)
        resultsView.addSubview(scoreLabel)
        resultsView.addSubview(continueButton)
        resultsView.addSubview(quitButton)
        
        let resultsViewConstraints = [
            resultsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            resultsView.heightAnchor.constraint(equalToConstant: 200),
            resultsView.widthAnchor.constraint(equalToConstant: 400)
        ]
        
        let scoreLabelConstraints = [
            scoreLabel.leadingAnchor.constraint(equalTo: resultsView.leadingAnchor, constant: 8),
            scoreLabel.trailingAnchor.constraint(equalTo: resultsView.trailingAnchor, constant: -8),
            scoreLabel.centerXAnchor.constraint(equalTo: resultsView.centerXAnchor)
        ]
        
        let continueButtonConstraints = [
            continueButton.bottomAnchor.constraint(equalTo: quitButton.topAnchor, constant: -8),
            continueButton.leadingAnchor.constraint(equalTo: resultsView.leadingAnchor),
            continueButton.trailingAnchor.constraint(equalTo: resultsView.trailingAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let quitButtonConstraints = [
            quitButton.leadingAnchor.constraint(equalTo: resultsView.leadingAnchor),
            quitButton.trailingAnchor.constraint(equalTo: resultsView.trailingAnchor),
            quitButton.bottomAnchor.constraint(equalTo: resultsView.bottomAnchor),
            quitButton.heightAnchor.constraint(equalToConstant: 50),
            quitButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let constraints = [resultsViewConstraints, scoreLabelConstraints, continueButtonConstraints, quitButtonConstraints]
        for constraint in constraints {
            NSLayoutConstraint.activate(constraint)
        }
        
    }
    
    @objc func startNewRound() {
        score = 0
        inputField.isHidden = false
        
        //TODO: add logic for saving best score to NSUserDefaults here
        
        removeResultsView()
        setRandomNumberLabel()
        updateScoreLabel()
        //startNewTimer()
        
        //respond to user input
        inputField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    @objc func endGame() {
        //of course you'd never force close an app like this, you'd let the user do it. But I anted to see how it was done and this is what StackOverflow suggested
        
        //TODO: add logic for saving best score to NSUserDefaults here
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
                exit(0)
            })
        }
    }
    
    func removeResultsView() {
        resultsView.removeFromSuperview()
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
