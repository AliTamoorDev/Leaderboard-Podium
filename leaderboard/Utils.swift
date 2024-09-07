//
//  Utils.swift
//  leaderboard
//
//  Created by Ali Tamoor on 03/09/2024.
//

import Foundation

class Utils {
    static func date(from string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust this format to match your API's date format
        return dateFormatter.date(from: string)
    }
    
    static var dummytopScorer = TopScorer(date: .now, name: "", score: 0, image: "")
}

enum DateFilter {
    case day
    case month
    case year
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
