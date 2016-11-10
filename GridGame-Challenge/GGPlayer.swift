//
//  GGPlayer.swift
//  GridGame-Challenge
//
//  Created by Gianni Matera on 11/9/16.
//  Copyright © 2016 Gianni Matera. All rights reserved.
//

import Foundation

enum GGPlayerColor {
    case Blue, Red
}

class GGPlayer {
    
    // MARK: Properties
    var score:UInt = 0
    var color:GGPlayerColor!
    var positions:[(Int,Int)] = [] // Used as stack
    var finished:Bool = false
    
    // MARK: Initializers
    required init(color: GGPlayerColor, position:(Int,Int)) {
        self.color = color
        self.positions.insert(position, at: 0)
    }
    
    func setInitialPosition(_ position: (Int,Int)) {
        self.positions.removeAll()
        self.positions.append(position)
    }
}
