//
//  Checkbox.swift
//  soxen
//
//  Created by WorkSpace on 8/3/25.
//
import SwiftUI

// 自定义 Checkbox 组件
struct Checkbox<Label: View>: View {
    @Binding var isChecked: Bool
    let label: Label
    
    init(isChecked: Binding<Bool>, @ViewBuilder label: () -> Label) {
        self._isChecked = isChecked
        self.label = label()
    }
    
    // 便利初始化器，支持 String
    init(isChecked: Binding<Bool>, label: String) where Label == Text {
        self._isChecked = isChecked
        self.label = Text(label)
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                isChecked.toggle()
            }) {
                ZStack {
                    Circle()
                        .stroke(isChecked ? Color.accentColor : Color("secondary-text"), lineWidth: 2)
                        .frame(width: 20, height: 20)
                        .background(isChecked ? Color.accentColor : Color.clear)
                        .clipShape(Circle())

                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            label
        }
    }
}
