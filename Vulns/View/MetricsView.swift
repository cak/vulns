//
//  MetricsView.swift
//  VulnIntel
//
//  Created by Caleb Kinney on 2/23/24.
//

import Charts
import SwiftUI

struct MetricsView: View {
    let vuln: [NistVulnerability]
    let epssScores: [EpssData]

    var body: some View {
        TabView {
            VStack {
                Text("Days")
                DaysChartView(vuln: vuln).padding(.bottom, 50)
            }
            VStack {
                Text("Hours")
                DaysChartView(vuln: vuln).padding(.bottom, 50)
            }

        }.tabViewStyle(.page)
    }
}

#Preview {
    MetricsView(vuln: (APIMock.critical()?.vulnerabilities ?? []) + (APIMock.high()?.vulnerabilities ?? []), epssScores: APIMock.epps()?.data ?? [])
}
