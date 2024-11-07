//
//  Utils.swift
//  BlissApplications
//
//  Created by Gloria Martins on 07/11/2024.
//

import Foundation

func downloadImage(from url: URL) -> Data? {
   do {
       let data = try Data(contentsOf: url)
       return data
   } catch {
       print("Failed to download image \(url) \(error)")
       return nil
   }
}
