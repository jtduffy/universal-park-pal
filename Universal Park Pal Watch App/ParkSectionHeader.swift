//
//  ParkSectionHeader.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 10/11/26.
//

import SwiftUI

// Section header for lists grouped by park. Uses color and an icon rather than
// a larger font so long park names don't wrap onto extra lines.
struct ParkSectionHeader: View {
    let park: Park
    let color: Color

    var body: some View {
        Label(park.name, systemImage: park.imageName)
            .font(.headline)
            .foregroundColor(color)
            .textCase(nil)
            .padding(.top, 6)
    }
}
