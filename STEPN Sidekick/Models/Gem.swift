//
//  Gem.swift
//  STEPN Sidekick
//
//  Gem struct for creating gem object
//
//  Last updated 27 Nov 22
//

import Foundation

struct Gem: Codable {
    private var socketType: Int
    private var socketRarity: Int
    private var mountedGem: Int
    private var socketImageSource: String
    private var gemImageSource: String
    private var basePoints: Double
    
    init(socketType: Int, socketRarity: Int, mountedGem: Int) {
        self.socketType = socketType;
        self.socketRarity = socketRarity;
        self.mountedGem = mountedGem;
        self.socketImageSource = "gem_socket_gray_0"
        self.gemImageSource = "gem_plus"
        self.basePoints = 0
        
        updateSocketResource()
        updateGemResource()
    }
    
    func getSocketType() -> Int {
        return socketType
    }
    
    mutating func setSocketType(socketType: Int) {
        self.socketType = socketType
        updateGemResource()
        updateSocketResource()
    }
    
    func getSocketRarity() -> Int {
        return socketRarity
    }
    
    mutating func setSocketRarity(socketRarity: Int) {
        self.socketRarity = socketRarity
        updateSocketResource();
    }
    
    func getMountedGem() -> Int {
        return mountedGem
    }
    
    mutating func setMountedGem(mountedGem: Int) {
        self.mountedGem = mountedGem
        updateGemResource();
    }
    
    func getSocketImageSource() -> String {
        return socketImageSource
    }
    
    func getGemImageSource() -> String {
        return gemImageSource
    }
    
    func getBasePoints() -> Double {
        return basePoints
    }
    
    mutating func setBasePoints(basePoints: Double) {
        self.basePoints = basePoints
    }
    
    func getGemParams() -> Double {
        var gemParams: Double
        
        switch (mountedGem) {
        case 1:
            gemParams = 2 + floor(0.05 * basePoints * 10.0) / 10.0
        case 2:
            gemParams = 8 + floor(0.7 * basePoints * 10.0) / 10.0
        case 3:
            gemParams = 25 + floor(2.2 * basePoints * 10.0) / 10.0
        case 4:
            gemParams = 72 + floor(6 * basePoints * 10.0) / 10.0
        case 5:
            gemParams = 200 + floor(14 * basePoints * 10.0) / 10.0
        case 6:
            gemParams = 400 + floor(43 * basePoints * 10.0) / 10.0
        default:
            gemParams = 0
        }
        
        return gemParams
    }
    
    func getSocketParams() -> Double {
        var socketParams: Double
        
        switch(socketRarity) {
        case 1:
            socketParams = 1.1
        case 2:
            socketParams = 1.2
        case 3:
            socketParams = 1.3
        case 4:
            socketParams = 1.5
        default:
            socketParams = 1
        }
        
        return socketParams
    }
    
    func getGemParamsString() -> String {
        return "+ " + String(getGemParams())
    }
    
    func getSocketParamsString() -> String {
        return "× " + String(getSocketParams())
    }
    
    func getTotalPoints() -> Double {
        return round(getGemParams() * getSocketParams() * 10) / 10.0
    }
    
    func getTotalPointsString() -> String {
        return "+ " + String(round(getGemParams() * getSocketParams() * 10) / 10.0)
    }

