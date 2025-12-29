//
//  DataInit.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 8/17/25.
//

import Foundation
import WatchKit

class DataManagerService: ObservableObject {
    @Published var parks: [Park] = []
    
    init() {
        // Don't block app launch
        DispatchQueue.global(qos: .userInitiated).async {
            var loadedParks: [Park] = self.loadJsonFile("parks.json") ?? []
            let loadedParkingLocations: [ParkingLocation] = self.loadJsonFile("parking.json") ?? []
            
            // Manually link parking locations to each park
            let parkingMap = Dictionary(uniqueKeysWithValues: loadedParkingLocations.map { ($0.id, $0) })
            for index in loadedParks.indices {
                let parkName = loadedParks[index].name
                
                // Use switch to assign the correct parking lot
                switch parkName {
                case "Universal Studios Florida", "Islands of Adventure", "Volcano Bay":
                    loadedParks[index].parkingLot = parkingMap["citywalk"]
                    
                case "Epic Universe":
                    loadedParks[index].parkingLot = parkingMap["epic"]
                    
                case "Universal Studios Hollywood": // Added based on your JSON
                    loadedParks[index].parkingLot = parkingMap["hollywood"]
                    
                default:
                    break // Do nothing, it remains nil
                }
            }
            
            // thread to update our @Published properties.
            DispatchQueue.main.async {
                self.parks = loadedParks
            }
        }
    }
    
    func loadJsonFile<T: Decodable>(_ filename: String) -> T? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Error: Could not find \(filename) in the bundle.")
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("Error: Could not load data from \(filename).")
            return nil
        }
        
        // This works for our JSON files since the keys in the JSON match the property names
        // in the structs
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            // Print a detailed error if decoding fails
            print("Error: Failed to decode \(filename).")
            print(error)
            return nil
        }
    }
}

extension ParkingLocation {
    static var previewData: [ParkingLocation] {
        let url = Bundle.main.url(forResource: "parking.json", withExtension: nil)!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode([ParkingLocation].self, from: data)
    }
}
