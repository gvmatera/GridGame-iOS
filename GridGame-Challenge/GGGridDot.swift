//
//  GGGridDot.swift
//  GridGame-Challenge
//
//  Created by Gianni Matera on 11/9/16.
//  Copyright © 2016 Gianni Matera. All rights reserved.
//

import UIKit

enum GGGridDotState {
    case Open, Occupied, Visited, Prize
}

class GGGridDot:UIView {
    
    // MARK: Properties
    var positionInMatrix:(Int,Int) = (0,0)
    var state:GGGridDotState = .Open
    var claimedBy:GGPlayer?
    
    // Mark: State Methods
    func changeState(state:GGGridDotState) {
        
        switch state {
        case .Open:
            self.backgroundColor = UIColor.lightGray
            self.claimedBy = nil
        case .Occupied:
            setColorForPlayer(state: state)
        case .Visited:
            setColorForPlayer(state: state)
        case .Prize:
            self.backgroundColor = UIColor(red:  95.0/255.0, green: 170.0/255.0, blue: 7.0/255.0, alpha: 1.0)
        }
        
        self.state = state
    }
    
    private func setColorForPlayer(state:GGGridDotState) {
        if let claimedBy = self.claimedBy {
            if claimedBy.color == .Blue {
                if state == .Occupied {
                    self.backgroundColor = UIColor(red: 0.0, green: 101.0/255.0, blue: 219.0/255.0, alpha: 1.0)
                }
                else if state == .Visited {
                    self.backgroundColor = UIColor(red: 160.0/255.0, green: 204.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                }
            } else if claimedBy.color == .Red {
                if state == .Occupied {
                    self.backgroundColor = UIColor(red: 238.0/255.0, green: 30.0/255.0, blue: 33.0/255.0, alpha: 1.0)
                }
                else if state == .Visited {
                    self.backgroundColor = UIColor(red: 255.0/255.0, green: 159.0/255.0, blue: 160.0/255.0, alpha: 1.0)
                }
            }
        }
    }
}

