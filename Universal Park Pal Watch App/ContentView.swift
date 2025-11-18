//
//  ContentView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 8/7/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManagerService
    
    var body: some View {
        // A NavigationStack is still useful here to provide
        // the .navigationTitle at the top of the screen.
        NavigationStack {
            List {
                // Loop over each park in your DataManager
                ForEach(dataManager.parks) { park in
                    Section(header: HStack(spacing: 5) {
                        Image(systemName: park.imageName)
                            .font(.title3)
                            .foregroundColor(.white)
                        
                        Text(park.name)
                            .font(.title3)
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                            .padding(.bottom, 3)
                            .foregroundColor(.white)
                        

                    }
                        .padding(.bottom, 3))
                    {
                            
                            VStack(spacing: 0) {
                                HStack {
                                    Image(systemName: "lock.square")
                                    Text("Lockers")
                                        .font(.caption.weight(.medium))
                                        .textCase(.uppercase)
                                        .kerning(1.0)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            if let parkingLot = park.parkingLot {
                                NavigationLink(destination: ParkingReminderView(parkingLot: parkingLot)) {
                                    HStack {
                                        Image(systemName: "car")
                                        Text("Parking Reminder")
                                            .font(.caption.weight(.medium))
                                            .textCase(.uppercase)
                                            .kerning(1.0)
                                            .foregroundColor(.gray)
                                            .padding(.top, 5)
                                    }
                                }
                            }
                        }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Universal Park Pal")
                        .font(.headline) // Match the default title font
                        .foregroundColor(.blue) // Set the color
                }
            }
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
        .environmentObject(DataManagerService())
}
