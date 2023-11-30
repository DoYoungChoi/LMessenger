//
//  NavigationRouter.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation

class NavigationRouter: ObservableObject {
    @Published var destination: [NavigationDestination] = []
    
    func push(to view: NavigationDestination) {
        destination.append(view)
    }
    
    func pop() {
        destination.removeLast()
    }
    
    func popToRootView() {
        destination = []
    }
}
