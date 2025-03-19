import Foundation
import UIKit

enum JailBrokenConstants {
    static let canEditFilePath  =  "/private/jailbreak.txt"
    static let cydiaAppPath       = "cydia://package/com.example.package"
}

struct JailBrokenHelper {
    static func hasCydiaInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: JailBrokenConstants.cydiaAppPath)!)
    }
    static func containsSuspiciousApps() -> String? {
        for path in suspiciousAppsPathToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return "\(path)"
            }
        }
        return nil
    }
    static func hasSuspiciousSystemPaths() -> String? {
        for path in suspiciousSystemPathsToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return "\(path)"
            }
        }
        return nil
    }
    static func canEditSystemFiles() -> Bool {
        let jailBreakText = "Developer Insider"
        do {
            try jailBreakText.write(toFile: JailBrokenConstants.canEditFilePath, atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }

    static var suspiciousAppsPathToCheck: [String] {
        return [
            "/Applications/Cydia.app",
            "/Applications/blackra1n.app",
            "/Applications/FakeCarrier.app",
            "/Applications/Icy.app",
            "/Applications/IntelliScreen.app",
            "/Applications/MxTube.app",
            "/Applications/RockApp.app",
            "/Applications/SBSettings.app",
            "/Applications/WinterBoard.app",
            "/Applications/LibertyLite.app"
        ]
    }
    
    static var suspiciousSystemPathsToCheck: [String] {
        return [
            "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
            "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
            "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
            "/bin/bash",
            "/bin/sh",
            "/etc/apt",
            "/etc/ssh/sshd_config",
            "/private/var/tmp/cydia.log",
            "/var/tmp/cydia.log",
            "/usr/bin/sshd",
            "/usr/libexec/sftp-server",
            "/usr/libexec/ssh-keysign",
            "/usr/sbin/sshd",
            "/var/cache/apt",
            "/var/lib/apt",
            "/var/lib/cydia",
            "/usr/sbin/frida-server",
            "/usr/bin/cycript",
            "/usr/local/bin/cycript",
            "/usr/lib/libcycript.dylib",
            "/var/log/syslog",
            "/private/var/lib/apt",
            "/private/var/lib/cydia",
            "/private/var/mobile/Library/SBSettings/Themes",
            "/private/var/stash"
        ]
    }
}

enum JailBrokenMessage: String, CaseIterable {
    case check1 = "Cydia Installed"
    case check2 = "/Applications/Cydia.app"
    case check3 = "/Applications/blackra1n.app"
    case check4 = "/Applications/FakeCarrier.app"
    case check5 = "/Applications/Icy.app"
    case check6 = "/Applications/IntelliScreen.app"
    case check7 = "/Applications/MxTube.app"
    case check8 = "/Applications/RockApp.app"
    case check9 = "/Applications/SBSettings.app"
    case check10 = "/Applications/WinterBoard.app"
    case check11 = "/Applications/LibertyLite.app"
    case check12 = "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist"
    case check13 = "/Library/MobileSubstrate/DynamicLibraries/Veency.plist"
    case check14 = "/Library/MobileSubstrate/MobileSubstrate.dylib"
    case check15 = "/System/Library/LaunchDaemons/com.ikey.bbot.plist"
    case check16 = "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist"
    case check17 = "/bin/bash"
    case check18 = "/bin/sh"
    case check19 = "/etc/apt"
    case check20 = "/etc/ssh/sshd_config"
    case check21 = "/private/var/tmp/cydia.log"
    case check22 = "/var/tmp/cydia.log"
    case check23 = "/usr/bin/sshd"
    case check24 = "/usr/libexec/sftp-server"
    case check25 = "/usr/libexec/ssh-keysign"
    case check26 = "/usr/sbin/sshd"
    case check27 = "/var/cache/apt"
    case check28 = "/var/lib/apt"
    case check29 = "/var/lib/cydia"
    case check30 = "/usr/sbin/frida-server"
    case check31 = "/usr/bin/cycript"
    case check32 = "/usr/local/bin/cycript"
    case check33 = "/usr/lib/libcycript.dylib"
    case check34 = "/var/log/syslog"
    case check35 = "/private/var/lib/apt"
    case check36 = "/private/var/lib/cydia"
    case check37 = "/private/var/mobile/Library/SBSettings/Themes"
    case check38 = "/private/var/stash"
    case check39 = "Can Edit System Files"
    
    var message: String {
        switch self {
        case .check1:
            return "C1"
        case .check2:
            return "C2"
        case .check39:
            return "C39"
        case .check3:
            return "C3"
        case .check4:
            return "C4"
        case .check5:
            return "C5"
        case .check6:
            return "C6"
        case .check7:
            return "C7"
        case .check8:
            return "C8"
        case .check9:
            return "C9"
        case .check10:
            return "C10"
        case .check11:
            return "C11"
        case .check12:
            return "C12"
        case .check13:
            return "C13"
        case .check14:
            return "C14"
        case .check15:
            return "C15"
        case .check16:
            return "C16"
        case .check17:
            return "C17"
        case .check18:
            return "C18"
        case .check19:
            return "C19"
        case .check20:
            return "C20"
        case .check21:
            return "C21"
        case .check22:
            return "C22"
        case .check23:
            return "C24"
        case .check24:
            return "C24"
        case .check25:
            return "C25"
        case .check26:
            return "C26"
        case .check27:
            return "C27"
        case .check28:
            return "C28"
        case .check29:
            return "C29"
        case .check30:
            return "C30"
        case .check31:
            return "C31"
        case .check32:
            return "C32"
        case .check33:
            return "C33"
        case .check34:
            return "C34"
        case .check35:
            return "C35"
        case .check36:
            return "C36"
        case .check37:
            return "C37"
        case .check38:
            return "C38"
        }
    }
}
