//
//  URLImageViewModel.swift
//  LMessenger
//
//  Created by dodor on 11/29/23.
//

import UIKit
import Combine

class URLImageViewModel: ObservableObject {
    
    // 로딩이 시작이 되었거나 이미 이미지를 가져온 경우 다시 가져오지 않도록 체크하는 프로퍼티
    var loadOrSuccess: Bool {
        return loading || loadedImage != nil
    }
    
    @Published var loadedImage: UIImage? = nil
    
    private var container: DIContainer
    private var urlString: String
    private var loading: Bool = false
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        container: DIContainer,
        urlString: String
    ) {
        self.container = container
        self.urlString = urlString
    }
    
    func start() {
        guard !urlString.isEmpty else { return }
        
        loading = true
        
        container.services.imageCacheService.image(for: urlString)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.loading = false
                self?.loadedImage = image
            }
            .store(in: &subscriptions)
    }
    
}
