//
//  UploadService.swift
//  LMessenger
//
//  Created by dodor on 11/29/23.
//

import Foundation
import Combine

protocol UploadServiceType {
    func uploadImage(source: UploadSourceType, data: Data) async throws -> URL
    func uploadImage(source: UploadSourceType, data: Data) -> AnyPublisher<URL, ServiceError>
}

class UploadService: UploadServiceType {
    
    private let provider: UploadProviderType
    
    init(provider: UploadProviderType) {
        self.provider = provider
    }
    
    func uploadImage(source: UploadSourceType, data: Data) async throws -> URL {
        let url = try await provider.upload(path: source.path, data: data, fileName: UUID().uuidString)
        return url
    }
    
    func uploadImage(source: UploadSourceType, data: Data) -> AnyPublisher<URL, ServiceError> {
        provider.upload(path: source.path, data: data, fileName: UUID().uuidString)
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
}

class StubUploadService: UploadServiceType {
    func uploadImage(source: UploadSourceType, data: Data) async throws -> URL {
        URL(string: "")!
    }
    
    func uploadImage(source: UploadSourceType, data: Data) -> AnyPublisher<URL, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
