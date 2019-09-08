//
//  Connectivity.swift
//  TheMovieApp
//
//  Created by Swati Wadhera on 08/09/19.
//  Copyright © 2019 Swati Wadhera. All rights reserved.
//

import UIKit
import Reachability

class Connectivity {
    
    static let reachability = Reachability()!
    static var isConnectedToInternet : Bool {
        return self.reachability.connection != .none
    }
    
    static func initialize() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try self.reachability.startNotifier()
        }  catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc static func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        }
    }
    
}
