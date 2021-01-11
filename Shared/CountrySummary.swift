//
//  CountrySummary.swift
//  Ontario COVID-19 Data
//
//  Created by David Jensenius on 2021-01-10.
//

import Foundation
import SwiftCSV

struct CountrySummaryDay {
    let pruid: Int
    let prname: String
    let prnameFR: String
    let date: Date
    let numconf: Int?
    let numprob: Int?
    let numdeaths: Int?
    let numtotal: Int?
    let numtested: Int?
    let numrecover: Int?
    let percentrecover: Double?
    let ratetested: Double?
    let numtoday: Int?
    let percentoday: Double?
    let ratetotal: Double?
    let ratedeaths: Double?
    let numdeathstoday: Int?
    let percentdeath: Double?
    let numtestedtoday: Int?
    let numrecoveredtoday: Int?
    let percentactive: Double?
    let numactive: Int?
    let rateactive: Double?
    let numtotal_last14: Int?
    let ratetotal_last14: Double?
    let numdeaths_last14: Int?
    let ratedeaths_last14: Double?
    let numtotal_last7: Int?
    let ratetotal_last7: Double?
    let numdeaths_last7: Int?
    let ratedeaths_last7: Double?
    let avgtotal_last7: Double?
    let avgincidence_last7: Double?
    let avgdeaths_last7: Double?
    let avgratedeaths_last7: Double?
}

class CountrySummaryData: ObservableObject {
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
                string:"https://health-infobase.canada.ca/src/data/covidLive/covid19.csv"
        ) else {
            print("Invalid URL")
            return
        }

        self.grabCSVs(url: url)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.lastChecked = Date()
    }

    func grabCSVs(url: URL) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

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
                        if c["pruid"] == "1" {
                            canadaArray.append(c)
                        }
                    }

                    for c in csv.namedRows {
                        if (c["pruid"] == "1") {
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
                                if csv.namedColumns["pruid"]![i] == "1" {
                                    let lData = (csv.namedColumns["date"]![i] , Double(e) ?? 0)
                                    numberArray.append(lData)
                                    lineNumberArray.append(Double(e) ?? 0)
                                }
                            }
                        }
                        if (c.key == "numconf" || c.key == "numtotal" || c.key == "numtested" || c.key == "numrecover" || c.key == "numtoday") {
                            var name = ""
                            switch c.key {
                            case "numconf":
                                name = "Number Confirmed"
                            case "numtotal":
                                name = "Total"
                            case "numtested":
                                name = "Tested"
                            case "numrecover":
                                name = "Recovered"
                            case "numtoday":
                                name = "Number Today"
                            default:
                                name = ""
                            }
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
        dateFormatter.dateFormat = "dd-MM-yyyy"

        let day = SummaryDay(
            ventelator: nil,
            ltcHcwDeaths: nil,
            confimedPositive: nil,
            totalLTCResidentDeaths: nil,
            deaths: Int((csv["numdeaths"]! as NSString).intValue),
            confirmedNegative: nil,
            totalPositiveLTCHCWCases: nil,
            totalPositiveLTCResidentCases: nil,
            reportedDate: dateFormatter.date(from: csv["date"]!)!,
            presumptiveNegative: nil,
            percentPositiveTestsInLastDay: nil,
            numberOfPatientsHospitalized: nil,
            presumptivePositive: nil,
            totalTestsCompletedInTheLastDay: nil,
            totalPatientsApprovedForTestingAsOfReportingDate: nil,
            numberOfPatientsInICU: nil,
            totalCases: Int((csv["numconf"]! as NSString).intValue),
            underInvestigation: nil,
            resolved: Int((csv["numrecover"]! as NSString).intValue)
        )
        return day
    }

    func generateHighlights(today: SummaryDay, yesterday: SummaryDay) -> [SummaryHighlight] {
        return [
            SummaryHighlight(name: "Total Cases", value: today.totalCases ?? nil, change: ((today.totalCases ?? 0) - (yesterday.totalCases ?? 0))),
            SummaryHighlight(name: "Cases Today", value: today.confimedPositive ?? nil, change: ((today.confimedPositive ?? 0) - (yesterday.confimedPositive ?? 0))),
            SummaryHighlight(name: "Hospitalizations", value: today.numberOfPatientsHospitalized ?? nil, change: ((today.numberOfPatientsHospitalized ?? 0) - (yesterday.numberOfPatientsHospitalized ?? 0))),
            SummaryHighlight(name: "Long Term Care", value: today.totalPositiveLTCResidentCases ?? nil, change: ((today.totalPositiveLTCResidentCases ?? 0) - (yesterday.totalPositiveLTCResidentCases ?? 0))),
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
