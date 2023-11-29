//
//  UploadService.swift
//  LMessenger
//
//  Created by dodor on 11/29/23.
//

import Foundation

protocol UploadServiceType {
    func uploadImage(source: UploadSourceType, data: Data) async throws -> URL
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
}

class StubUploadService: UploadServiceType {
    func uploadImage(source: UploadSourceType, data: Data) async throws -> URL {
        URL(string: "")!
    }
}
