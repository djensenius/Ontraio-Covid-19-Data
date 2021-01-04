//
//  ContentView.swift
//  Shared
//
//  Created by David Jensenius on 2021-01-02.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    @EnvironmentObject var summary: SummaryData

    var gridItemLayout = [GridItem(.flexible())]
    #if targetEnvironment(macCatalyst)
    var doubleGridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    #else
    var doubleGridItemLayout = [GridItem(.flexible())]
    #endif

    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: gridItemLayout, spacing: 5) {
                    ForEach((0..<6), id: \.self) { i in
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color(UIColor.systemGray6))
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(getName(i: i))
                                                .font(.title2)
                                                .padding(.leading)
                                            Spacer()
                                        }
                                        HStack {
                                            Text(getDirection(i: i))
                                                .font(.subheadline)
                                                .padding(.leading)
                                            Text(getChange(i: i))
                                                .font(.subheadline)
                                        }
                                    }
                                    Text(getNumber(i: i))
                                        .font(.title)
                                        .padding()
                                }
                            }
                        }
                    }
                }
                LazyVGrid(columns: doubleGridItemLayout, spacing: 5) {
                    if summary.dataForLineCharts != nil {
                        ForEach (summary.dataForLineCharts!, id: \.name) { chart in
                            if (chart.name != "Reported Date" && chart.name != "Presumptive Negative" && chart.name != "Presumptive Positive") {
                                LineChartView(data: chart.data, title: chart.name, form: ChartForm.extraLarge, dropShadow: false)
                            }
                        }
                    }
                }
            }
        }
    }

    func getName(i: Int) -> String {
        return summary.highlights?[i].name ?? "Fetching"
    }

    func getNumber(i: Int) -> String {
        if summary.highlights?[i].value != nil {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            return numberFormatter.string(from: NSNumber(value: (summary.highlights?[i].value)!)) ?? "-"
        }
        return "-"
    }

    func getDirection(i: Int) -> Image {
        if summary.highlights?[i].change != nil {
            if summary.highlights?[i].change == 0 {
                return Image(systemName: "arrow.left.and.right")
            } else if (summary.highlights?[i].change)! < 0 {
                return Image(systemName: "arrow.down")
            } else {
                return Image(systemName: "arrow.up")
            }
        }

        return Image(systemName: "hourglass")
    }

    func getChange(i: Int) -> String {
        if summary.highlights?[i].change != nil {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let change = numberFormatter.string(from: NSNumber(value: (summary.highlights?[i].change)!)) ?? "-"
            if change != "-" {
                return "\(change) from yesterday"
            }
            return change
        }
        return ""
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
