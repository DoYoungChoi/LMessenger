//
//  SearchViewModel.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation
import Combine

class SerchViewModel: ObservableObject {
    
    enum Action {
        case requestQuery(String)
        case clearSearchResult
        case clearSearchText
    }
    
    @Published var searchText: String = ""
    @Published var searchResults: [User] = []
    @Published var shouldBecomeFirstResponder: Bool = false
    
    private let userId: String
    private let container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        container: DIContainer,
        userId: String
    ) {
        self.userId = userId
        self.container = container
        
        bind()
    }
    
    func bind() {
        $searchText
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                if text.isEmpty {
                    self?.send(action: .clearSearchResult)
                } else {
                    self?.send(action: .requestQuery(text))
                }
            }
            .store(in: &subscriptions)
    }
    
    func send(action: Action) {
        switch action {
        case .requestQuery(let query):
            container.services.userService.filterUsers(with: query, userId: userId)
                .sink { completion in
                } receiveValue: { [weak self] users in
                    self?.searchResults = users
                }
                .store(in: &subscriptions)
        case .clearSearchResult:
            searchResults = []
        case .clearSearchText:
            searchText = ""
            shouldBecomeFirstResponder = false
            searchResults = []
        }
    }
}
