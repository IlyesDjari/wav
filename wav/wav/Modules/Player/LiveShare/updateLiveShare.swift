//
//  updateLiveShare.swift
//  wav
//
//  Created by Ilyes Djari on 05/06/2023.
//

import Foundation
import NotificationBannerSwift

extension PlayerViewController {
    internal func updateLiveShare() {
        if sharePlay {
            if let entryID = player.queue.currentEntry?.item?.id {
                startLiveShareSession(songID: entryID.rawValue) { result in
                    switch result {
                    case .success:
                        self.musicPlaybackControl.setLiveShareSessionButton(
                            liveSessionButton: self.liveShareButton,
                            liveSessionLabel: self.liveShareLabel,
                            sharePlayStatus: self.sharePlay,
                            liveShareView: self.liveShareView)
                    case .failure(let error):
                        NotificationBanner.showErrorBanner(
                            title: "Error",
                            subtitle: "Failed to start live share session: \(error)")
                    }
                }
            } else {
                print("Error: currentEntry ID is nil.")
            }
        } else {
            stopLiveShareSession { result in
                switch result {
                case .success:
                    self.musicPlaybackControl.setLiveShareSessionButton(
                        liveSessionButton: self.liveShareButton,
                        liveSessionLabel: self.liveShareLabel,
                        sharePlayStatus: self.sharePlay)
                case .failure(let error):
                    NotificationBanner.showErrorBanner(
                        title: "Error",
                        subtitle: "Failed to stop live share session: \(error)")
                }
            }
        }
    }
}
