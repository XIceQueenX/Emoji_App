//
//  EmojiListView.swift
//  BlissApplications
//
//  Created by Gloria Martins on 06/11/2024.
//

import SwiftUI
import CoreData

public struct EmojiListView: View {
    @State var emojis: [EmojiData]
    @Environment(\.dismiss) var dismiss
    
    @State private var deletedItemIndices: [Int] = []
    
    let squareSize: CGFloat = 50
    let numberOfColumns = 4
    
    var columns: [GridItem] {
        var gridItems = [GridItem]()
        for _ in 0..<numberOfColumns {
            gridItems.append(GridItem(.flexible()))
        }
        return gridItems
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: self.columns) {
                    ForEach(emojis.indices, id: \.self) { index in
                        if deletedItemIndices.contains(index) {
                            Text("❌")
                                .font(.system(size: 50))
                                .frame(width: squareSize, height: squareSize)
                                .background(Color.red.opacity(0.1))
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
                .navigationBarItems(leading: Button("Back") {
                    dismiss()
                })
                .padding()
            
            
        }
    }
    
    private func deleteItem(at index: Int) {
        deletedItemIndices.append(index)
    }
}

#Preview {
    let emojis = [EmojiData(name: "Smile", imageData: nil),
                  EmojiData(name: "Heart", imageData: nil)]
    
    EmojiListView(emojis: emojis)
    
}
