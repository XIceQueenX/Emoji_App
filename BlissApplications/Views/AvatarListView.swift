//
//  AvatarListView.swift
//  BlissApplications
//
//  Created by Gloria Martins on 07/11/2024.
//

import SwiftUI

struct AvatarListView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: AvatarListViewModel = AvatarListViewModel()
    
    let squareSize: CGFloat = 80
    let numberOfColumns = 4
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: numberOfColumns)
    }
    
    public var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            if viewModel.avatars.isEmpty{
                Text("No data")
            }
            else{
                ScrollView {
                    LazyVGrid(columns: self.columns) {
                        ForEach(viewModel.avatars.indices, id: \.self) { index in
                            if let imageData = viewModel.avatars[index].data, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: squareSize, height: squareSize)
                                    .onTapGesture {
                                        viewModel.removeItem(index: index)
                                    }
                            } else {
                                Text("No Image")
                                    .frame(width: squareSize, height: squareSize)
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle(Text("Avatar List"))
            }
        }
    }
}

#Preview {
    let persistenceController = PersistenceController.shared
    
    AvatarListView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    
}
