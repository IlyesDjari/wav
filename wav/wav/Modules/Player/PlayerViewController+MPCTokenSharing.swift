//
//  PlayerViewController+MPCTokenSharing.swift
//  wav
//
//  Created by Ilyes Djari on 26/05/2023.
//

import Foundation
import NearbyInteraction
import MultipeerConnectivity

extension PlayerViewController {

    func startupMPC() {
        if mpc == nil {
            mpc = MPCSession(service: "nisample", identity: "ilyesdjari.wav", maxPeers: 1)
            mpc?.peerConnectedHandler = connectedToPeer
            mpc?.peerDataHandler = dataReceivedHandler
            mpc?.peerDisconnectedHandler = disconnectedFromPeer
        }
        mpc?.invalidate()
        mpc?.start()
    }

    func connectedToPeer(peer: MCPeerID) {
        guard let myToken = session?.discoveryToken else {
            fatalError("Unexpectedly failed to initialize nearby interaction session.")
        }

        if connectedPeer != nil {
            fatalError("Already connected to a peer.")
        }

        if !sharedTokenWithPeer {
            shareMyDiscoveryToken(token: myToken)
        }
        connectedPeer = peer
        peerDisplayName = peer.displayName
    }

    func disconnectedFromPeer(peer: MCPeerID) {
        if connectedPeer == peer {
            connectedPeer = nil
            sharedTokenWithPeer = false
        }
    }

    func dataReceivedHandler(data: Data, peer: MCPeerID) {
        guard let discoveryToken = try? NSKeyedUnarchiver.unarchivedObject(
            ofClass: NIDiscoveryToken.self,
            from: data) else {
            fatalError("Unexpectedly failed to decode discovery token.")
        }
        peerDidShareDiscoveryToken(peer: peer, token: discoveryToken)
    }

    func shareMyDiscoveryToken(token: NIDiscoveryToken) {
        guard let encodedData = try? NSKeyedArchiver.archivedData(
            withRootObject: token,
            requiringSecureCoding: true) else {
            fatalError("Unexpectedly failed to encode discovery token.")
        }
        mpc?.sendDataToAllPeers(data: encodedData)
        sharedTokenWithPeer = true
    }

    func peerDidShareDiscoveryToken(peer: MCPeerID, token: NIDiscoveryToken) {
        if connectedPeer != peer {
            fatalError("Received token from unexpected peer.")
        }
        // Create a configuration.
        peerDiscoveryToken = token
        let config = NINearbyPeerConfiguration(peerToken: token)
        // Run the session.
        session?.run(config)
    }

    func isNearby(_ distance: Float) -> Bool {
        return distance < nearbyDistanceThreshold
    }

    func isPointingAt(_ angleRad: Float) -> Bool {
        // Consider the range -15 to +15 to be "pointing at".
        return abs(angleRad.radiansToDegrees) <= 15
    }

    func getDistanceDirectionState(from nearbyObject: NINearbyObject) -> DistanceDirectionState {
        if nearbyObject.distance == nil && nearbyObject.direction == nil {
            return .unknown
        }

        let isNearby = nearbyObject.distance.map(isNearby(_:)) ?? false
        let directionAvailable = nearbyObject.direction != nil

        if isNearby && directionAvailable {
            return .closeUpInFOV
        }

        if !isNearby && directionAvailable {
            return .notCloseUpInFOV
        }

        return .outOfFOV
    }

}
