//
//  Locker.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 12/21/25.
//

import Foundation

struct Locker: Codable, Identifiable, Hashable {
    var id: String { name }
    let name: String
    let location: Location
    let sections: String
    let lockers: Int
    
    var sectionList: [String] {
        // 1. Try to treat it as a number (e.g., "4")
        if let count = Int(sections) {
            return (1...count).map { "\($0)" }
        }
        
        // 2. Try to treat it as an Alphabetical end-point (e.g., "D")
        if let endChar = sections.uppercased().first, endChar.isLetter {
            let startChar: Unicode.Scalar = "A"
            let endScalar = endChar.unicodeScalars.first!
            
            // Create a range from 'A' to whatever character is in the JSON
            let range = startChar.value...endScalar.value
            return range.compactMap { Unicode.Scalar($0) }.map { String($0) }
        }
        
        // 3. Fallback: Just return the string itself
        return [sections]
    }
}
