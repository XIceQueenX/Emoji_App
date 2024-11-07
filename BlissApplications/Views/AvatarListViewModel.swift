//
//  EmojiListViewModel.swift
//  BlissApplications
//
//  Created by Gloria Martins on 06/11/2024.
//

import Foundation
class AvatarListViewModel : ObservableObject{
    @Published var avatars = [AvatarData]()
    
    private let persistenceController = PersistenceController.shared
    
    init(){
        loadAvatar()
    }
    
    func loadAvatar() {
        Task {
            do {
                let fetchedEmojis = try await persistenceController.getAvatars()
                DispatchQueue.main.async {
                    self.avatars = fetchedEmojis
                }
            } catch {
                print("failed")
            }
        }
    }
    
    
    func removeItem(index:Int){
        do {
            persistenceController.removeAvatar(avatar: avatars[index])
            avatars.remove(at: index)
        } catch {
            print("Failed to remove avatar from database")
        }
    }
}

