//
//  debounce.swift
//  wav
//
//  Created by Ilyes Djari on 11/05/2023.
//

import Foundation

public func debounce(interval: Int, queue: DispatchQueue, action: @escaping (() -> Void)) -> () -> Void {
    var lastFireTime = DispatchTime.now()
    let dispatchDelay = DispatchTimeInterval.milliseconds(interval)

    return {
        lastFireTime = DispatchTime.now()
        queue.asyncAfter(deadline: .now() + dispatchDelay) {
            let now = DispatchTime.now()
            let elapsed = Int(now.uptimeNanoseconds - lastFireTime.uptimeNanoseconds) / 1_000_000 // Convert to milliseconds
            if elapsed >= interval {
                action()
            }
        }
    }
}
