//
//  Reachability.swift
//  InspectIT
//
//  Created by Prasham Jain on 23/06/24.
//

import Network
import SwiftUI

class Reachability: ObservableObject {
    private var monitor: NWPathMonitor
    private var queue: DispatchQueue
    @Published var isConnected: Bool = true

    init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue(label: "NetworkMonitor")

        self.monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = (path.status == .satisfied)
            }
        }
        self.monitor.start(queue: self.queue)
    }
}

