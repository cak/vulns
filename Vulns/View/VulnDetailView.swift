//
//  VulnDetailView.swift
//  VulnIntel
//
//  Created by Caleb Kinney on 1/13/24.
//

import Foundation
import SwiftUI

struct VulnDetailView: View {
    let vuln: NistVulnerability
    let epss: EpssData?
    let cvss: CVSSData

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 20) {
                    IconView(value: cvss.severity, type: "CVSS", color: cvss.color)
                    IconView(value: "\(String(format: "%.1f", epss?.score ?? 0.0))%", type: "EPSS", color: epss?.color ?? .secondary)
                    IconView(value: "\((vuln.cve.cisaExploitAdd != nil) ? "TRUE" : "FALSE")", type: "CISA KEV", color: vuln.cve.cisaExploitAdd != nil ? .red : .secondary)
                }

                Text("Description").font(.title2)
                    .bold()
                    .padding(.top, 20)
                Text(vuln.cve.descriptions
                    .first { $0.lang == "en" }?.value ?? "")
                    .font(.body)

                if vuln.cve.cisaExploitAdd != nil {
                    CisaKevDetaiView(vuln: vuln)
                }

                VStack(alignment: .leading) {
                    Text("Details").font(.title2)
                        .bold()
                        .padding(.top, 20)

                    TitleValueView(title: "Published:", value: vuln.cve.published.formatted(date: .numeric, time: .complete))
                    TitleValueView(title: "Modified:", value: vuln.cve.lastModified.formatted(date: .numeric, time: .complete))
                }

                VStack(alignment: .leading) {
                    Text("CVSSv3").font(.title2)
                        .bold()
                        .padding(.top, 20)

                    ForEach(vuln.cve.metrics?.cvssMetricV31 ?? [], id: \.source) { metric in
                        CVSSDetailView(cvss: metric).padding(.top, 2)
                    }
                }

                if !(vuln.cve.weaknesses ?? []).isEmpty {
                    VStack(alignment: .leading) {
                        Text("Weaknesses").font(.title2)
                            .bold()
                            .padding(.top, 20)

                        ForEach(vuln.cve.weaknesses?.filter { w in
                            w.type == "Primary"
                        } ?? [], id: \.source) { weakness in
                            HStack(alignment: .center) {
                                Text(" - ")
                                if let enDesc = weakness.description.first(where: { $0.lang == "en" })?.value {
                                    if let wUrl = URL(string: "https://cwe.mitre.org/data/definitions/\(enDesc).html") {
                                        Link(enDesc, destination: wUrl)
                                    } else {
                                        Text(enDesc)
                                    }
                                }
                            }.font(.caption)
                        }
                    }
                }

                if !(vuln.cve.configurations ?? []).isEmpty {
                    VStack(alignment: .leading) {
                        Text("Common Platform Enumeration").font(.title2)
                            .bold()
                            .padding(.top, 20)
                    }

                    ForEach(getConfigNodes(config: vuln.cve.configurations), id: \.self) { cpe in
                        HStack(alignment: .center) {
                            Text(" - ")
                            Text(cpe)
                        }.font(.caption)
                    }
                }

                if !(vuln.cve.vendorComments ?? []).isEmpty {
                    VStack(alignment: .leading) {
                        Text("Configurations").font(.title2)
                            .bold()
                            .padding(.top, 20)
                    }

                    ForEach(vuln.cve.vendorComments ?? [], id: \.comment) { comment in
                        HStack(alignment: .center) {
                            Text(" - ")
                            Text("\(comment.organization): \(comment.comment) (\(comment.lastModified.formatted())")
                        }
                    }
                }

                if !vuln.cve.references.isEmpty {
                    VStack(alignment: .leading) {
                        Text("References").font(.title2)
                            .bold()
                            .padding(.top, 20)

                        ForEach(vuln.cve.references, id: \.source) { ref in
                            if let url = URL(string: ref.url) {
                                HStack(alignment: .center) {
                                    Text(" - ")
                                    Link(ref.url, destination: url).font(.caption2)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(3)
                                }.font(.caption)
                            }
                        }
                    }
                    Text("Credits").font(.title2)
                        .bold()
                        .padding(.top, 20)

                    CreditsView()
                }
            }
        }.padding(.all, 5)
            .navigationTitle(vuln.cve.id)
            .toolbar {
                if let url = URL(string: "https://nvd.nist.gov/vuln/detail/\(vuln.cve.id)") {
                    Spacer()
                    ShareLink(item: url) {
                        Image(systemName: "square.and.arrow.up")
                            .accessibilityLabel(Text("Share logo"))
                    }.padding(.trailing, 15)
                }
            }
    }

    init(vuln: NistVulnerability, epss: EpssData?) {
        self.vuln = vuln
        self.epss = epss
        cvss = getCvssData(cvss: vuln.cve.metrics?.cvssMetricV31 ?? [])
    }
}

struct CisaKevDetaiView: View {
    let vuln: NistVulnerability
    var body: some View {
        VStack(alignment: .leading) {
            Text("CISA KEV").font(.title2)
                .bold()
                .padding(.top, 20)

            Text(vuln.cve.cisaVulnerabilityName ?? vuln.cve.id).font(.subheadline)

            VStack(alignment: .leading) {
                Text("Required Action").font(.caption).bold()
                Text(vuln.cve.cisaRequiredAction ?? "N/A")
            }.padding(.vertical, 3).font(.caption)

            TitleValueView(title: "Added:", value: vuln.cve.cisaExploitAdd ?? "N/A")
            TitleValueView(title: "Action Due:", value: vuln.cve.cisaActionDue ?? "N/A")
        }
    }
}

struct CVSSDetailView: View {
    let cvss: NistCvssMetricV31
    var body: some View {
        VStack(alignment: .leading) {
            Text(cvss.type).font(.title3).bold()
            TitleValueView(title: "Source:", value: cvss.source)
            TitleValueView(title: "Base Score:", value: String(format: "%.2f", cvss.cvssData.baseScore))
            TitleValueView(title: "Severity:", value: cvss.cvssData.baseSeverity)
            TitleValueView(title: "Exploitability:", value: "\(cvss.exploitabilityScore)")
            TitleValueView(title: "Impact:", value: "\(cvss.impactScore)")
            TitleValueView(title: "Vector:", value: cvss.cvssData.vectorString)
        }
    }
}

struct TitleValueView: View {
    let title: String
    let value: String
    var body: some View {
        HStack {
            Text(title).bold()
            Text(value)
        }.font(.caption)
    }
}

struct IconView: View {
    let value: String
    let type: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading) {
            Text(type).font(.caption2).bold()
            Text(value).font(.callout).monospaced().foregroundStyle(color).bold()
        }
        .font(.caption2)
    }
}

func getConfigNodes(config: [NistCVEConfiguration]?) -> [String] {
    guard let config else {
        return []
    }

    return config.flatMap { config in config.nodes.flatMap { node in node.cpeMatch.map { cpe in cpe.criteria } }
    }
}

#Preview {
    VulnDetailView(vuln: APIMock.critical()!.vulnerabilities[0], epss: EpssData(cve: "2024", epss: "0.1456", percentile: "96", date: "2024-01-01"))
}
