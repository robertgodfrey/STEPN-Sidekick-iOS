//
//  ShoeImage.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 3/18/23.
//

import Foundation


@MainActor class ShoeImages: ObservableObject {
    @Published private(set) var imageUrls: [String]
    let saveKey = "ShoeImages"

    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([String].self, from: data) {
                imageUrls = decoded
                return
            }
        }

        // no saved data
        imageUrls = ["", "", "", "", "", ""]
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(imageUrls) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    func update(url: String, i: Int) {
        imageUrls[i] = url
        save()
    }
    
    func getUrl(_ i: Int) -> String {
        return imageUrls[i]
    }
    
}
