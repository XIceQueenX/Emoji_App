//
//  MainView.swift
//  BlissApplications
//
//  Created by Gloria Martins on 07/11/2024.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: EmojiListViewModel
    @State private var selectedEmoji: EmojiData?
    @State private var goToEmojiList = false

    var body: some View {
        ZStack {
            Color.purple.ignoresSafeArea()

            VStack(spacing: 16) {
                RoundButton(title: "Random Emoji") {
                    selectedEmoji = viewModel.getRandomEmoji()
                }

                if let emoji = selectedEmoji {
                    EmojiImage(emoji: emoji)
                        .padding()
                }

                RoundButton(title: "GoToListEmoji") {
                    goToEmojiList.toggle()
                }
            }
            .padding(.horizontal, 16)
            .fullScreenCover(isPresented: $goToEmojiList) {
                EmojiListView(emojis: viewModel.emojis)
            }
        }
    }
}

#Preview {
    MainView(viewModel: EmojiListViewModel())
}

    
