//
//  EmojiImage.swift
//  BlissApplications
//
//  Created by Gloria Martins on 07/11/2024.
//

import SwiftUI
import SwiftUI

struct EmojiImage: View {
    let emoji: EmojiData
    let squareSize: CGFloat = 50
    
    var body: some View {
        if let imageData = emoji.imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: squareSize, height: squareSize)
                .cornerRadius(8)
        } else {
            Text("No image")
                .font(.caption)
                .foregroundColor(.gray)
        }
        
    }
}

#Preview {
    EmojiImage(emoji: EmojiData(name: "Heart", imageData: nil))
}
