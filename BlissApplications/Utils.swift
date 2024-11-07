//
//  Utils.swift
//  BlissApplications
//
//  Created by Gloria Martins on 07/11/2024.
//

import Foundation
import Alamofire

public struct AvatarData: Decodable{
    let login: String
    let id: String
    let data: Data?
}

public struct Avatar: Decodable{
    let login: String
    let id: Int
    let avatar_url: String
}

struct Repository: Decodable, Identifiable {
    var id: Int
    var full_name: String
    var `private`: Bool
}

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

func getAvatarFromAPI(user: String) async throws -> AvatarData? {
    let response = try await AF.request("https://api.github.com/users/\(user)")
        .serializingDecodable(Avatar.self)
        .value
    
    let login = response.login
    let id = response.id
    let avatarUrlString = response.avatar_url
    
    let persistenceController = PersistenceController.shared
    if let avatarUrl = URL(string: avatarUrlString) {
        if let avatarData = await downloadImage(from: avatarUrl) {
            print(avatarData)
            
            persistenceController.uploadAvatarToCoreData(emoji: AvatarData(login: login, id: String(id), data: avatarData))
        }
    }
    
    return nil
}

