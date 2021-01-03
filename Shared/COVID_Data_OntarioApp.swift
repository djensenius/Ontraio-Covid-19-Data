//
//  COVID_Data_OntarioApp.swift
//  Shared
//
//  Created by David Jensenius on 2021-01-02.
//

import SwiftUI

@main
struct COVID_Data_OntarioApp: App {
    let summary = SummaryData()

    var body: some Scene {
        WindowGroup {
            VStack {
                DescriptionView()
                    .environmentObject(summary)
                ContentView()
                    .padding(.bottom)
            }
            .environmentObject(summary)
            .onAppear(perform: {
                summary.fetchData()
                let _ = updateTimer
            })
        }
    }
    var updateTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true,
                             block: {_ in
                                summary.fetchData()
                             })
    }
}
