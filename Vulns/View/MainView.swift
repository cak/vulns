//
//  MainView.swift
//  VulnIntel
//
//  Created by Caleb Kinney on 12/31/23.
//

import SwiftUI

struct MainView: View {
    let vulns = (APIMock.critical()?.vulnerabilities ?? []) + (APIMock.high()?.vulnerabilities ?? [])
    @State var vulnContoller = VulnsContoller()

    var body: some View {
        TabView {
            VulnsView(vuln: vulns, epssScores: vulnContoller.scores)
                .tabItem {
                    Label("Vulnerabilities", systemImage: "barometer").accessibilityLabel("barometer")
                }

            MetricsView(vuln: vulns, epssScores: vulnContoller.scores)
                .tabItem {
                    HStack {
                        Label("Metrics", systemImage: "chart.bar").accessibilityLabel("chart")
                    }
                }
        }.task {
            vulnContoller.getVulnerabilities(publishedDays: -7)
//            do {
//                try await vulnContoller.getEpssScores(cves: vulns.prefix(10).map { $0.cve.id})
//            } catch {
//                print("Error", error)
//            }
        }
    }
}

#Preview {
    MainView()
}
