//
//  UserInteractionViewController.swift
//  wav
//
//  Created by Ilyes Djari on 17/05/2023.
//

import UIKit
import NearbyInteraction
import MultipeerConnectivity
import NotificationBannerSwift

class UserInteractionViewController: UIViewController, NISessionDelegate {

    // Properties
    var session: NISession?
    var peerDiscoveryToken: NIDiscoveryToken?
    var mpc: MPCSession?
    var connectedPeer: MCPeerID?
    let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    var sharedTokenWithPeer = false
    var peerDisplayName: String?
    let nearbyDistanceThreshold: Float = 0.3
    var currentDistanceDirectionState: DistanceDirectionState = .unknown
    var lastVibrationDistance: Float?
    var viewIsSeen: Bool = false
    var user: String?
    var userId: String? {
        didSet {
            if let unwrappedUserId = userId {
                updateNotificationField(withUserID: unwrappedUserId)
            }
        }
    }

    // Outlets
    @IBOutlet weak var nearbyArrow: UIImageView!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var detailDistanceLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        startup()
        viewIsSeen = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        viewIsSeen = false
    }

    func startup() {
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

    func animate(
        from currentState: DistanceDirectionState,
        to nextState: DistanceDirectionState,
        with peer: NINearbyObject) {
        // If the app transitions from unavailable, present the app's display
        // and hide the user instructions.
        if currentState == .unknown && nextState != .unknown {
        }
        if let direction = peer.direction {
            // Calculate azimuth (rotation around y axis)
            nearbyArrow.isHidden = false
            let azimuth = atan2(direction.x, direction.y)
            let degrees = azimuth.radiansToDegrees
            var directionText = ""
            let directionThreshold: CGFloat = 15.0

            if CGFloat(degrees) < -directionThreshold {
                directionText = "To your left"
            } else if CGFloat(degrees) > directionThreshold {
                directionText = "To your right"
            } else if abs(CGFloat(degrees)) <= directionThreshold {
                directionText = "In front of you"
            } else {
                directionText = "Behind you"
            }
            DispatchQueue.main.async {
                // Apply rotation
                self.nearbyArrow.transform = CGAffineTransform(rotationAngle: CGFloat(degrees.degreesToRadians))
                // Update directionLabel text
                self.directionLabel.text = directionText
            }
        }

        if let distance = peer.distance {
            detailDistanceLabel.text = String(format: "%0.2f m", distance)
            if distance <= 0.75, viewIsSeen {
                // Keep vibrating
                impactGenerator.impactOccurred()
            } else if distance <= 1.5, viewIsSeen {
                // Vibrate once
                // Check if the last vibration was not at this distance
                if lastVibrationDistance == nil || lastVibrationDistance! > 1.5 {
                    impactGenerator.impactOccurred()
                    lastVibrationDistance = distance
                }
            } else {
                // Reset last vibration distance
                lastVibrationDistance = nil
            }
        }

        // Don't update visuals if the peer device is unavailable or out of the
        // U1 chip's field of view.
        if nextState == .outOfFOV || nextState == .unknown {
            detailDistanceLabel.text = "Move your phone around"
            directionLabel.text = ""
            return
        }
    }

    func updateVisualization(
        from currentState: DistanceDirectionState,
        to nextState: DistanceDirectionState,
        with peer: NINearbyObject) {
        // Invoke haptics on "peekaboo" or on the first measurement.
        if currentState == .notCloseUpInFOV && nextState == .closeUpInFOV || currentState == .unknown {
            impactGenerator.impactOccurred()
        }

        // Animate into the next visuals.
        UIView.animate(withDuration: 0.3, animations: {
            self.animate(from: currentState, to: nextState, with: peer)
        })
    }

    func updateInformationLabel(description: String) {
        UIView.animate(withDuration: 0.3, animations: {
        })
    }
}
