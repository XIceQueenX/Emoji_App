//
//  EmojiListViewModel.swift
//  BlissApplications
//
//  Created by Gloria Martins on 06/11/2024.
//

import Foundation
class EmojiListViewModel : ObservableObject{
    @Published var emojis = [EmojiData]()
    
    private let persistenceController = PersistenceController.shared
    
    init(){
        loadEmojis()
    }
    
    func loadEmojis() {
        Task {
            do {
                let fetchedEmojis = try await persistenceController.getEmojis()
                DispatchQueue.main.async {
                    self.emojis = fetchedEmojis
                }
            } catch {
                print("failed")
            }
        }
    }
    
    func getRandomEmoji() -> EmojiData? {
        return emojis.randomElement()
    }
    
    
    func removeEmojiItem(index: Int){
        
    }
}
