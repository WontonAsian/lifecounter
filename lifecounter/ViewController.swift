//
//  ViewController.swift
//  lifecounter
//
//  Created by Hoang Nguyen on 4/17/24.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var player1LifeTotalLabel: UILabel!
    @IBOutlet weak var player2LifeTotalLabel: UILabel!
    @IBOutlet weak var loserLabel: UILabel!
    
    // MARK: - Properties
    var player1LifeTotal = 20
    var player2LifeTotal = 20

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loserLabel.isHidden = true  // Initially hide the loser label
        updateLifeTotalLabels()
    }
    
    // MARK: - IBActions for Player 1 Life Total Adjustments
    @IBAction func player1Increase(_ sender: UIButton) {
        player1LifeTotal = changeLifeTotal(player1LifeTotal, by: 1)
    }
    
    @IBAction func player1Decrease(_ sender: UIButton) {
        player1LifeTotal = changeLifeTotal(player1LifeTotal, by: -1)
    }
    
    @IBAction func player1IncreaseFive(_ sender: UIButton) {
        player1LifeTotal = changeLifeTotal(player1LifeTotal, by: 5)
    }
    
    @IBAction func player1DecreaseFive(_ sender: UIButton) {
        player1LifeTotal = changeLifeTotal(player1LifeTotal, by: -5)
    }
    
    // MARK: - IBActions for Player 2 Life Total Adjustments
    @IBAction func player2Increase(_ sender: UIButton) {
        player2LifeTotal = changeLifeTotal(player2LifeTotal, by: 1)
    }
    
    @IBAction func player2Decrease(_ sender: UIButton) {
        player2LifeTotal = changeLifeTotal(player2LifeTotal, by: -1)
    }
    
    @IBAction func player2IncreaseFive(_ sender: UIButton) {
        player2LifeTotal = changeLifeTotal(player2LifeTotal, by: 5)
    }
    
    @IBAction func player2DecreaseFive(_ sender: UIButton) {
        player2LifeTotal = changeLifeTotal(player2LifeTotal, by: -5)
    }

    func changeLifeTotal(_ lifeTotal: Int, by amount: Int) -> Int {
        let newLifeTotal = max(0, min(lifeTotal + amount, 999)) // Ensure the life total is within 0-999
        updateLifeTotalLabels()
        checkForLoser()
        return newLifeTotal
    }
    
    func updateLifeTotalLabels() {
        player1LifeTotalLabel.text = "\(player1LifeTotal)"
        player2LifeTotalLabel.text = "\(player2LifeTotal)"
    }
    
    // MARK: - Check for Loser
    func checkForLoser() {
        if player1LifeTotal <= 0 {
            loserLabel.text = "Player 1 LOSES!"
            loserLabel.isHidden = false
        } else if player2LifeTotal <= 0 {
            loserLabel.text = "Player 2 LOSES!"
            loserLabel.isHidden = false
        } else {
            loserLabel.isHidden = true // No loser yet
        }
    }
}

