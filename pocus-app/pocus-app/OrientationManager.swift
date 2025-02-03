import UIKit

struct OrientationLock {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        delegate.orientationLock = orientation
    }

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, rotateTo: UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateTo.rawValue, forKey: "orientation")
    }
}
