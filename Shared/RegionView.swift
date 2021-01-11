//
//  ContentView.swift
//  Shared
//
//  Created by David Jensenius on 2021-01-02.
//

import SwiftUI

struct RegionView: View {
    @EnvironmentObject var regionSummary: RegionSummaryData

    var body: some View {
            VStack {
                RegionDescriptionView()
                    .environmentObject(regionSummary)
                RegionContentView()
                    .padding(.bottom)
            }
            .environmentObject(regionSummary)
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    var summary: SummaryData
    static var previews: some View {
        ContentView(summary: summary)
    }
}
*/
