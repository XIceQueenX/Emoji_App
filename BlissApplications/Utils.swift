//
//  Utils.swift
//  BlissApplications
//
//  Created by Gloria Martins on 07/11/2024.
//

import Foundation
import Alamofire

func downloadImage(from url: URL) -> Data? {
   do {
       let data = try Data(contentsOf: url)
       return data
   } catch {
       print("Failed to download image \(url) \(error)")
       return nil
   }
}

//Chaged this to public
public func getEmojisFromAPI() async throws -> [Emoji]{
    let response = try await AF.request("https://api.github.com/emojis")
        .serializingDecodable([String: String].self)
        .value
    
    let emojis = response.map { (key, value) -> Emoji in
        return Emoji(identification: key, url: value)
    }

    return emojis
}
