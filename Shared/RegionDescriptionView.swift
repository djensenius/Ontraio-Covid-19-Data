//
//  CountryDescriptionView.swift
//  Ontario COVID-19 Data
//
//  Created by David Jensenius on 2021-01-10.
//

import SwiftUI

struct RegionDescriptionView: View {
    @EnvironmentObject var regionSummary: RegionSummaryData

    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Spacer()
                Text("Region of Waterloo COVID-19 Data")
                    .font(.title)
                    .multilineTextAlignment(.trailing)
                    .padding(.trailing)
            }
            Text("Data updated \(dateString(date: (regionSummary.lastUpdated ?? Date())))")
                .font(.subheadline)
                .padding(.trailing)
            Text("Last check today at \(timeString(date: (regionSummary.lastChecked ?? Date())))")
                .font(.subheadline)
                .padding(.trailing)
        }
    }
    var dateFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d YYYY"
        return formatter
    }

    var timeFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    func dateString(date: Date) -> String {
         let time = dateFormat.string(from: date)
         return time
    }

    func timeString(date: Date) -> String {
        let time = timeFormat.string(from: date)
        return time
    }
}

struct CountryDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        CountryDescriptionView()
    }
}
