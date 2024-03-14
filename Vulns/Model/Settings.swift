//
//  Settings.swift
//  Vulns
//
//  Created by Caleb Kinney on 3/4/24.
//

import Foundation

enum PubLast: Int, CaseIterable, Identifiable {
    var id: Self {
        self
    }

    case three = 3
    case seven = 7
    case fifteen = 15
    case thirty = 30
}
