//
//  CountrySummary.swift
//  Ontario COVID-19 Data
//
//  Created by David Jensenius on 2021-01-10.
//

import Foundation
import SwiftCSV

struct RegionSummaryDay {
    let fileDate: Date
    let name: String
    let number: Int
    let active: Int
    let resolved: Int
    let deaths: Int
}

class RegionSummaryData: ObservableObject {
    @Published var today: SummaryDay?
    @Published var yesterday: SummaryDay?
    @Published var highlights: [SummaryHighlight]?
    @Published var lastChecked: Date?
    @Published var lastUpdated: Date?
    @Published var daily: [SummaryHighlightOverview]?
    @Published var dataForCharts: [Chart]?
    @Published var dataForLineCharts: [LineChart]?

    func fetchData() {
        print("Fetching data");
        guard let url = URL(
                string:"https://data.ontario.ca/dataset/1115d5fe-dd84-4c69-b5ed-05bf0c0a0ff9/resource/d1bfe1ad-6575-4352-8302-09ca81f7ddfc/download/cases_by_status_and_phu.csv"
        ) else {
            print("Invalid URL")
            return
        }

        self.grabCSVs(url: url)
        self.lastChecked = Date()
    }

    func grabCSVs(url: URL) {
        downloadCSV(with: url) { (data, error) in
            if let data = data {
                do {
                    let s = String(data: data, encoding: .utf8)
                    let csv: CSV = try CSV(string: s!)
                    var dailySummary: [SummaryHighlightOverview] = []
                    var allTheCharts: [Chart] = []
                    var allTheLineCharts: [LineChart] = []
                    var canadaArray: [[String : String]] = [];

                    for (c) in csv.namedRows {
                        if c["PHU_NAME"] == "WATERLOO REGION" {
                            canadaArray.append(c)
                        }
                    }

                    for c in csv.namedRows {
                        if c["PHU_NAME"] == "WATERLOO REGION" {
                            let day = self.parseCSVDay(csv: c)
                            let sum = SummaryHighlightOverview(date: day.reportedDate, highlights: self.generateHighlights(today: day, yesterday: day))
                            dailySummary.append(sum)
                        }
                    }

                    for c in csv.namedColumns {
                        var numberArray: [(String, Double)] = []
                        var lineNumberArray: [Double] = []
                        for (i, e) in c.value.enumerated() {
                            if e != "" {
                                if csv.namedColumns["PHU_NAME"]![i] == "WATERLOO REGION" {
                                    let lData = (csv.namedColumns["FILE_DATE"]![i] , Double(e) ?? 0)
                                    numberArray.append(lData)
                                    lineNumberArray.append(Double(e) ?? 0)
                                }
                            }
                        }
                        var name = ""
                        switch (c.key) {
                        case "ACTIVE_CASES":
                            name = "Active Cases"
                        case "RESOLVED_CASES":
                            name = "Resolved Cases"
                        case "DEATHS":
                            name = "Deaths"
                        default:
                            name = ""
                        }
                        if name != "" {
                            allTheCharts.append(Chart(name: name, data: numberArray))
                            allTheLineCharts.append(LineChart(name: name, data: lineNumberArray))
                        }
                    }
                    DispatchQueue.main.async {
                        let today = self.parseCSVDay(csv: canadaArray.last!)
                        let yesterday = self.parseCSVDay(csv: canadaArray[canadaArray.count - 2])
                        self.today = today
                        self.yesterday = yesterday
                        self.highlights = self.generateHighlights(today: today, yesterday: yesterday)
                        self.daily = dailySummary
                        self.dataForCharts = allTheCharts
                        self.dataForLineCharts = allTheLineCharts
                    }
                } catch {
                    print("Parse error")
                }
            }
        }
    }

    func parseCSVDay(csv: [String: String]) -> SummaryDay {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"

        let day = SummaryDay(
            ventelator: nil,
            ltcHcwDeaths: nil,
            confimedPositive: Int((csv["ACTIVE_CASES"]! as NSString).intValue),
            totalLTCResidentDeaths: nil,
            deaths: Int((csv["DEATHS"]! as NSString).intValue),
            confirmedNegative: nil,
            totalPositiveLTCHCWCases: nil,
            totalPositiveLTCResidentCases: nil,
            reportedDate: dateFormatter.date(from: csv["FILE_DATE"]!)!,
            presumptiveNegative: nil,
            percentPositiveTestsInLastDay: nil,
            numberOfPatientsHospitalized: nil,
            presumptivePositive: nil,
            totalTestsCompletedInTheLastDay: nil,
            totalPatientsApprovedForTestingAsOfReportingDate: nil,
            numberOfPatientsInICU: nil,
            totalCases: nil,
            underInvestigation: nil,
            resolved: Int((csv["RESOLVED_CASES"]! as NSString).intValue)
        )
        return day
    }

    func generateHighlights(today: SummaryDay, yesterday: SummaryDay) -> [SummaryHighlight] {
        return [
            SummaryHighlight(name: "Active Cases", value: today.confimedPositive ?? nil, change: ((today.confimedPositive ?? 0) - (yesterday.confimedPositive ?? 0))),
            SummaryHighlight(name: "Deaths", value: today.deaths ?? nil, change: ((today.deaths ?? 0) - (yesterday.deaths ?? 0))),
            SummaryHighlight(name: "Resolved", value: today.resolved ?? nil, change: ((today.resolved ?? 0) - (yesterday.resolved ?? 0)))
        ]
    }

    func downloadCSV(with url: URL, complete: @escaping (_ result: Data?, _ error: Error?) -> Void) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            complete(data, error)
        }.resume()
    }
}
