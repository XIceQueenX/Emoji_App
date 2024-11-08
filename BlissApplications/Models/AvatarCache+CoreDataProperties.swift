//
//  AvatarCache+CoreDataProperties.swift
//  
//
//  Created by Gloria Martins on 08/11/2024.
//
//

import Foundation
import CoreData


extension AvatarCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AvatarCache> {
        return NSFetchRequest<AvatarCache>(entityName: "AvatarCache")
    }

    @NSManaged public var data: Data?
    @NSManaged public var id: String?
    @NSManaged public var login: String?

}
