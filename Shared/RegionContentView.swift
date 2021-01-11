//
//  ProvinceView.swift
//  Ontario COVID-19 Data
//
//  Created by David Jensenius on 2021-01-10.
//

import SwiftUI
import SwiftUICharts

struct RegionContentView: View {
    @EnvironmentObject var regionSummary: RegionSummaryData

    var gridItemLayout = [GridItem(.flexible())]
    #if targetEnvironment(macCatalyst)
    var doubleGridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    #else
    var doubleGridItemLayout = [GridItem(.flexible())]
    #endif

    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: gridItemLayout, spacing: 5) {
                    ForEach((0..<3), id: \.self) { i in
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
                    if regionSummary.dataForCharts != nil {
                        ForEach (regionSummary.dataForCharts!, id: \.name) { chart in
                            if (chart.name != "FILE_DATE" && chart.name != "PHU_NAME" && chart.name != "PHU_NUM") {
                                BarChartView(data: ChartData(values: chart.data), title: chart.name, form: ChartForm.extraLarge, dropShadow: false)
                            }
                        }
                    }
                }
            }
        }
    }

    func getName(i: Int) -> String {
        return regionSummary.highlights?[i].name ?? "Fetching"
    }

    func getNumber(i: Int) -> String {
        if regionSummary.highlights?[i].value != nil {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            return numberFormatter.string(from: NSNumber(value: (regionSummary.highlights?[i].value)!)) ?? "-"
        }
        return "-"
    }

    func getDirection(i: Int) -> Image {
        if regionSummary.highlights?[i].change != nil {
            if regionSummary.highlights?[i].change == 0 {
                return Image(systemName: "arrow.left.and.right")
            } else if (regionSummary.highlights?[i].change)! < 0 {
                return Image(systemName: "arrow.down")
            } else {
                return Image(systemName: "arrow.up")
            }
        }

        return Image(systemName: "hourglass")
    }

    func getChange(i: Int) -> String {
        if regionSummary.highlights?[i].change != nil {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let change = numberFormatter.string(from: NSNumber(value: (regionSummary.highlights?[i].change)!)) ?? "-"
            if change != "-" {
                return "\(change) from yesterday"
            }
            return change
        }
        return ""
    }
}

struct RegionView_Previews: PreviewProvider {
    static var previews: some View {
        ProvinceContentView()
    }
}
