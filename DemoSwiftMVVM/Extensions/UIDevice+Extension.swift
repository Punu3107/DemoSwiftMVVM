import Foundation
import UIKit

extension UIDevice {
    var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    var isJailBroken: String? {
        if UIDevice.current.isSimulator { return nil }
        if JailBrokenHelper.hasCydiaInstalled() {
            return JailBrokenMessage.check1.message
        }
        if let suspiciousApp = JailBrokenHelper.containsSuspiciousApps() {
            
            for key in JailBrokenMessage.allCases {
                if key.rawValue == suspiciousApp {
                    return key.message
                }            }
            }
            if let suspiciousSystemPaths = JailBrokenHelper.hasSuspiciousSystemPaths() {
                for key in JailBrokenMessage.allCases {
                    if key.rawValue == suspiciousSystemPaths {
                        return key.message
                    }
                }
            }
            if JailBrokenHelper.canEditSystemFiles() {
                return JailBrokenMessage.check39.message
            }
            return nil
        }
    }
