//
//  ContentView.swift
//  BlissApplications
//
//  Created by Gloria Martins on 06/11/2024.
//

import SwiftUI
import CoreData

extension EmojiCache: Identifiable { }

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var mutableEmojis: [EmojiCache] = []

    var body: some View {
        NavigationView {
            List($mutableEmojis, id: \.self) { emoji in
                VStack(alignment: .leading) {
                    if let imageData = emoji.url.wrappedValue, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                    } else {
                        Text("No image")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                }
                .padding()
            }
            .navigationTitle("Emojis")
            .onAppear {
                loadEmojis()
            }
        }
    }
 
    
    private func loadEmojis() {
            Task {
                do {
                    let emojis = try await PersistenceController.shared.getEmojis()
                    mutableEmojis = emojis
                } catch {
                    print("Failed to load emojis: \(error)")
                }
            }
        }
    
    
    
    
    
    
    
    /*private func deleteItems(offsets: IndexSet) {
     withAnimation {
     offsets.map { items[$0] }.forEach(viewContext.delete)
     
     do {
     try viewContext.save()
     } catch {
     // Replace this implementation with code to handle the error appropriately.
     // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
     let nsError = error as NSError
     fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
     }
     }*/
    
}

#Preview {
    /*ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)*/
}
