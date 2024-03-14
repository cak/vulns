//
//  CreditsView.swift
//  VulnIntel
//
//  Created by Caleb Kinney on 2/16/24.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("This product uses data from the NVD API but is not endorsed or certified by the NVD (https://nvd.nist.gov).")
            Text("See EPSS at https://www.first.org/epss")
        }.font(.caption)
    }
}

#Preview {
    CreditsView()
}
