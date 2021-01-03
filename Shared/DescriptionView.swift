//
//  DescriptionView.swift
//  COVID Data Ontario
//
//  Created by David Jensenius on 2021-01-03.
//

import SwiftUI

struct DescriptionView: View {
    var summary: SummaryData
    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Spacer()
                Text("Ontario COVID-19 Data")
                    .font(.title)
                    .padding(.trailing)
            }
            Text("Data updated \(dateString(date: (summary.lastUpdated ?? Date())))")
                .font(.subheadline)
                .padding(.trailing)
            Text("Last check today at \(timeString(date: (summary.lastChecked ?? Date())))")
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


struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView(summary: SummaryData.init())
    }
}
