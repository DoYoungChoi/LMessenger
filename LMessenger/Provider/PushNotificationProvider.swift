//
//  PushNotificationProvider.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation
import Combine

protocol PushNotificationProviderType {
    func sendPushNotification(object: PushObject) -> AnyPublisher<Bool, Never>
}

class PushNotificationProvider: PushNotificationProviderType {
    
    private let serverURL: URL = URL(string: "https://fcm.googleapis.com/fcm/send")!
    private let serverKey = "AAAAHkEOYT4:APA91bHH4kMPjTSxFxnihq2yejoNOBuMd91JZaM6n4OUd2NA4G_UJQe1h5jPzUWT4dIbqQxL4Nyt92As1PdKb0_OOC_cjodLoSQbR6mkUCFoKitMfEey-stBEP1jsnSGtO-CjqtM_rEU"
    
    func sendPushNotification(object: PushObject) -> AnyPublisher<Bool, Never> {
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(object)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { _ in true }
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
}

