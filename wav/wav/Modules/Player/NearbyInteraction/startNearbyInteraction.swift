//
//  startNearbyInteraction.swift
//  wav
//
//  Created by Ilyes Djari on 05/06/2023.
//

import Foundation
import NearbyInteraction
import NotificationBannerSwift

extension PlayerViewController {
    public func startup() {
        print("called")
        // Create the NISession.
        session = NISession()
        // Set the delegate.
        session?.delegate = self
        // Because the session is new, reset the token-shared flag.
        sharedTokenWithPeer = false
        // If `connectedPeer` exists, share the discovery token, if needed.
        if connectedPeer != nil && mpc != nil {
            if let myToken = session?.discoveryToken {
                if !sharedTokenWithPeer {
                    shareMyDiscoveryToken(token: myToken)
                }
                guard let peerToken = peerDiscoveryToken else {
                    return
                }
                let config = NINearbyPeerConfiguration(peerToken: peerToken)
                session?.run(config)
            } else {
                NotificationBanner.showErrorBanner(
                    title: "Error",
                    subtitle: "Unable to get self discovery token, is this session invalidated?")
            }
        } else {
            startupMPC()
            currentDistanceDirectionState = .unknown
        }
    }
}
