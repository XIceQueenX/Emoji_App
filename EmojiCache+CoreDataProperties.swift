//
//  EmojiCache+CoreDataProperties.swift
//  
//
//  Created by Gloria Martins on 06/11/2024.
//
//

import Foundation
import CoreData


extension EmojiCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmojiCache> {
        return NSFetchRequest<EmojiCache>(entityName: "EmojiCache")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: Data?

}
