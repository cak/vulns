//
//  DaysChartView.swift
//  Vulns
//
//  Created by Caleb Kinney on 3/9/24.
//

import Charts
import SwiftUI

struct DaysChartView: View {
    let vuln: [NistVulnerability]

    var body: some View {
        Chart {
            ForEach(getDayChartData(vulns: vuln), id: \.id) { d in
                BarMark(x: .value("Date", d.date, unit: .day), y: .value("CVEs", d.count))
                    .annotation(position: .overlay, content: {
                        VStack {
                            Text("\(d.count)")
                                .font(.caption2)
                                .bold()
                                .foregroundStyle(.black)
                            Spacer()
                        }
                    })
                    .foregroundStyle(d.color)
                    .foregroundStyle(by: .value("Severity", d.severity.rawValue))
            }

        }.chartForegroundStyleScale(
            [
                Severity.critical.rawValue: Color.red,
                Severity.high.rawValue: Color.orange,
            ]
        )
        .chartYAxis {
            AxisMarks(preset: .extended, position: .leading, values: .automatic(desiredCount: 10))
        }
        .chartYAxisLabel("CVEs")
    }
}

enum Severity: String {
    case critical, high
}

struct DayChartData {
    let id = UUID()
    let date: Date
    let count: Int
    let severity: Severity
    let color: Color
}

func getDayChartData(vulns: [NistVulnerability]) -> [DayChartData] {
    let criticalVulns = vulns.filter { $0.cve.metrics?.cvssMetricV31?.first { $0.type == "Primary" }?.cvssData.baseSeverity == "CRITICAL" }.dateGroup().map { DayChartData(date: $0.key, count: $0.value.count, severity: .critical, color: .red) }

    let highVulns = vulns.filter { $0.cve.metrics?.cvssMetricV31?.first { $0.type == "Primary" }?.cvssData.baseSeverity == "HIGH" }.dateGroup().map { DayChartData(date: $0.key, count: $0.value.count, severity: .high, color: .orange) }

    return criticalVulns + highVulns
}

#Preview {
    DaysChartView(vuln: (APIMock.critical()?.vulnerabilities ?? []) + (APIMock.high()?.vulnerabilities ?? []))
}
