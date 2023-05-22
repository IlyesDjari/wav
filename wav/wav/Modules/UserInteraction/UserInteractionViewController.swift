//
//  UserInteractionViewController.swift
//  wav
//
//  Created by Ilyes Djari on 17/05/2023.
//

import UIKit
import NearbyInteraction
import MultipeerConnectivity

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
    
    // Outlets
    @IBOutlet weak var NearbyArrow: UIImageView!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var detailDistanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startup()
    }
    
    func startup() {
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
                fatalError("Unable to get self discovery token, is this session invalidated?")
            }
        } else {
            startupMPC()
            currentDistanceDirectionState = .unknown
        }
    }
    
    func animate(from currentState: DistanceDirectionState, to nextState: DistanceDirectionState, with peer: NINearbyObject) {
        // If the app transitions from unavailable, present the app's display
        // and hide the user instructions.
        let azimuth = peer.direction.map(azimuth(from:))
        if currentState == .unknown && nextState != .unknown {
        }
        // Set the app's display based on peer state.
        switch nextState {
        case .closeUpInFOV:
            print("close")
        case .notCloseUpInFOV:
            print("far")
        case .outOfFOV:
            print("out of fov")
        case .unknown:
            print("no info")
        }
        print("wow")
        
        if let direction = peer.direction {
            // Calculate azimuth (rotation around z axis) and elevation (rotation around x axis)
            NearbyArrow.isHidden = false
            let azimuth = atan2(direction.z, direction.x)
            let elevation = asin(-direction.y) // negative to make up point towards the sky
            DispatchQueue.main.async {
                var transform = CATransform3DIdentity
                // Apply rotation around z axis
                transform = CATransform3DRotate(transform, CGFloat(azimuth), 0, 0, 1)
                // Apply rotation around x axis
                transform = CATransform3DRotate(transform, CGFloat(elevation), 1, 0, 0)
                // Apply the 3D transformation
                self.NearbyArrow.layer.transform = transform
            }
            print("Azimuth: \(azimuth.radiansToDegrees)°, Elevation: \(elevation.radiansToDegrees)°")
        }
        
        if peer.distance != nil {
            detailDistanceLabel.text = String(format: "%0.2f m", peer.distance!)
        }
                
        // Don't update visuals if the peer device is unavailable or out of the
        // U1 chip's field of view.
        if nextState == .outOfFOV || nextState == .unknown {
            detailDistanceLabel.text = ""
            NearbyArrow.isHidden = true
            return
        }
    }
    
    func updateVisualization(from currentState: DistanceDirectionState, to nextState: DistanceDirectionState, with peer: NINearbyObject) {
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
