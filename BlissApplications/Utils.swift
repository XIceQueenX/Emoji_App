//
//  Utils.swift
//  BlissApplications
//
//  Created by Gloria Martins on 07/11/2024.
//

import Foundation
import Alamofire

//Holds API Response
public struct AvatarResponse: Decodable{
    let login: String
    let id: Int
    let avatar_url: String
}

//Holds Repositories Response
struct Repository: Decodable {
    var id: Int
    var full_name: String
    var `private`: Bool
}

func downloadImage(from urlString: String) async -> Data? {
    guard let url = URL(string: urlString) else {
        return nil
    }
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    } catch {
        print("Failed downloadImage \(url)\(error.localizedDescription)")
        return nil
    }
}


func getEmojisFromAPI() async -> [String: Data]? {
    do {
        let response = try await AF.request("https://api.github.com/emojis")
            .serializingDecodable([String: String].self)
            .value
        
        var emojiDataDictionary = [String: Data]()
        
        for (key, value) in response {
            if let imageData = await downloadImage(from: value) {
                emojiDataDictionary[key] = imageData
            } else {
                print("Failed to download image for \(key)")
            }
        }
        return emojiDataDictionary
    } catch {
        print("Failed getEmojisAPI\(error.localizedDescription)")
        return nil
    }
}


func getAvatarFromAPI(user: String) async {
    do {
        let response = try await AF.request("https://api.github.com/users/\(user)")
            .serializingDecodable(AvatarResponse.self)
            .value
        
        let avatarUrlString = response.avatar_url
        
        if let avatarData = await downloadImage(from: avatarUrlString) {
            let persistenceController = PersistenceController.shared
            persistenceController.uploadAvatarToCoreData(login: response.login, id: String(response.id), data: avatarData)
        }
        
    } catch {
        print("Failed to get avatar from API: \(error.localizedDescription)")
    }
}

