//
//  OptimizerShoe.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 9/30/22.
//

import Foundation

class OptimizerShoe: Codable {
    
    var shoeRarity: Int
    var shoeType: Int
    
    var shoeName: String
    var energy: String
    var shoeLevel: Double
    var pointsAvailable: Int

    var baseEffString: String
    var baseLuckString: String
    var baseComfString: String
    var baseResString: String
    var addedEff: Int
    var addedLuck: Int
    var addedComf: Int
    var addedRes: Int
    var gemEff: Double
    var gemLuck: Double
    var gemComf: Double
    var gemRes: Double
    
    var gems: [Gem]
    
    init(shoeRarity: Int, shoeType: Int, shoeName: String, energy: String, shoeLevel: Double, pointsAvailable: Int, baseEffString: String,
         baseLuckString: String, baseComfString: String, baseResString: String, addedEff: Int, addedLuck: Int, addedComf: Int, addedRes: Int,
         gemEff: Double, gemLuck: Double, gemComf: Double, gemRes: Double, gems: [Gem]) {
        
        self.shoeRarity = shoeRarity
        self.shoeType = shoeType
        self.shoeName = shoeName
        self.energy = energy
        self.shoeLevel = shoeLevel
        self.pointsAvailable = pointsAvailable
        
        self.baseEffString = baseEffString
        self.baseLuckString = baseLuckString
        self.baseComfString = baseComfString
        self.baseResString = baseResString
        self.addedEff = addedEff
        self.addedLuck = addedLuck
        self.addedComf = addedComf
        self.addedRes = addedRes
        self.gemEff = gemEff
        self.gemLuck = gemLuck
        self.gemComf = gemComf
        self.gemRes = gemRes
        self.gems = gems
    }
}

@MainActor class OptimizerShoes: ObservableObject {
    @Published private(set) var shoes: [OptimizerShoe]
    let saveKey = "SavedData"

    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([OptimizerShoe].self, from: data) {
                shoes = decoded
                return
            }
        }

        // no saved data!
        shoes = [modelShoe, modelShoe, modelShoe, modelShoe, modelShoe, modelShoe]
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(shoes) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    func update(shoe: OptimizerShoe, i: Int) {
        shoes[i - 1] = shoe
        save()
    }
    
    func getShoe(_ i: Int) -> OptimizerShoe {
        return shoes[i]
    }
    
    let modelShoe: OptimizerShoe = OptimizerShoe(
        shoeRarity: common,
        shoeType: walker,
        shoeName: "",
        energy: "",
        shoeLevel: 1,
        pointsAvailable: 0,
        baseEffString: "",
        baseLuckString: "",
        baseComfString: "",
        baseResString: "",
        addedEff: 0,
        addedLuck: 0,
        addedComf: 0,
        addedRes: 0,
        gemEff: 0,
        gemLuck: 0,
        gemComf: 0,
        gemRes: 0,
        gems: []
        )
}
