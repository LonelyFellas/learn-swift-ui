//
//  ContentView.swift
//  soxen
//
//  Created by WorkSpace on 7/29/25.
//

import SwiftUI

// 自定义 Checkbox 组件
struct CustomCheckbox: View {
    @Binding var isChecked: Bool
    let label: String
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                isChecked.toggle()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isChecked ? Color.blue : Color.gray, lineWidth: 2)
                        .frame(width: 20, height: 20)
                        .background(isChecked ? Color.blue : Color.clear)

                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(label)
                .font(.system(size: 16))
                .foregroundColor(.primary)
        }
    }
}

struct ContentView: View {
    @State private var isChecked = false
    
    var body: some View {
        VStack {
            
            Button(
                action: {
                    // 点击
                    print("click me")
                },
                label: {
                    Text("登录")
                        .padding(12)
                        .foregroundStyle(.white)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                }
            )
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(6)

            // 帮我写一个类型checkbox的组件
            // 我需要是checkbox的组件不是toggle
            
            CustomCheckbox(isChecked: $isChecked, label: "记住我")
                .padding(.top, 16)

        }
        .frame(maxWidth: .infinity)
        .padding(12)
    }
}

#Preview {
    ContentView()
}
