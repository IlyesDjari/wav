//
//  formatPlaybackTime.swift
//  wav
//
//  Created by Ilyes Djari on 06/05/2023.
//

import Foundation

public func formatPlaybackTime(_ time: TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad
    formatter.allowedUnits = [.minute, .second]
    return formatter.string(from: time) ?? "0:00"
}