    mutating func updateSocketResource() {
        switch (socketType) {
        case eff:
            switch (socketRarity) {
            case 1:
                self.socketImageSource = "gem_socket_eff_1"
            case 2:
                self.socketImageSource = "gem_socket_eff_2"
            case 3:
                self.socketImageSource = "gem_socket_eff_3"
            case 4:
                self.socketImageSource = "gem_socket_eff_4"
            default:
                self.socketImageSource = "gem_socket_eff_0"
            }
        case luck:
            switch (socketRarity) {
            case 1:
                self.socketImageSource = "gem_socket_luck_1"
            case 2:
                self.socketImageSource = "gem_socket_luck_2"
            case 3:
                self.socketImageSource = "gem_socket_luck_3"
            case 4:
                self.socketImageSource = "gem_socket_luck_4"
            default:
                self.socketImageSource = "gem_socket_luck_0"
            }
        case comf:
            switch (socketRarity) {
            case 1:
                self.socketImageSource = "gem_socket_comf_1"
            case 2:
                self.socketImageSource = "gem_socket_comf_2"
            case 3:
                self.socketImageSource = "gem_socket_comf_3"
            case 4:
                self.socketImageSource = "gem_socket_comf_4"
            default:
                self.socketImageSource = "gem_socket_comf_0"
            }
        case res:
            switch (socketRarity) {
            case 1:
                self.socketImageSource = "gem_socket_res_1"
            case 2:
                self.socketImageSource = "gem_socket_res_2"
            case 3:
                self.socketImageSource = "gem_socket_res_3"
            case 4:
                self.socketImageSource = "gem_socket_res_4"
            default:
                self.socketImageSource = "gem_socket_res_0"
            }
        default:
            switch (socketRarity) {
            case 1:
                self.socketImageSource = "gem_socket_gray_1"
            case 2:
                self.socketImageSource = "gem_socket_gray_2"
            case 3:
                self.socketImageSource = "gem_socket_gray_3"
            case 4:
                self.socketImageSource = "gem_socket_gray_4"
            default:
                self.socketImageSource = "gem_socket_gray_0"
            }
        }
    }
    
    mutating func updateGemResource() {
        switch (socketType) {
        case eff:
            switch (mountedGem) {
            case 1:
                gemImageSource = "gem_eff_level1"
            case 2:
                gemImageSource = "gem_eff_level2"
            case 3:
                gemImageSource = "gem_eff_level3"
            case 4:
                gemImageSource = "gem_eff_level4"
            case 5:
                gemImageSource = "gem_eff_level5"
            case 6:
                gemImageSource = "gem_eff_level6"
            default:
                gemImageSource = "gem_plus"
            }
        case luck:
            switch (mountedGem) {
            case 1:
                gemImageSource = "gem_luck_level1"
            case 2:
                gemImageSource = "gem_luck_level2"
            case 3:
                gemImageSource = "gem_luck_level3"
            case 4:
                gemImageSource = "gem_luck_level4"
            case 5:
                gemImageSource = "gem_luck_level5"
            case 6:
                gemImageSource = "gem_luck_level6"
            default:
                gemImageSource = "gem_plus"
            }
        case comf:
            switch (mountedGem) {
            case 1:
                gemImageSource = "gem_comf_level1"
            case 2:
                gemImageSource = "gem_comf_level2"
            case 3:
                gemImageSource = "gem_comf_level3"
            case 4:
                gemImageSource = "gem_comf_level4"
            case 5:
                gemImageSource = "gem_comf_level5"
            case 6:
                gemImageSource = "gem_comf_level6"
            default:
                gemImageSource = "gem_plus"
            }
        case res:
            switch (mountedGem) {
            case 1:
                gemImageSource = "gem_res_level1"
            case 2:
                gemImageSource = "gem_res_level2"
            case 3:
                gemImageSource = "gem_res_level3"
            case 4:
                gemImageSource = "gem_res_level4"
            case 5:
                gemImageSource = "gem_res_level5"
            case 6:
                gemImageSource = "gem_res_level6"
            default:
                gemImageSource = "gem_plus"
            }
        default:
            gemImageSource = "gem_plus"
        }
    }
    
    // each gem image has different dimensions so need to manually set the padding for each one
    // i think this is easier than going in and editing all the image files so they are the same size ¯\_(ツ)_/¯
    func getTopPadding() -> Float {
        var topPadding: Float
        switch (mountedGem) {
        case 0:
            topPadding = 2
        case 1:
            topPadding = 3
        case 4, 5:
            topPadding = 2
        default:
            topPadding = 0
        }
        
        return topPadding
    }

    func getBottomPadding() -> Float {
        var bottomPadding: Float
        
        switch (mountedGem) {
        case 0:
            bottomPadding = 2
        case 1:
            bottomPadding = 3
        case 3:
            bottomPadding = 1
        default:
            bottomPadding = 0
        }
        
        return bottomPadding
    }
}
