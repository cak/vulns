//
//  VulnsContoller.swift
//  Vulns
//
//  Created by Caleb Kinney on 3/2/24.
//

import Foundation

@Observable class VulnsContoller {
    var lastUpdated: Date = .now
    var vulnerabilities: [NistVulnerability] = []
    var scores: [EpssData] = []

    func getVulnerabilities(publishedDays _: Int) {
        let settings = UserDefaults.standard
        var pubLast = settings.integer(forKey: "pubLast")

        if pubLast == 0 {
            pubLast = 7
        }

        let dateNow = Date()
        var dateComponent = DateComponents()
        dateComponent.day = -pubLast
        let pubEndDate = dateNow.ISO8601Format()
        let pubStartDate = Calendar.current.date(byAdding: dateComponent, to: dateNow)?.ISO8601Format() ?? pubEndDate

        let criticalUrl = createNistUrl(cvssV3Severity: "CRITICAL", pubStartDate: pubStartDate, pubEndDate: pubEndDate)

        let highUrl = createNistUrl(cvssV3Severity: "HIGH", pubStartDate: pubStartDate, pubEndDate: pubEndDate)

        print(criticalUrl)
        print(pubLast)
    }

    private func createNistUrl(cvssV3Severity: String, pubStartDate: String, pubEndDate: String) -> String {
        let nistUrl = "https://services.nvd.nist.gov/rest/json/cves/2.0"
        return "\(nistUrl)?cvssV3Severity=\(cvssV3Severity)&pubStartDate=\(pubStartDate)&pubEndDate=\(pubEndDate)"
    }

    private func getNistData(url: URL) async throws -> Nist? {
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
        let decodedNist = try JSONDecoder().decode(Nist.self, from: data)
        return decodedNist
    }

    private func getEpssScores(cves: [String]) async throws -> Epss? {
        let epssUrl = "https://api.first.org/data/v1/epss"
        let cveString = cves.joined(separator: ",")
        print("Fetching \(cves.count) from EPSS")
        guard let url = URL(string: "\(epssUrl)?cve=\(cveString)") else { return nil }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
        let decodedEpss = try JSONDecoder().decode(Epss.self, from: data)
        return decodedEpss
    }
}
