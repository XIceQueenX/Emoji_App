//
//  RepositoryListViewModel.swift
//  BlissApplications
//
//  Created by Gloria Martins on 07/11/2024.
//

import Foundation
import Alamofire
import SwiftUI

class RepositoryListViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isLoading = false
    @Published var currentPage = 1
    let pageSize = 10
    
    func fetchRepositories() {
        guard !isLoading else { return }
        isLoading = true
        
        let url = "https://api.github.com/users/apple/repos"
        let parameters: [String: Any] = [
            "page": currentPage,
            "size": pageSize
        ]
        
        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: [Repository].self){ response in
                switch response.result {
                case .success(let repos):
                    self.repositories.append(contentsOf: repos)
                    self.isLoading = false
                    self.currentPage += 1
                case .failure(let error):
                    print("Error fetching repositories: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
    }
}
