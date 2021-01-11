//
//  ContentView.swift
//  Shared
//
//  Created by David Jensenius on 2021-01-02.
//

import SwiftUI

struct ProvinceView: View {
    @EnvironmentObject var summary: SummaryData

    var body: some View {
            VStack {
                DescriptionView()
                    .environmentObject(summary)
                ProvinceContentView()
                    .padding(.bottom)
            }
            .environmentObject(summary)
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
