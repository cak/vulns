//
//  MockAPI.swift
//  VulnIntel
//
//  Created by Caleb Kinney on 1/1/24.
//

import Foundation

enum APIMock {
    static func critical() -> Nist? {
        guard let content = nistCriticalString.data(using: .utf8) else { return nil }
        let decoder = Formatter().jsonDecoder()
        return try! decoder.decode(Nist.self, from: content)
    }

    static func high() -> Nist? {
        guard let content = nistHighString.data(using: .utf8) else { return nil }
        let decoder = Formatter().jsonDecoder()
        return try! decoder.decode(Nist.self, from: content)
    }

    static func epps() -> Epss? {
        guard let content = eppsString.data(using: .utf8) else { return nil }
        let decoder = Formatter().jsonDecoderEpps()
        return try! decoder.decode(Epss.self, from: content)
    }
}
