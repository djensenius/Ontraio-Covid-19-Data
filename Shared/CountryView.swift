//
//  CountryView.swift
//  Ontario COVID-19 Data
//
//  Created by David Jensenius on 2021-01-10.
//

import SwiftUI

struct CountryView: View {
    @EnvironmentObject var summary: CountrySummaryData

    var body: some View {
        VStack {
            CountryDescriptionView()
                .environmentObject(summary)
            CountryContentView()
                .padding(.bottom)
        }
        .environmentObject(summary)
        .onAppear(perform: {
            summary.fetchData()
            let _ = updateTimer
        })
    }
    var updateTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true,
                             block: {_ in
                                summary.fetchData()
                             })
    }
}

struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
        CountryView()
    }
}
