//
//  MainView.swift
//  BlissApplications
//
//  Created by Gloria Martins on 07/11/2024.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewViewModel
    @State private var selectedEmoji: EmojiCache?
    
    var body: some View {
        NavigationView{
            ZStack {
                Color(.background).ignoresSafeArea()
                VStack(spacing: 16) {
                    
                    if let emoji = selectedEmoji {
                        EmojiImage(emoji: emoji)
                            .padding()
                    }
                    
                    TextNavigationLink(title: "Random Emoji").onTapGesture {
                        selectedEmoji = viewModel.getRandomEmoji()
                    }
                
                    NavigationLink(destination:  EmojiListView(emojis: viewModel.emojis)) {
                        TextNavigationLink(title: "Emoji List")
                    }
                    
                    RoundTextField(text: $viewModel.searchText, placeholder: "Search by username", onClick: {
                        viewModel.getAvatar()
                    })
                    
                    NavigationLink(destination:  AvatarListView()) {
                        TextNavigationLink(title: "Avatar List")
                    }
                    
                    NavigationLink(destination:  RepositoryListView()) {
                        TextNavigationLink(title: "Repository List")
                    }
                }
                .padding()
            }
        }
    }
}
    
    #Preview {
        MainView(viewModel: MainViewViewModel())
    }
    
    
