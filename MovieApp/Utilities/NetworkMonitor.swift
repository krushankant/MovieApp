//
//  NetworkMonitor.swift
//  MovieApp
//

import Foundation
import Network

@MainActor
final class NetworkMonitor: ObservableObject {
    
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    @Published private(set) var isConnected: Bool = false
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                guard let self else { return }
                self.isConnected = path.status == .satisfied
                print("isConnected: \(self.isConnected)")
            }
        }
        monitor.start(queue: queue)
    }
}


