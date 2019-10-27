//
//  ViewController.swift
//  SliderGame
//
//  Created by Shakutara on 10/22/19.
//  Copyright © 2019 Shakutara. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController, CAAnimationDelegate {
    
    //MARK: Initialization
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var player1PointLabel: UILabel!
    @IBOutlet weak var player2PointLabel: UILabel!
    @IBOutlet weak var randomNumberLabel: UILabel!
    @IBOutlet weak var randomButton: UIImageView!
    @IBOutlet weak var player1Dices: UIImageView!
    @IBOutlet weak var player2Dices: UIImageView!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var numberSlider: UISlider!
    
    //MARK: Variables
    private var currentRandomNumber: Int? = nil
    private var currentPlayer1Turn: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AF.request("https://api.myjson.com/bins/i9h5k", method: .get).validate().response { (response) in
            do {
                guard let data = response.data else {
                    self.showAlert(title: "", message: "No Connection")
                    return
                }
                
                let res = try JSONDecoder().decode(Array<PlayerResponse>.self, from: data)
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        if res.count != 2 {
                            return
                        }
                        
                        self.player1Label.text = res[0].player_name
                        self.player1PointLabel.text = String(res[0].player_point)
                        
                        self.player2Label.text = res[1].player_name
                        self.player2PointLabel.text = String(res[1].player_point)
                    }
                }
            } catch let error {
                print(error)
            }
            debugPrint(response)
        }
        
        // set click event to randomButton
        let dicesClick = UITapGestureRecognizer(target: self, action: Selector(("dicesClick")))
        dicesClick.numberOfTapsRequired = 1
        randomButton.isUserInteractionEnabled = true
        randomButton.addGestureRecognizer(dicesClick)
        
        // set click event to historyLabel
        let historyLabelClick = UITapGestureRecognizer(target: self, action: Selector(("historyLabelClick")))
        historyLabelClick.numberOfTapsRequired = 1
        historyLabel.isUserInteractionEnabled = true
        historyLabel.addGestureRecognizer(historyLabelClick)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let randomNumber = Int.random(in: 0...100)
        randomNumberLabel.text = String(randomNumber)
        self.currentRandomNumber = randomNumber
    }
    
    //MARK: Private Methods
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    private func increasePoint(playerTag: Int) {
        if currentPlayer1Turn == true {
            let point: Int = player1PointLabel.text != nil ? Int(player1PointLabel.text!)! : 0
            player1PointLabel.text = "\(point + 1)"
        } else {
            let point: Int = player2PointLabel.text != nil ? Int(player2PointLabel.text!)! : 0
            player2PointLabel.text = "\(point + 1)"
        }
        showAlert(title: "Congratulation", message: "You're right")
    }
    private func resetToNextTurn() {
        numberSlider.value = 50.0
        randomNumberLabel.text = "Ready?"
        currentRandomNumber = nil
        
        if currentPlayer1Turn == true {
            player1Dices.isHidden = true
            player2Dices.isHidden = false
        } else {
            player1Dices.isHidden = false
            player2Dices.isHidden = true
        }
        
        currentPlayer1Turn = !currentPlayer1Turn
    }
    private func shakeView(_ view: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.075
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
        animation.delegate = self
        
        view.layer.add(animation, forKey: "position")
    }
    
    //MARK: Actions
    @objc func dicesClick() {
        if self.currentRandomNumber != nil {
            showAlert(title: "", message: "Let play your turn")
            return
        }
        
        shakeView(randomButton)
    }
    @objc func historyLabelClick() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let historyNewController = storyBoard.instantiateViewController(withIdentifier: "history") as! HistoryViewController
        self.present(historyNewController, animated: true, completion: nil)
    }
    @IBAction func submitButtonClick(_ sender: UIButton) {
        if currentRandomNumber == nil {
            showAlert(title: "", message: "You need to click dices to get new number")
            return
        }
        
        if currentRandomNumber == Int(numberSlider.value) {
            increasePoint(playerTag: 1)
        } else {
            showAlert(title: "Opps...", message: NSLocalizedString("Welcome", comment: ""))
        }
        resetToNextTurn()
    }
}
