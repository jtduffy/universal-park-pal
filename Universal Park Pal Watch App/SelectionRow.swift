//
//  SelectionRow.swift
//  Universal Park Pal Watch App
//
//  Created by Jerry Duffy on 10/11/26.
//

import SwiftUI

// A picker row that shows the selected value large, with a small caption above it.
// The system Picker always renders its value in small secondary text.
// A nil selection shows a "Select…" placeholder until the user picks a value.
// Pass gridColumns to pick from a grid of buttons instead of a list (good for long number ranges).
struct SelectionRow<Option: Hashable>: View {
    let title: String
    let options: [Option]
    @Binding var selection: Option?
    var gridColumns: Int? = nil
    let text: (Option) -> String

    var body: some View {
        NavigationLink {
            if let gridColumns {
                SelectionGrid(title: title, options: options, selection: $selection, columns: gridColumns, text: text)
            } else {
                SelectionList(title: title, options: options, selection: $selection, text: text)
            }
        } label: {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)

                if let selection {
                    Text(text(selection))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                } else {
                    Text("Select…")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                }
            }
            .padding(.vertical, 2)
        }
    }
}

private struct SelectionList<Option: Hashable>: View {
    @Environment(\.dismiss) private var dismiss

    let title: String
    let options: [Option]
    @Binding var selection: Option?
    let text: (Option) -> String

    var body: some View {
        ScrollViewReader { proxy in
            List(options, id: \.self) { option in
                Button {
                    selection = option
                    dismiss()
                } label: {
                    HStack {
                        Text(text(option))
                        Spacer()
                        if option == selection {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            .onAppear {
                if let selection {
                    proxy.scrollTo(selection, anchor: .center)
                }
            }
        }
        .navigationTitle(title)
    }
}

private struct SelectionGrid<Option: Hashable>: View {
    @Environment(\.dismiss) private var dismiss

    let title: String
    let options: [Option]
    @Binding var selection: Option?
    let columns: Int
    let text: (Option) -> String

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: columns), spacing: 4) {
                    ForEach(options, id: \.self) { option in
                        let isSelected = option == selection

                        Button {
                            selection = option
                            dismiss()
                        } label: {
                            Text(text(option))
                                .font(.body)
                                .fontWeight(.semibold)
                                .monospacedDigit()
                                .minimumScaleFactor(0.6)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, minHeight: 36)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(isSelected ? Color.accentColor : Color(white: 0.2))
                                )
                                .foregroundColor(isSelected ? .black : .white)
                        }
                        .buttonStyle(.plain)
                        .id(option)
                    }
                }
            }
            .onAppear {
                if let selection {
                    proxy.scrollTo(selection, anchor: .center)
                }
            }
        }
        .navigationTitle(title)
    }
}
