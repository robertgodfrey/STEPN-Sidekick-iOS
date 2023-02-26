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
        self.usd = 0.0
    }
}


/*
 --- API call for gems ---
 http://stepnsidekick.com/gems.json
 
 --- Raw Data Example ---
 {
    "1":231,
    "2":2740,
    "3":15050
 }
 */


struct Gems: Codable {
    let one, two, three: Int

    enum CodingKeys: String, CodingKey {
        case one = "1"
        case two = "2"
        case three = "3"
    }
    
    init(one: Int, two: Int, three: Int) {
        self.one = one
        self.two = two
        self.three = three
    }
}
