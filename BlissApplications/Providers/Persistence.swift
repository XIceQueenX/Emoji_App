//
//  Persistence.swift
//  BlissApplications
//
//  Created by Gloria Martins on 06/11/2024.
//


import Foundation
import CoreData
import Alamofire

class PersistenceController {
    static let shared = PersistenceController()
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    let container: NSPersistentContainer
    /*static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        
        // Create mock EmojiCache
        let viewContext = controller.container.viewContext
        
        let emoji = EmojiCache(context: viewContext)
        emoji.name = "Smile"
        
        // Save image data as mock (using system image here)
        if let smileImage = UIImage(systemName: "smiley.fill") {
            emoji.url = smileImage.pngData() // Convert the image to Data and assign to `url`
        }
        
        // Save to Core Data
        do {
            try viewContext.save()
        } catch {
            fatalError("Unresolved error \(error), \(error.localizedDescription)")
        }
        
        return controller
    }()*/
    
    
    static var preview: PersistenceController = {
            let controller = PersistenceController(inMemory: true)

                let myList = EmojiCache(context: controller.container.viewContext)
                myList.name = "Test List"
        
                  
        
        do {
            try controller.container.viewContext.save()
        } catch {
            fatalError("Unresolved error \(error), \(error.localizedDescription)")
        }
            return controller
        }()
    
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
    
    public func getEmojis() async -> [EmojiCache]? {
        if let localEmojis = fetchEmojisFromDatabase(), !localEmojis.isEmpty {
            return localEmojis
        }
        
        if let emojisFromAPI = await getEmojisFromAPI(), !emojisFromAPI.isEmpty {
            let emojisFromCoreData = await uploadEmojisToCoreData(emoji: emojisFromAPI)
            return emojisFromCoreData
        }
        return nil
    }
    
    
    public func fetchEmojisFromDatabase() -> [EmojiCache]? {
        let fetchRequest: NSFetchRequest<EmojiCache> = EmojiCache.fetchRequest()
        
        do {
            let emojiCaches = try context.fetch(fetchRequest)
            return emojiCaches
        } catch {
            print("Erro fetchEmojisFromDatabase \(error)")
            
            return nil
        }
    }
    
    public func fetchAvatarsFromDatabase() -> [AvatarCache]? {
        let fetchRequest: NSFetchRequest<AvatarCache> = AvatarCache.fetchRequest()
        
        do {
            let avatars = try context.fetch(fetchRequest)
            return avatars
        } catch {
            print("Erro fetchAvatarsFromDatabase \(error.localizedDescription)")
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
            print("Error doesAvatarExist \(error)")
            return false
        }
    }
    
    func removeAvatar(avatar: AvatarCache)  {
        guard let id = avatar.id else {return}
        
        let fetchRequest: NSFetchRequest<AvatarCache> = AvatarCache.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let fetchedAvatars = try context.fetch(fetchRequest)
            
            if let avatarRemoved = fetchedAvatars.first {
                context.delete(avatarRemoved)
                
                try context.save()
            }
        } catch {
            print("Failed removeAvatar \(error.localizedDescription)")
        }
    }
    
    
    func uploadAvatarToCoreData(login: String, id: String, data: Data) {
        let context = PersistenceController.shared.context
        
        if doesAvatarExist(withId: id) {
            return
        }
        
        let avatar = AvatarCache(context: context)
        avatar.login = login
        avatar.id = id
        avatar.data = data
        
        do {
            try context.save()
        } catch {
            print("Failed uploadAvatarToCoreData \(error.localizedDescription)")
        }
    }
    
    public func uploadEmojisToCoreData(emoji: [String: Data])  -> [EmojiCache]? {
        var emojis = [EmojiCache]()
        
        for (key, value) in emoji {
            let emoji = EmojiCache(context: context)
            emoji.name = key
            emoji.url = value
            emojis.append(emoji)
        }
        
        do {
            try context.save()
        } catch {
            print("Erro uploadEmojisToCoreData \(error.localizedDescription)")
            return nil
        }
        
        return emojis
    }
}

