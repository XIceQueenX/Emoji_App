//
//  EmojiListViewModel.swift
//  BlissApplications
//
//  Created by Gloria Martins on 06/11/2024.
//

import Foundation

class AvatarListViewModel : ObservableObject{
    @Published var avatars = [AvatarCache]()
    
    private let persistenceController = PersistenceController.shared
    
    init(){
        loadAvatar()
    }
    
    func loadAvatar() {
        do {
            if let fetchedEmojis =  persistenceController.fetchAvatarsFromDatabase(), !fetchedEmojis.isEmpty{
                DispatchQueue.main.async {
                    self.avatars = fetchedEmojis
                }
            }
        } catch {
            print("failed")
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

