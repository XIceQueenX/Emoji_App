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

    /*public func getEmojis() async throws -> [EmojiCache] {
        if let localEmojis = fetchEmojisFromDatabase(), !localEmojis.isEmpty {
            return localEmojis
        }

        let emojisFromCoreData = uploadEmojisToCoreData(emoji: try await getEmojisFromAPI())

        return emojisFromCoreData ?? []
    }*/
    
    public func getEmojis() async throws -> [EmojiData] {
        // First try to fetch emojis from the local database (Core Data)
        if let localEmojis = fetchEmojisFromDatabase(), !localEmojis.isEmpty {
            // If emojis are found, map them to EmojiData and return
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

