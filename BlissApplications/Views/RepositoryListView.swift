//
//  RepositoryListView.swift
//  BlissApplications
//
//  Created by Gloria Martins on 07/11/2024.
//

import SwiftUI

struct RepositoryListView: View {
    @StateObject var viewModel = RepositoryListViewModel()
    @State private var isLastRowVisible = false
    
    var body: some View {
        ZStack{
            Color(.background).ignoresSafeArea()
            List {
                ForEach(viewModel.repositories.indices, id: \.self) { index in
                    Text(viewModel.repositories[index].full_name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .listRowBackground(Color.clear)
                    
                    if index == viewModel.repositories.count - 1 && !viewModel.isLoading{
                        Color.clear
                            .onAppear {
                                viewModel.fetchRepositories()
                            }
                    }
                }
            }.listStyle(PlainListStyle())
            .listRowBackground(Color.green)
            .scrollContentBackground(.hidden)
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .onAppear {
            viewModel.fetchRepositories()
        }.navigationTitle("Repositories")
    }
}

#Preview {
    RepositoryListView()
}
