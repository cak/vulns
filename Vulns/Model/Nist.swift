//
//  Nist.swift
//  VulnIntel
//
//  Created by Caleb Kinney on 12/31/23.
//

import Foundation
import SwiftUI

struct Nist: Codable {
    var resultsPerPage: Int
    var startIndex: Int
    var totalResults: Int
    var format: String
    var version: String
    var timestamp: Date
    var vulnerabilities: [NistVulnerability]
}

struct NistVulnerability: Codable {
    var cve: NistCVE
}

struct NistCVE: Codable {
    var id: String
    var sourceIdentifier: String
    var published: Date
    var lastModified: Date
    var vulnStatus: String
    var evaluatorComment: String?
    var evaluatorImpact: String?
    var evaluatorSolution: String?
    var cisaExploitAdd: String?
    var cisaActionDue: String?
    var cisaRequiredAction: String?
    var cisaVulnerabilityName: String?
    var descriptions: [NistCVEDescription]
    var metrics: NistCVEMetric?
    var weaknesses: [NistCVEWeakness]?
    var configurations: [NistCVEConfiguration]?
    var references: [NistCVEReference]
    var vendorComments: [NistVendorComments]?
}

struct NistVendorComments: Codable {
    var organization: String
    var comment: String
    var lastModified: Date
}

struct NistCVEDescription: Codable {
    var lang: String
    var value: String
}

struct NistCVEMetric: Codable {
    var cvssMetricV31: [NistCvssMetricV31]?
    var cvssMetricV2: [NistCvssMetricV2]?
}

struct NistCvssMetricV31: Codable {
    var source: String
    var type: String
    var cvssData: NistCvssDataV31
    var exploitabilityScore: Double
    var impactScore: Double
}

struct NistCvssDataV31: Codable {
    var version: String
    var vectorString: String
    var attackVector: String
    var attackComplexity: String
    var privilegesRequired: String
    var userInteraction: String
    var scope: String
    var confidentialityImpact: String
    var integrityImpact: String
    var availabilityImpact: String
    var baseScore: Double
    var baseSeverity: String
}

struct NistCvssMetricV2: Codable {
    var source: String
    var type: String
    var cvssData: NistCvssDataV2
    var baseSeverity: String
    var exploitabilityScore: Double
    var impactScore: Double
    var acInsufInfo: Bool
    var obtainAllPrivilege: Bool
    var obtainOtherPrivilege: Bool
    var userInteractionRequired: Bool
}

struct NistCvssDataV2: Codable {
    var version: String
    var vectorString: String
    var accessVector: String
    var accessComplexity: String
    var authentication: String
    var confidentialityImpact: String
    var integrityImpact: String
    var availabilityImpact: String
    var baseScore: Double
}

struct NistCVEWeakness: Codable {
    var source: String
    var type: String
    var description: [NistCVEWeaknessDescription]
}

struct NistCVEWeaknessDescription: Codable {
    var lang: String
    var value: String
}

struct NistCVEConfiguration: Codable {
    var nodes: [NistCVEConfigurationNode]
}

struct NistCVEConfigurationNode: Codable {
    var `operator`: String
    var negate: Bool
    var cpeMatch: [NistCVEConfigurationNodeCpeMatch]
}

struct NistCVEConfigurationNodeCpeMatch: Codable {
    var vulnerable: Bool
    var criteria: String
    var matchCriteriaId: String
}

struct NistCVEReference: Codable {
    var url: String
    var source: String
    var tags: [String]?
}

extension [NistVulnerability] {
    func dateGroup() -> [Date: [NistVulnerability]] {
        Dictionary(grouping: self) { dayOfDate(date: $0.cve.published) ?? Date() }
    }

    func search(query: String) -> [NistVulnerability] {
        if query.isEmpty {
            return self
        }

        let lowerQ = query.lowercased()

        return filter { vuln in
            vuln.cve.id.lowercased().contains(lowerQ) ||
                vuln.cve.descriptions.description.lowercased().contains(lowerQ)
        }
    }
}

extension NistCvssMetricV31 {
    var color: Color {
        switch cvssData.baseScore {
        case 0.1 ... 3.9:
            Color.green

        case 4.0 ... 6.9:
            Color.yellow

        case 7.0 ... 8.9:
            Color.orange

        case 9.0 ... 10.0:
            Color.red

        default:
            Color.primary
        }
    }
}
