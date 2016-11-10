//
//  GGMainViewController.swift
//  GridGame-Challenge
//
//  Created by Gianni Matera on 11/9/16.
//  Copyright © 2016 Gianni Matera. All rights reserved.
//

import UIKit

protocol GGGameDelegate {
    func prizeChosen(position:(Int,Int))
    func prizeFound(byPlayer: GGPlayer)
    func resetGame()
}

@objc
class GGMainViewController: UIViewController, GGGameDelegate {
    
    // MARKvarutlets
    @IBOutlet weak var dotContainerView: UIView!
    
    // MARK: Properties
    private var timer:Timer?

    // MARK: Outlets
    @IBOutlet weak var redScoreMarkerView: UIView!
    @IBOutlet weak var blueScoreMarkerView: UIView!
    @IBOutlet weak var redScoreLabel: UILabel!
    @IBOutlet weak var blueScoreLabel: UILabel!
    
    // MARK: GridDotViews
    @IBOutlet weak var gridDot00: GGGridDot!
    @IBOutlet weak var gridDot01: GGGridDot!
    @IBOutlet weak var gridDot02: GGGridDot!
    @IBOutlet weak var gridDot03: GGGridDot!
    @IBOutlet weak var gridDot04: GGGridDot!
    
    @IBOutlet weak var gridDot10: GGGridDot!
    @IBOutlet weak var gridDot11: GGGridDot!
    @IBOutlet weak var gridDot12: GGGridDot!
    @IBOutlet weak var gridDot13: GGGridDot!
    @IBOutlet weak var gridDot14: GGGridDot!
    
    @IBOutlet weak var gridDot20: GGGridDot!
    @IBOutlet weak var gridDot21: GGGridDot!
    @IBOutlet weak var gridDot22: GGGridDot!
    @IBOutlet weak var gridDot23: GGGridDot!
    @IBOutlet weak var gridDot24: GGGridDot!
    
    @IBOutlet weak var gridDot30: GGGridDot!
    @IBOutlet weak var gridDot31: GGGridDot!
    @IBOutlet weak var gridDot32: GGGridDot!
    @IBOutlet weak var gridDot33: GGGridDot!
    @IBOutlet weak var gridDot34: GGGridDot!
    
    @IBOutlet weak var gridDot40: GGGridDot!
    @IBOutlet weak var gridDot41: GGGridDot!
    @IBOutlet weak var gridDot42: GGGridDot!
    @IBOutlet weak var gridDot43: GGGridDot!
    @IBOutlet weak var gridDot44: GGGridDot!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.redScoreMarkerView.layer.cornerRadius = self.redScoreMarkerView.frame.width / 2.0
        self.blueScoreMarkerView.layer.cornerRadius = self.blueScoreMarkerView.frame.width / 2.0
        
        GGGameManager.shared.dotMatrix = [
            [gridDot00,gridDot01,gridDot02,gridDot03,gridDot04],
            [gridDot10,gridDot11,gridDot12,gridDot13,gridDot14],
            [gridDot20,gridDot21,gridDot22,gridDot23,gridDot24],
            [gridDot30,gridDot31,gridDot32,gridDot33,gridDot34],
            [gridDot40,gridDot41,gridDot42,gridDot43,gridDot44],
        ]
        
        // Squares to Circles
        for (x, column) in GGGameManager.shared.dotMatrix.enumerated() {
            for (y,dot) in column.enumerated() {
                dot.layer.cornerRadius = dot.frame.height / 2.0
                dot.positionInMatrix = (x,y)
                dot.clipsToBounds = true
            }
        }
        
        GGGameManager.shared.delegate = self
        GGGameManager.shared.bluePlayer = GGPlayer(color: .Blue, position: (GGAppConstants.shared.boardLength - 1, 0))
        GGGameManager.shared.redPlayer = GGPlayer(color: .Red, position: (0,GGAppConstants.shared.boardLength - 1))
        GGGameManager.shared.placePrize()
        
        placePlayers()
        startTimer()
    }
    
    // MARK: Game Methods
    private func placePlayers() {
        // Place red player
        let redStart = GGGameManager.shared.dotMatrix[0][GGAppConstants.shared.boardLength - 1]
        redStart.claimedBy = GGGameManager.shared.redPlayer!
        redStart.changeState(state: .Occupied)
        
        // Place blue player
        let blueStart = GGGameManager.shared.dotMatrix[GGAppConstants.shared.boardLength - 1][0]
        blueStart.claimedBy =  GGGameManager.shared.bluePlayer!
        blueStart.changeState(state: .Occupied)
    }
    
    private func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.makeMove), userInfo: nil, repeats: true)
        self.timer?.tolerance = 0.1
    }
    
    func makeMove() {
        GGGameManager.shared.makeMove(forColor: .Red)
        GGGameManager.shared.makeMove(forColor: .Blue)
    }
    
    // MARK: GGGameDelegate Methods
    func resetGame() {
        
        self.timer?.invalidate()
        self.timer = nil
        
        GGGameManager.shared.redPlayer?.finished = false
        GGGameManager.shared.redPlayer?.positions = []
        GGGameManager.shared.bluePlayer?.finished = false
        GGGameManager.shared.bluePlayer?.positions = []
        
        GGGameManager.shared.redPlayer?.setInitialPosition((0,GGAppConstants.shared.boardLength - 1))
        GGGameManager.shared.bluePlayer?.setInitialPosition((GGAppConstants.shared.boardLength - 1, 0))
        
        // Reset GridDot States
        for column in GGGameManager.shared.dotMatrix {
            for dot in column {
                dot.changeState(state: .Open)
            }
        }
        
        placePlayers()
        GGGameManager.shared.placePrize()
        startTimer()
    }
    
    func prizeFound(byPlayer player:GGPlayer) {
        
        player.score += 1
        
        if player.color == .Red {
            self.redScoreLabel.text = String(player.score)
        } else {
            self.blueScoreLabel.text = String(player.score)
        }
        
        resetGame()
    }
    
    func prizeChosen(position: (Int, Int)) {
        let dot = GGGameManager.shared.dotMatrix[position.0][position.1]
        dot.backgroundColor = UIColor.green
    }
}
