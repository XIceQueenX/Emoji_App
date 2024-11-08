//
//  EmojiImage.swift
//  BlissApplications
//
//  Created by Gloria Martins on 07/11/2024.
//

import SwiftUI

struct EmojiImage: View {
    let emoji: EmojiCache
    let squareSize: CGFloat = 50
    
    var body: some View {
        if let imageData = emoji.url, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: squareSize, height: squareSize)
                .cornerRadius(8)
        } else {
            Text(emoji.name ?? "Name not found")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    EmojiImage(emoji: EmojiCache(context: PersistenceController.preview.container.viewContext))
}
