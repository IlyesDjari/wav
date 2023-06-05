//
//  TouchVisualizer.swift
//  TouchVisualizer
//

import UIKit

final public class Visualizer: NSObject {

    // MARK: - Public Variables
    static public let sharedInstance = Visualizer()
    fileprivate var enabled = false
    fileprivate var config: Configuration!
    fileprivate var touchViews = [TouchView]()
    fileprivate var previousLog = ""

    // MARK: - Object life cycle
    private override init() {
        super.init()
        NotificationCenter
            .default
            .addObserver(
            self,
            selector: #selector(
                Visualizer.orientationDidChangeNotification(_:)),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)

        NotificationCenter
            .default
            .addObserver(
            self,
            selector: #selector(Visualizer.applicationDidBecomeActiveNotification(_:)),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)

        UIDevice
            .current
            .beginGeneratingDeviceOrientationNotifications()

        warnIfSimulator()
    }

    deinit {
        NotificationCenter
            .default
            .removeObserver(self)
    }

    // MARK: - Helper Functions
    @objc internal func applicationDidBecomeActiveNotification(_ notification: Notification) {
        UIApplication.shared.keyWindow?.swizzle()
    }

    @objc internal func orientationDidChangeNotification(_ notification: Notification) {
        let instance = Visualizer.sharedInstance
        for touch in instance.touchViews {
            touch.removeFromSuperview()
        }
    }
}

extension Visualizer {
    public class func isEnabled() -> Bool {
        return sharedInstance.enabled
    }

    // MARK: - Start and Stop functions

    public class func start(_ config: Configuration = Configuration()) {

        if config.showsLog {
            print("Visualizer start...")
        }
        let instance = sharedInstance
        instance.enabled = true
        instance.config = config

        if let window = UIApplication.shared.keyWindow {
            for subview in window.subviews {
                if let subview = subview as? TouchView {
                    subview.removeFromSuperview()
                }
            }
        }
        if config.showsLog {
            print("started !")
        }
    }

    public class func stop() {
        let instance = sharedInstance
        instance.enabled = false

        for touch in instance.touchViews {
            touch.removeFromSuperview()
        }
    }

    public class func getTouches() -> [UITouch] {
        let instance = sharedInstance
        var touches: [UITouch] = []
        for view in instance.touchViews {
            guard let touch = view.touch else { continue }
            touches.append(touch)
        }
        return touches
    }

    // MARK: - Dequeue and locating TouchViews and handling events
    private func dequeueTouchView() -> TouchView {
        for view in touchViews where view.superview == nil {
            return view
        }
        let touchView = TouchView()
        touchViews.append(touchView)
        return touchView
    }

    private func findTouchView(_ touch: UITouch) -> TouchView? {
        for view in touchViews where touch == view.touch {
            return view
        }
        return nil
    }

    open func handleEvent(_ event: UIEvent) {
        guard event.type == .touches && Visualizer.sharedInstance.enabled else {
            return
        }

        let topWindow = findTopVisibleWindow()

        guard let touches = event.allTouches else {
            return
        }

        for touch in touches {
            handleTouch(touch, in: topWindow)
            log(touch)
        }
    }

    private func findTopVisibleWindow() -> UIWindow {
        var topWindow = UIApplication.shared.keyWindow!

        for window in UIApplication.shared.windows where !window.isHidden && window.windowLevel
        > topWindow.windowLevel {
            topWindow = window
        }

        return topWindow
    }

    private func handleTouch(_ touch: UITouch, in window: UIWindow) {
        let phase = touch.phase

        switch phase {
        case .began:
            let view = dequeueTouchView()
            configureTouchView(view, with: touch)
            view.beginTouch()
            view.center = touch.location(in: window)
            window.addSubview(view)
        case .moved:
            if let view = findTouchView(touch) {
                view.center = touch.location(in: window)
            }
        case .ended, .cancelled:
            if let view = findTouchView(touch) {
                animateTouchViewRemoval(view) {
                    view.removeFromSuperview()
                    self.log(touch)
                }
            }
        default:
            break
        }
    }
}
