//
//  GGGameManager.swift
//  GridGame-Challenge
//
//  Created by Gianni Matera on 11/9/16.
//  Copyright © 2016 Gianni Matera. All rights reserved.
//

import Foundation
import UIKit

enum GGPlayerMove {
    case Up, Down, Left, Right
    static let allValues = [Up, Down, Left, Right]
}

class GGGameManager {
    
    // MARK: Singleton Manager
    static let shared = GGGameManager()
    
    // MARK: Properties
    var delegate:GGGameDelegate?
    
    var dotMatrix:[[GGGridDot]] = Array(repeating: Array(repeating: GGGridDot(), count: GGAppConstants.shared.boardLength), count: GGAppConstants.shared.boardLength)
    var redPlayer:GGPlayer?
    var bluePlayer:GGPlayer?
    private var prize:(Int,Int) = (0,0)
    
    // MARK: Game Methods
    func makeMove(forColor:GGPlayerColor) {
        
        if checkFinished() == true {
            print("Finished")
            self.delegate?.resetGame()
        }
        
        var currentPlayer:GGPlayer!
        
        switch forColor {
        case .Red:
            currentPlayer = redPlayer
        case .Blue:
            currentPlayer = bluePlayer
        }
        
        if let currentPosition = currentPlayer.positions.first {
            let moveResult = getNewPosition(currentPosition: currentPosition, player: currentPlayer)
            if moveResult != nil {
                if checkPrize(position: moveResult!.position) == false {
                    let currentDot = dotMatrix[currentPosition.0][currentPosition.1]
                    currentDot.changeState(state: .Visited)
                    
                    if moveResult?.isBacktrack == true {
                        currentDot.changeState(state: .Open)
                        currentPlayer.positions.removeFirst()
                        currentPlayer.finished = true
                    }
                    
                    currentPlayer.positions.insert(moveResult!.position, at: 0)
                    
                    let newDot = dotMatrix[moveResult!.position.0][moveResult!.position.1]
                    newDot.claimedBy = currentPlayer
                    newDot.changeState(state: .Occupied)
                } else {
                    self.delegate?.prizeFound(byPlayer: currentPlayer)
                }
            }
        }
    }

    func placePrize() {
    
        let x = getRandomNumberInRange(GGAppConstants.shared.boardLength)
        let y = getRandomNumberInRange(GGAppConstants.shared.boardLength)
        
        let prize = (x, y)
            
        if prize != (0, GGAppConstants.shared.boardLength - 1) && prize != (GGAppConstants.shared.boardLength - 1, 0) {
            self.prize = prize
            self.delegate?.prizeChosen(position: prize)
        } else {
            placePrize()
        }
    }
    
    private func getNewPosition(currentPosition:(Int,Int), player: GGPlayer) -> GGMoveResult? {
        
        let currentPosition = player.positions.first!
        
        var moveQueue = GGPlayerMove.allValues
        moveQueue.shuffle()
        
        while moveQueue.count > 0 {
            switch moveQueue.first! {
            case .Up:
                if currentPosition.1 > 0 {
                    let dot = dotMatrix[currentPosition.0][currentPosition.1 - 1]
                    if dot.state == .Open {
                        return GGMoveResult(position: (currentPosition.0, currentPosition.1 - 1), isBacktrack: false)
                    }
                }
            case .Down:
                if currentPosition.1 < dotMatrix.count - 1 {
                    let dot = dotMatrix[currentPosition.0][currentPosition.1 + 1]
                    if dot.state == .Open  {
                        return GGMoveResult(position:  (currentPosition.0, currentPosition.1 + 1), isBacktrack: false)
                    }
                }
            case .Left:
                if currentPosition.0 > 0 {
                    let dot = dotMatrix[currentPosition.0 - 1][currentPosition.1]
                    if dot.state == .Open {
                        return GGMoveResult(position: (currentPosition.0 - 1, currentPosition.1), isBacktrack: false)
                    }
                }
            case .Right:
                if currentPosition.0 < dotMatrix.count - 1 {
                    let dot = dotMatrix[currentPosition.0 + 1][currentPosition.1]
                    if dot.state == .Open {
                        return GGMoveResult(position:  (currentPosition.0 + 1, currentPosition.1), isBacktrack: false)
                    }
                }
            }
            
            moveQueue.removeFirst()
        }
        
        if let oP = player.positions[safe: 1] {
            return GGMoveResult(position: oP, isBacktrack: true)
        }
        
        return nil
    }
    
    private func getRandomNumberInRange(_ x:Int) -> Int {
        return Int(arc4random_uniform(UInt32(x)))
    }
    
    private func checkPrize(position:(Int,Int)) -> Bool {
        return position == self.prize
    }
    
    private func checkFinished() -> Bool {
        return self.redPlayer?.finished == true && self.bluePlayer?.finished == true
    }
}

struct GGMoveResult {
    let position:(Int,Int)!
    let isBacktrack:Bool!
    
    init(position:(Int,Int), isBacktrack:Bool) {
        self.position = position
        self.isBacktrack = isBacktrack
    }
}

extension Collection {
    subscript (safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}

extension MutableCollection where Indices.Iterator.Element == Index {
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (unshuffledCount, firstUnshuffled) in zip(stride(from: c, to: 1, by: -1), indices) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
