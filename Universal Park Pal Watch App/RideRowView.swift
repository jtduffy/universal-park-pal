//
//  RideRowView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 12/30/25.
//

import SwiftUI

struct RideRowView: View {
    let ride: Ride
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            // 1. Status Icon (Left)
            Image(systemName: ride.isOpen ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(ride.isOpen ? .green : .red)
                .font(.title3)
            
            // 2. Name & Time Stack (Vertical)
            VStack(alignment: .leading, spacing: 2) {
                // Ride Name
                Text(ride.name)
                    .font(.headline) // Bolder to stand out
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .layoutPriority(1) // Ensures name doesn't get squished
                
                // Wait Time Subtitle
                if ride.isOpen {
                    Text("\(ride.waitTime) min wait")
                        .font(.caption)
                        .foregroundColor(.accentColor) // Your Minion Yellow (or .secondary)
                } else {
                    Text("Closed")
                        .font(.caption)
                        .foregroundColor(.red.opacity(0.8))
                }
            }
            
            Spacer() // Push everything to the left
        }
        .padding(.vertical, 6) // A little more breathing room
    }
}

// Preview to check the new look
#Preview {
    List {
        RideRowView(ride: Ride.mockData[0]) // Hagrid (120 min)
        RideRowView(ride: Ride.mockData[3]) // Pteranodon (Closed)
    }
}
