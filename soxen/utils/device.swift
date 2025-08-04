//
//  device.swift
//  soxen
//
//  Created by WorkSpace on 8/3/25.
//
import Foundation
import SwiftUI

extension UIDevice {
    /// 顶部安全区高度
    static func xp_safeAreaTop() -> CGFloat {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
}
