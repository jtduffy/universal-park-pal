//
//  ContentView.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 8/7/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(Resort.allCases) { resort in
                    NavigationLink(destination: ParkSelectionView(resort: resort)) {
                        Text(resort.rawValue.capitalized)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Park Pal")
        }
    }
}
#Preview {
    ContentView()
}
