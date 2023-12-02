//
//  SearchView.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject private var container: DIContainer
    @StateObject var searchViewModel: SerchViewModel
    
    var body: some View {
        VStack {
            topView
            
            if searchViewModel.searchResults.isEmpty {
                RecentSearchView()
            } else {
                List {
                    ForEach(searchViewModel.searchResults) { user in
                        HStack(spacing: 8) {
                            URLImageView(urlString: user.profileURL)
                                .frame(width: 26, height: 26)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            Text(user.name)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.bkText)
                        }
                        .listRowInsets(.init())
                        .listRowSeparator(.hidden)
                        .padding(.horizontal, 30)
                    }
                }
                .listStyle(.plain)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
    
    var topView: some View {
        HStack(spacing: 0) {
            Button {
                container.navigationRouter.pop()
            } label:{
                Image("back_search")
            }
            
            SearchBar(text: $searchViewModel.searchText, 
                      shouldBecomeFirstResponder: $searchViewModel.shouldBecomeFirstResponder) {
                setSearchResultWithContext()
            }
            
            Button {
                searchViewModel.send(action: .clearSearchText)
            } label: {
                Image("close_search")
            }
        }
        .padding(.horizontal, 20)
    }
    
    func setSearchResultWithContext() {
        let result = SearchResult(context: moc)
        result.id = UUID().uuidString
        result.name = searchViewModel.searchText
        result.date = Date()
        
        try? moc.save()
    }
}

#Preview {
    let container = DIContainer(services: StubService())
    
    return SearchView(searchViewModel: .init(container: container, userId: "user"))
        .environmentObject(DIContainer(services: StubService()))
}
