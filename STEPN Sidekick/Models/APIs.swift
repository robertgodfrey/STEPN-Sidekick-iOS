//
//  Prices.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 11/22/22.
//

import Foundation

/*
 --- API call for tokens ---
 https://api.coingecko.com/api/v3/simple/price?ids=stepn%2Csolana%2Cgreen-satoshi-token%2Cbinancecoin%2Cgreen-satoshi-token-bsc%2Cethereum%2Cgreen-satoshi-token-on-eth&vs_currencies=usd
 
 --- Raw Data Example ---
 {
     "ethereum": {
         "usd": 1138.43
     },
     "green-satoshi-token": {
         "usd": 0.0222279
     },
     "binancecoin": {
         "usd": 266.73
     },
     "solana": {
         "usd": 12.48
     },
     "green-satoshi-token-on-eth": {
         "usd": 0.076078
     },
     "green-satoshi-token-bsc": {
         "usd": 0.02586311
     },
     "stepn": {
         "usd": 0.373868
     }
}
*/

struct Coins: Codable {
    let greenSatoshiToken, solana, ethereum, binancecoin, greenSatoshiTokenOnEth, greenSatoshiTokenBsc, stepn: Coin

    enum CodingKeys: String, CodingKey {
        case greenSatoshiToken = "green-satoshi-token"
        case solana, ethereum, binancecoin
        case greenSatoshiTokenOnEth = "green-satoshi-token-on-eth"
        case greenSatoshiTokenBsc = "green-satoshi-token-bsc"
        case stepn
    }
    
    init(greenSatoshiToken: Coin, solana: Coin, ethereum: Coin, binancecoin: Coin, greenSatoshiTokenOnEth: Coin, greenSatoshiTokenBsc: Coin, stepn: Coin) {
        self.greenSatoshiToken = greenSatoshiToken
        self.solana = solana
        self.ethereum = ethereum
        self.binancecoin = binancecoin
        self.greenSatoshiTokenOnEth = greenSatoshiTokenOnEth
        self.greenSatoshiTokenBsc = greenSatoshiTokenBsc
        self.stepn = stepn
    }
}

struct Coin: Codable {
    let usd: Double
    
    init(usd: Double) {
        self.usd = 0
    }
}


/*
 --- API call for gems ---
 BASE URL:   "https://apilb.stepn.com/"
 add:        "run/orderlist?saleId=1&order=2001&chain={chainNum}&refresh=true&page=0&otd=&type=501&gType=3&quality=&level={gemLevel}&bread=0"

 chainNums: SOL: 103
            BSC: 104
            ETH: 101
 gemLevels: 1:  2010
            2:  3010
            3:  4010
 
 EXAMPLE: BSC level 2 gem price: https://apilb.stepn.com/run/orderlist?saleId=1&order=2001&chain=104&refresh=true&page=0&otd=&type=501&gType=3&quality=&level=3010&bread=0
 
 {
    "code":0,
    "data":[
        {
            "id":304564045,
            "otd":45245732262,
            "time":0,
            "propID":45245732262,
            "img":"gem_comfortabe_1.png",
            "dataID":100031,
            "sellPrice":309,
            "hp":0,
            "level":1,
            "quality":1,
            "mint":0,
            "addRatio":50,
            "lifeRatio":10000,
            "v1":3,
            "v2":20,
            "speedMax":0,
            "speedMin":0
        },
        { ..... }
    ]
 }
*/


struct GemPrices: Codable {
    let data: [NestedGemPrice]
    
    init(data: [NestedGemPrice]) {
        self.data = data
    }
}

struct NestedGemPrice: Codable {
    let sellPrice: Int
    
    init(sellPrice: Int) {
        self.sellPrice = sellPrice
    }
}

/*
 --- API call for GMT numbers ---
 http://api.stepnsidekick.com/gmt/numbers
 {
    "a": 1.0,
    "b": 2.0,
    "c": 3.0
 }
 */
struct GmtMagicNumbers: Codable {
    let a: Double
    let b: Double
    let c: Double
    
    init(a: Double, b: Double, c: Double) {
        self.a = a
        self.b = b
        self.c = c
    }
}

/*
 --- API call for MB predictions ---
 http://api.stepnsidekick.com/mb/{energy}
 {
    "luck": {"1": 0, "11": 0, "21": 1, ... },
    "probabilities": [[0,0,0,0,0,0,0,0,0,0], ...]
 }
 */
struct MbPredictions: Codable {
    let probabilities: [[Int]]
    let luck: [String: Int]
    
    init(probabilities: [[Int]], luck: [String: Int]) {
        self.probabilities = probabilities
        self.luck = luck
    }
}
