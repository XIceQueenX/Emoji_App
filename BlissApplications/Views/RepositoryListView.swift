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
            Color(.accent).ignoresSafeArea()
            NavigationView {
                List {
                    ForEach(viewModel.repositories.indices, id: \.self) { index in
                        Text(viewModel.repositories[index].full_name)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(GeometryReader { geometry in
                                Color.clear
                                    .onChange(of: geometry.frame(in: .global).minY) { minY in
                                        if index == viewModel.repositories.count - 1 {
                                            let screenHeight = UIScreen.main.bounds.height
                                            if minY < screenHeight {
                                                isLastRowVisible = true
                                            } else {
                                                isLastRowVisible = false
                                            }
                                        }
                                    }
                            })
                            .listRowSeparator(.hidden, edges: .all)
                    }
                    
                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                            Spacer()
                        }
                        .padding()
                    }
                }
                .onAppear {
                    viewModel.fetchRepositories()
                }
                .onChange(of: isLastRowVisible) { visible in
                    if visible && !viewModel.isLoading {
                        viewModel.fetchRepositories()
                    }
                }
                .navigationTitle("Repositories")
            }
        }
    }
}

#Preview {
    RepositoryListView()
}
