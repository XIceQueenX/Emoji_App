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
    @State private var goToAvatarList = false
    @State private var goToRepoList = false

    @State private var hideRandomEmoji = false

    var body: some View {
        ZStack {
            Color(.accent).ignoresSafeArea()

            VStack(spacing: 16) {
                
                if let emoji = selectedEmoji, !hideRandomEmoji {
                    EmojiImage(emoji: emoji)
                        .padding()
                }
                
                RoundButton(title: "Random Emoji") {
                    selectedEmoji = viewModel.getRandomEmoji()
                }
                
                RoundButton(title: "Emoji List") {
                    goToEmojiList.toggle()
                    hideRandomEmoji.toggle()
                }
                
                RoundTextField(text: $viewModel.searchText, placeholder: "Search by username", onClick: {
                    viewModel.getAvatar()
                })
                
                RoundButton(title: "Avatar List") {
                    goToAvatarList.toggle()
                }
                RoundButton(title: "Repo List") {
                    goToRepoList.toggle()
                }
            }
            .padding(.horizontal, 16)
            .fullScreenCover(isPresented: $goToEmojiList) {
                EmojiListView(emojis: viewModel.emojis)
            }
            .fullScreenCover(isPresented: $goToAvatarList) {
                AvatarListView()
            }
            .fullScreenCover(isPresented: $goToRepoList) {
                RepositoryListView()
            }
        }
    }
}

#Preview {
    MainView(viewModel: EmojiListViewModel())
}

    
