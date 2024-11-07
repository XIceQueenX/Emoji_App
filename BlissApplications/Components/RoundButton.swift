//
//   RoundButton.swift
//  Free-Viewing
//
//  Created by Gloria on 27/03/2024.
//

import SwiftUI

struct RoundButton: View {
    var title: LocalizedStringResource
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.secondary))
                .cornerRadius(24)
                .frame(height: 48)
        }
    }
}

#Preview {
    RoundButton(title: "hello",
                action: {})
    .background(Color(.accent))
}
