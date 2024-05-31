//
//  Secrets.swift
//  STEPN Sidekick
//
//  Created by Rob on 6/1/24.
//

import Foundation

struct Secrets: Codable {
    let APP_LOVIN_SDK_KEY: String
    let MAIN_AD_ID: String
}


func loadJSON(filename: String) -> Secrets? {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
        print("Failed to locate \(filename) in bundle.")
        return nil
    }
    
    do {
        // Load the data from the file
        let data = try Data(contentsOf: url)
        
        // Decode the JSON data into the Swift model
        let decoder = JSONDecoder()
        let secrets = try decoder.decode(Secrets.self, from: data)
        
        return secrets
    } catch {
        print("Failed to load \(filename) from bundle: \(error)")
        return nil
    }
}
