//
//  Epss.swift
//  VulnIntel
//
//  Created by Caleb Kinney on 1/4/24.
//

import Foundation
import SwiftUI

struct Epss: Codable {
    var status: String
    var statusCode: Int
    var version: String
    var access: String
    var total: Int
    var offset: Int
    var limit: Int
    var data: [EpssData]

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status-code"
        case version
        case access
        case total
        case offset
        case limit
        case data
    }
}

struct EpssData: Codable {
    var cve: String
    var epss: String
    var percentile: String
    var date: String
}

extension EpssData {
    var color: Color {
        guard let epssDouble = Double(epss) else {
            return Color.primary
        }

        return switch epssDouble * 100 {
        case 1 ... 10:
            Color.green
        case 10 ... 50:
            Color.yellow
        case 50 ... 75:
            Color.orange
        case 75 ... 100:
            Color.red
        default:
            Color.primary
        }
    }

    var score: Double {
        guard let epssDouble = Double(epss) else {
            return 0.0
        }

        return epssDouble * 100
    }
}
