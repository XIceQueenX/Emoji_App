//
//  EmojiListViewModel.swift
//  BlissApplications
//
//  Created by Gloria Martins on 06/11/2024.
//

import Foundation
import UIKit

class MainViewViewModel : ObservableObject{
    @Published var emojis = [EmojiCache]()
    @Published var searchText: String = ""
    
    private let persistenceController = PersistenceController.shared
    
    init(){
        loadEmojis()
    }
    
    func getAvatar() {
        Task {
            await getAvatarFromAPI(user: searchText)
        }
    }
    
    func loadEmojis() {
        Task {
            let fetchedEmojis = await persistenceController.getEmojis()
            DispatchQueue.main.async {
                self.emojis = fetchedEmojis ?? []
            }
        }
    }

    
    func getRandomEmoji() -> EmojiCache? {
        return emojis.randomElement()
    }
    
}
