//
//  TextNavigationLink.swift
//  BlissApplications
//
//  Created by Gloria Martins on 08/11/2024.
//

import SwiftUI

struct TextNavigationLink: View {
    var title = ""
    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 16).bold())
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.secondary))
            .cornerRadius(24)
            .frame(height: 48)
    }
}

#Preview {
    TextNavigationLink(title: "Tetse")
}
