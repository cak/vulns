//
//  Formatter.swift
//  VulnIntel
//
//  Created by Caleb Kinney on 12/31/23.
//

import Foundation

struct Formatter {
    func jsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter())
        return decoder
    }

    func dateFormatter() -> DateFormatter {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return format
    }

    func jsonDecoderEpps() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatterEpps())
        return decoder
    }

    func dateFormatterEpps() -> DateFormatter {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format
    }
}
