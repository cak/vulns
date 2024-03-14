//
//  CVSSData.swift
//  VulnIntel
//
//  Created by Caleb Kinney on 2/5/24.
//

import Foundation
import SwiftUI

struct CVSSData {
    let score: Double
    let severity: String
    let color: Color
}

func getCvssData(cvss: [NistCvssMetricV31]) -> CVSSData {
    let cvssScore = cvss.first { $0.type == "Primary" }?.cvssData.baseScore ?? 0.0
    let cvssSev = cvss.first { $0.type == "Primary" }?.cvssData.baseSeverity ?? "N/A"
    let cvssColor = cvss.first { $0.type == "Primary" }?.color ?? Color.black

    return CVSSData(score: cvssScore, severity: cvssSev, color: cvssColor)
}
