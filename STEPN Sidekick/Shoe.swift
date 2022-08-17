//
//  Shoe.swift
//  STEPN Sidekick
//
//  Shoe struct for iterating through the different types of shoes on the main menu and saving
//  custom speed values.
//
//  Created by Rob Godfrey on 8/8/22.
//

import Foundation

struct Shoe {
    private let title: String
    // V probs don't need this one V
    private let imageResource: String
    private let footResource: String
    private var minSpeed: Double
    private var maxSpeed: Double
    
    init(title: String, imageResource: String, footResource: String, minSpeed: Double, maxSpeed: Double) {
        self.title = title
        self.imageResource = imageResource
        self.footResource = footResource
        self.minSpeed = minSpeed
        self.maxSpeed = maxSpeed
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getImageResource() -> String {
        return imageResource
    }
        
    func getFootResource() -> String {
        return footResource
    }
    
    func getMinSpeed() -> Double {
        return minSpeed
    }
    
    mutating func setMinSpeed(_ minSpeed: Double) {
        self.minSpeed = minSpeed
    }
    
    func getMaxSpeed() -> Double {
        return maxSpeed
    }
    
    mutating func setMaxSpeed(_ maxSpeed: Double) {
        self.maxSpeed = maxSpeed
    }
}
