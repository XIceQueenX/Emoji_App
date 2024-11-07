//
//  BlissApplicationsApp.swift
//  BlissApplications
//
//  Created by Gloria Martins on 06/11/2024.
//

import SwiftUI

@main
struct BlissApplicationsApp: App {
    
    @StateObject private var emojiListViewModel = EmojiListViewModel()

    var body: some Scene {
        WindowGroup {
            MainView(viewModel: emojiListViewModel)
        }
    }
}
