//
//  UserInteractionViewController+NISessionDelegate.swift
//  wav
//
//  Created by Ilyes Djari on 17/05/2023.
//

import Foundation
import NearbyInteraction
import MultipeerConnectivity

extension UserInteractionViewController {
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        guard let peerToken = peerDiscoveryToken else {
            fatalError("don't have peer token")
        }

        // Find the right peer.
        let peerObj = nearbyObjects.first { (obj) -> Bool in
            return obj.discoveryToken == peerToken
        }

        guard let nearbyObjectUpdate = peerObj else {
            return
        }
        let nextState = getDistanceDirectionState(from: nearbyObjectUpdate)
        updateVisualization(from: currentDistanceDirectionState, to: nextState, with: nearbyObjectUpdate)
        currentDistanceDirectionState = nextState
    }

    func session(
        _ session: NISession,
        didRemove nearbyObjects: [NINearbyObject],
        reason: NINearbyObject.RemovalReason) {
        guard let peerToken = peerDiscoveryToken else {
            fatalError("don't have peer token")
        }
        // Find the right peer.
        let peerObj = nearbyObjects.first { (obj) -> Bool in
            return obj.discoveryToken == peerToken
        }

        if peerObj == nil {
            return
        }

        currentDistanceDirectionState = .unknown

        switch reason {
        case .peerEnded:
            // The peer token is no longer valid.
            peerDiscoveryToken = nil
            // The peer stopped communicating, so invalidate the session because
            // it's finished.
            session.invalidate()
            // Restart the sequence to see if the peer comes back.
            startup()
            // Update the app's display.
            print("Peer ended")
        case .timeout:

            // The peer timed out, but the session is valid.
            // If the configuration is valid, run the session again.
            if let config = session.configuration {
                session.run(config)
            }
            print("Peer Timeout")
        default:
            fatalError("Unknown and unhandled NINearbyObject.RemovalReason")
        }
    }

    func sessionWasSuspended(_ session: NISession) {
        currentDistanceDirectionState = .unknown
        print("Session Suspended")
    }

    func sessionSuspensionEnded(_ session: NISession) {
        // Session suspension ended. The session can now be run again.
        if let config = self.session?.configuration {
            session.run(config)
        } else {
            // Create a valid configuration.
            startup()
        }
        if let peerDisplayName, let user {
            searchLabel.text = "\(peerDisplayName) of \(user)"
        } else {
            searchLabel.text = "User is neary!"
        }
    }

    func session(_ session: NISession, didInvalidateWith error: Error) {
        currentDistanceDirectionState = .unknown

        // If the app lacks user approval for Nearby Interaction, present
        // an option to go to Settings where the user can update the access.
        if case NIError.userDidNotAllow = error {
            if #available(iOS 15.0, *) {
                // In iOS 15.0, Settings persists Nearby Interaction access.
                print("Nearby Interactions access required. You can change access for Wav in Settings.")
                // Create an alert that directs the user to Settings.
                let accessAlert = UIAlertController(title: "Access Required",
                                                    message: """
                                                    Wav requires access to Nearby Interactions for this function.
                                                    This will make it possible to discover other users.
                                                    Nearby Interactions access in Settings.
                                                    """,
                                                    preferredStyle: .alert)
                accessAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                accessAlert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
                    // Send the user to the app's Settings to update Nearby Interactions access.
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                }))

                // Display the alert.
                present(accessAlert, animated: true, completion: nil)
            } else {
                // Before iOS 15.0, ask the user to restart the app so the
                // framework can ask for Nearby Interaction access again.
                print("Nearby Interactions access required. Restart Wav to allow access.")
            }
            return
        }
        // Recreate a valid session.
        startup()
    }
}
