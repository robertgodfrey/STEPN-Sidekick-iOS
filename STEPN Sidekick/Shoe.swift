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
    private let imageSource: Int
    private let numFeet: Int
    private var minSpeed: Float
    private var maxSpeed: Float
    
    init(title: String, imageSource: Int, numFeet: Int, minSpeed: Float, maxSpeed: Float) {
        self.title = title
        self.imageSource = imageSource
        self.numFeet = numFeet
        self.minSpeed = minSpeed
        self.maxSpeed = maxSpeed
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getImageSource() -> Int {
        return imageSource
    }
        
    func getNumFeet() -> Int {
        return numFeet
    }
    
    func getMinSpeed() -> Float {
        return minSpeed
    }
    
    mutating func setMinSpeed(_ minSpeed: Float) {
        self.minSpeed = minSpeed
    }
    
    func getMaxSpeed() -> Float {
        return maxSpeed
    }
    
    mutating func setMaxSpeed(_ maxSpeed: Float) {
        self.maxSpeed = maxSpeed
    }
}
