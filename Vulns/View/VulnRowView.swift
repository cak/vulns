//
//  VulnRowView.swift
//  VulnIntel
//
//  Created by Caleb Kinney on 1/1/24.
//

import SwiftUI

struct VulnRowView: View {
    let vuln: NistVulnerability
    let epss: EpssData?
    let cvss: CVSSData

    var body: some View {
        VStack(alignment: .leading) {
            UnevenRoundedRectangle(
                cornerRadii: .init(
                    topLeading: 30.0,
                    bottomLeading: 0.0,
                    bottomTrailing: 0.0,
                    topTrailing: 0.0
                ),
                style: .continuous
            )
            .frame(height: 10)
            .foregroundStyle(cvss.color)
            HStack(alignment: .center) {
                VStack(alignment: .center) {
                    Text(cvss.severity).font(.caption2).bold()
                    Text(String(format: "%.1f", cvss.score)).font(.title).bold().foregroundStyle(cvss.color)
                }.padding(.trailing, 6)
                VStack(alignment: .leading) {
                    Text(vuln.cve.id)
                        .font(.title2).bold()
                    Text(vuln.cve.descriptions
                        .first { $0.lang == "en" }?
                        .value.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                        .font(.footnote).lineLimit(5)
                    HStack(alignment: .center) {
                        HStack {
                            Text("EPSS:").bold().padding(.trailing, -5)
                            if let epss {
                                Text("\(String(format: "%.2f", epss.score))%").foregroundStyle(epss.color)
                            } else {
                                Text("N/A")
                            }
                        }.padding(.trailing)
                        HStack {
                            Text("CISA KEV:").bold().padding(.trailing, -5)
                            Text("\((vuln.cve.cisaExploitAdd != nil) ? "TRUE" : "FALSE")")
                                .foregroundStyle((vuln.cve.cisaExploitAdd != nil) ? Color.red : Color.primary)
                        }
                    }.font(.caption2).padding(.vertical, 0.1)
                }
            }
        }
    }

    init(vuln: NistVulnerability, epss: EpssData?) {
        self.vuln = vuln
        self.epss = epss
        cvss = getCvssData(cvss: vuln.cve.metrics?.cvssMetricV31 ?? [])
    }
}

#Preview {
    VulnRowView(vuln: APIMock.high()!.vulnerabilities.first!, epss: nil)
}
