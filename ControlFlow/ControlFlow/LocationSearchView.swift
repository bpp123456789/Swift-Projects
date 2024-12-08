//
//  LocationSearchView.swift
//  ControlFlow
//
//  Created by William Petrik on 12/6/24.
//

import SwiftUI

struct LocationSearchView: View {
    @Binding var selectedLocation: LocationResult?
    @State private var searchText = ""
    @State private var searchVM = LocationSearchViewModel()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            
            List(searchVM.searchResults, id: \.self) { result in
                VStack(alignment: .leading) {
                    Text(result.title)
                    Text(result.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .onTapGesture {
                    Task{
                        do {
                            selectedLocation = try await searchVM.returnLocationResults(for: result)
                            dismiss()
                        } catch {
                            searchVM.error = error
                        }
                    }
                    
                }
            }
            Text("You entered: \(searchText)")
                .navigationTitle("Location Search")
                .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $searchText)
        .autocorrectionDisabled()
        .onChange(of: searchText) {
            searchVM.updateSearchText(searchText)
        }
    }
}

#Preview {
    LocationSearchView(selectedLocation: .constant(nil))
}
