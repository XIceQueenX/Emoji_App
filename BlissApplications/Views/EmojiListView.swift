//
//  EmojiListView.swift
//  BlissApplications
//
//  Created by Gloria Martins on 06/11/2024.
//

import SwiftUI
import CoreData

public struct EmojiListView: View {
    @State var emojis: [EmojiCache]
    @Environment(\.dismiss) private var dismiss
    
    @State private var deletedItemIndices: [Int] = []
    
    let squareSize: CGFloat = 50
    let numberOfColumns = 4
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: numberOfColumns)
    }
    
    public var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            ScrollView {
                LazyVGrid(columns: self.columns) {
                    ForEach(emojis.indices, id: \.self) { index in
                        if deletedItemIndices.contains(index) {
                            Text("❌")
                                .font(.system(size: 50))
                                .frame(width: squareSize, height: squareSize)
                                .cornerRadius(8)
                        } else {
                            EmojiImage(emoji: emojis[index])
                                .onTapGesture {
                                    deleteItem(at: index)
                                }
                        }
                    }
                }
            }
            .refreshable {
                deletedItemIndices.removeAll()
            }.navigationTitle("Emoji List")
            .padding()
        }
    }
    
    private func deleteItem(at index: Int) {
        deletedItemIndices.append(index)
    }
}

#Preview {
    EmojiListView(emojis: [])
}
