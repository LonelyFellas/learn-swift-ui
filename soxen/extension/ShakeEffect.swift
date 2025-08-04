//
//  ShakeEffect.swift
//  soxen
//
//  Created by WorkSpace on 8/3/25.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var travelDistance: CGFloat = 3
    var numberOfShakes: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        // 左右偏移的核心逻辑
        let translation = travelDistance * sin(animatableData * .pi * numberOfShakes)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

struct ShakeModifier: ViewModifier {
    @Binding var trigger: Bool
    @State private var animValue: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .modifier(ShakeEffect(animatableData: animValue))
            .onChange(of: trigger) {_, newValue in
                if newValue {
                    withAnimation(.linear(duration: 0.2)) {
                        animValue = 1
                    }
                    // 动画结束后清除状态
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        animValue = 0
                        trigger = false
                    }
                }
            }
    }
}

extension View {
    func shake(when trigger: Binding<Bool>) -> some View {
        self.modifier(ShakeModifier(trigger: trigger))
    }
}


