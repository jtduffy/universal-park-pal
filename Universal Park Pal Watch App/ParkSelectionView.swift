//
//  ParkSelectionView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 8/8/25.
//

import Foundation
import SwiftUI

struct ParkSelectionView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text(resort.rawValue.capitalized)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
            }
        }
        .navigationTitle("dddd")
    }
}

#Preview {
    NavigationStack {
        ParkSelectionView(resort: .Orlando)
    }
}
