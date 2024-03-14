//
//  SettingsView.swift
//  VulnIntel
//
//  Created by Caleb Kinney on 2/23/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding
    var showSettings: Bool

    @State var vulnContoller = VulnsContoller()

    @AppStorage("pubLast")
    private var pubLastOption: Int = 7

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Settings")
                Spacer()
                Button("Done") {
                    showSettings = false
                }
            }
            .bold()
            .padding(.horizontal, 35)
            .padding(.top, 10)
            Form {
                Section("Published") {
                    Picker("CVE Published in Last", selection: $pubLastOption) {
                        ForEach(PubLast.allCases) { option in
                            Text("^[\(option.rawValue) Day](inflect: true)").tag(option.rawValue)
                        }
                    }.onChange(of: pubLastOption) {
                        vulnContoller.getVulnerabilities(publishedDays: -7)
                    }
                }

                Section("About") {
                    LabeledContent("Version", value: "1.0")
                    Text("Created by Caleb Kinney")
                    if let ghUrl = URL(string: "https://github.com/cak/vulnintel") {
                        Link("GitHub Repository", destination: ghUrl)
                    }
                }
                Section("Credits") {
                    Text("This product uses data from the NVD API but is not endorsed or certified by the NVD (https://nvd.nist.gov).")
                    Text("See EPSS at https://www.first.org/epss")
                }
            }.font(.footnote)
        }
    }
}

#Preview {
    SettingsView(showSettings: .constant(true))
}
