//
//  NavigationView.swift
//  Ontario COVID-19 Data
//
//  Created by David Jensenius on 2021-01-10.
//

import SwiftUI

struct AppNavigationView: View {
    #if os(iOS)
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif

    var canadaRow = NavRow(id: 0, name: "Canada", imageName: "Canada")
    var provinceRow = NavRow(id: 1, name: "Ontario", imageName: "Ontario-logo")
    var regionRow = NavRow(id: 2, name: "Region", imageName: "region-of-waterloo")

    let summary = SummaryData()
    let regionSummary = RegionSummaryData()
    let countrySummary = CountrySummaryData()

    var body: some View {
        #if os(iOS)
            if horizontalSizeClass == .compact {
                TabView {
                    CountryView().environmentObject(countrySummary)
                        .tabItem {
                            Image(uiImage: UIImage(imageLiteralResourceName: "Canada"))
                            Text("Canada")
                        }.onAppear {
                            countrySummary.fetchData()
                            let _ = updateCountryTimer
                        }
                    ProvinceView().environmentObject(summary)
                        .tabItem {
                            Image(uiImage: UIImage(imageLiteralResourceName: "Ontario-logo"))
                            Text("Ontario")
                        }.onAppear(perform: {
                            summary.fetchData()
                            let _ = updateProvinceTimer
                        })
                    RegionView().environmentObject(regionSummary)
                        .tabItem {
                            Image(uiImage: UIImage(imageLiteralResourceName: "region-of-waterloo"))
                            Text("Region")
                        }.onAppear {
                            regionSummary.fetchData()
                            let _ = updateRegionTimer
                        }
                }
            } else {
                NavigationView {
                    List {
                        NavigationLink(destination: CountryView().environmentObject(countrySummary)) {
                            NavigationRow(row: canadaRow)
                        }.onAppear {
                            countrySummary.fetchData()
                            let _ = updateCountryTimer
                        }
                        NavigationLink(destination: ProvinceView().environmentObject(summary)) {
                            NavigationRow(row: provinceRow)
                        }.onAppear(perform: {
                            summary.fetchData()
                            let _ = updateProvinceTimer
                        })
                        NavigationLink(destination: RegionView().environmentObject(regionSummary)) {
                            NavigationRow(row: regionRow)
                        }.onAppear {
                            regionSummary.fetchData()
                            let _ = updateRegionTimer
                        }
                    }
                    .listStyle(SidebarListStyle())
                    .navigationTitle("🦠 Data")
                CountryView().environmentObject(countrySummary)                }
            }
        #else //MacOSView
            // MacOS uses iPad because Catalyst
        #endif
    }

    var updateProvinceTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true,
                             block: {_ in
                                summary.fetchData()
                             })
    }

    var updateRegionTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true,
                             block: {_ in
                                regionSummary.fetchData()
                             })
    }

    var updateCountryTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true,
                             block: {_ in
                                countrySummary.fetchData()
                             })
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        AppNavigationView()
    }
}
