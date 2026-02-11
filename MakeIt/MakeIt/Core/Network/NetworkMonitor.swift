//
//  Networking.swift
//  WalletCare
//
//  Created by Noah tesson on 12/09/2025.
//

import Network

final class NetworkMonitor: INetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private(set) var isConnected: Bool = true
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    deinit { monitor.cancel() }
}
