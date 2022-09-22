//
//  Shoe.swift
//  STEPN Sidekick
//
//  Shoe struct for iterating through the different types of shoes on the main menu and saving
//  custom speed values.
//
//  Last updated 22 Sep 22
//

import Foundation

struct Shoe {
    private let title: String
    private let imageResource: String
    private let footResource: String
    private let minSpeed: String
    private let maxSpeed: String
    
    init(title: String, imageResource: String, footResource: String, minSpeed: String, maxSpeed: String) {
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
    
    func getMinSpeed() -> String {
        return minSpeed
    }
    
    func getMaxSpeed() -> String {
        return maxSpeed
    }
}
