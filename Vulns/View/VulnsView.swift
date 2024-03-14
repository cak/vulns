//
//  VulnsView.swift
//  VulnIntel
//
//  Created by Caleb Kinney on 12/31/23.
//

import SwiftUI

struct VulnsView: View {
    let vuln: [NistVulnerability]
    let epssScores: [EpssData]
    @State private var query = ""
    @State private var showSettings = false

    var body: some View {
        NavigationView {
            List(vuln.search(query: query)
                .dateGroup()
                .sorted { $0.key > $1.key }, id: \.key)
            { date, cves in
                Section(header: Text("\(date.formatted(date: .complete, time: .omitted))")) {
                    ForEach(cves, id: \.cve.id) { cve in
                        NavigationLink(destination: VulnDetailView(vuln: cve, epss: findEpss(epssScores: epssScores, cveId: cve.cve.id))) {
                            VulnRowView(vuln: cve, epss: findEpss(epssScores: epssScores, cveId: cve.cve.id))
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.inset)
            .navigationTitle("Vulnerabilities")
            .toolbar {
                Button {
                    showSettings.toggle()
                } label: {
                    Image(systemName: "gearshape").accessibilityLabel("Settings icon")
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(showSettings: $showSettings)
                    .presentationDetents([.large])
            }
        }
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .automatic))
    }
}

func findEpss(epssScores: [EpssData], cveId: String) -> EpssData? {
    epssScores.first { $0.cve == cveId }
}

#Preview {
    VulnsView(vuln: (APIMock.critical()?.vulnerabilities ?? []) + (APIMock.high()?.vulnerabilities ?? []), epssScores: APIMock.epps()?.data ?? [])
}
