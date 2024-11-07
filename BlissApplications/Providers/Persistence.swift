//
//  Persistence.swift
//  BlissApplications
//
//  Created by Gloria Martins on 06/11/2024.
//


import Foundation
import CoreData
import Alamofire

struct EmojiData  {
    var name: String
    var imageData: Data?
}

public struct Emoji: Codable {
    let identification: String
    let url: String
}


class PersistenceController {
    static let shared = PersistenceController()
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "BlissApplications")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    public func getEmojis() async throws -> [EmojiData] {
        if let localEmojis = fetchEmojisFromDatabase(), !localEmojis.isEmpty {
            return localEmojis.map { EmojiData(name: $0.name ?? "", imageData: $0.url) }
        }
        
        let emojisFromAPI = try await getEmojisFromAPI()
        
        let emojisFromCoreData = uploadEmojisToCoreData(emoji: emojisFromAPI)
        return emojisFromCoreData?.map { EmojiData(name: $0.name ?? "", imageData: $0.url) } ?? []
    }
    
    public func fetchEmojisFromDatabase() -> [EmojiCache]? {
        let fetchRequest: NSFetchRequest<EmojiCache> = EmojiCache.fetchRequest()
        
        do {
            let emojiCaches = try context.fetch(fetchRequest)
            return emojiCaches
        } catch {
            print("Erro fetching emojis from core daqta")
            
            return nil
        }
    }
    
    
    public func getAvatars() async throws -> [AvatarData] {
        if let localAvatars = fetchAvatarsFromDatabase(), !localAvatars.isEmpty {
            return localAvatars.map { AvatarData(login: $0.login! ?? "", id: $0.id ?? "",  data: $0.data) }
        }
        return []
    }
    
    //why not avatarDaTA????
    public func fetchAvatarsFromDatabase() -> [AvatarCache]? {
        let fetchRequest: NSFetchRequest<AvatarCache> = AvatarCache.fetchRequest()
        
        do {
            let avatars = try context.fetch(fetchRequest)
            return avatars
        } catch {
            print("Erro fetching emojis from core daqta")
            return nil
        }
    }
    
    public func doesAvatarExist(withId id: String) -> Bool {
        let fetchRequest: NSFetchRequest<AvatarCache> = AvatarCache.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Error fetching avatars: \(error)")
            return false
        }
    }
    
    func removeAvatar(avatar: AvatarData)  {
            let fetchRequest: NSFetchRequest<AvatarCache> = AvatarCache.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "id == %@", avatar.id)
            
            do {
                let fetchedAvatars = try context.fetch(fetchRequest)
                
                if let avatarToDelete = fetchedAvatars.first {
                    context.delete(avatarToDelete)
                    
                    try context.save()
                }
            } catch {
                print("Failed \(error)")
            }
        }
    
    public func uploadAvatarToCoreData(emoji: AvatarData) {
        if doesAvatarExist(withId: emoji.id) {
            return
        }
        
        let newItem = AvatarCache(context: context)
        newItem.id = emoji.id
        newItem.login = emoji.login
        newItem.data = emoji.data
        
        do {
            try context.save()
        } catch {
            print("Erro uploading emojis to core daqta")
        }
    }
    
    public func uploadEmojisToCoreData(emoji: [Emoji]) -> [EmojiCache]? {
        var emojis = [EmojiCache]()
        
        for emojiItem in emoji {
            let newItem = EmojiCache(context: context)
            newItem.name = emojiItem.identification
            
            if let url = URL(string: emojiItem.url), let imageData = downloadImage(from: url) {
                newItem.url = imageData
            }else{
                newItem.url = Data()
            }
            
            emojis.append(newItem)
        }
        
        do {
            try context.save()
        } catch {
            print("Erro uploading emojis to core daqta")
            return nil
        }
        
        return emojis
    }
}

