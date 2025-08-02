//
//  ContentView.swift
//  soxen
//
//  Created by WorkSpace on 7/29/25.
//

import SwiftUI

// 自定义 Checkbox 组件
struct CustomCheckbox<Label: View>: View {
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

struct ContentView: View {
    @State private var isChecked = false
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var keyboardHeight = 0
    @FocusState private var isPhoneFieldFocused: Bool
    @FocusState private var isCodeFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: URL(string: "https://soxen-app.oss-cn-hangzhou.aliyuncs.com/miniprogram/login-back.png")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.red
            }
            .frame(maxWidth: .infinity)
            .overlay(
                VStack(spacing: 4) {
                    Text("您好，请登录")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: 183)
                    Text("硕芯水肥智控")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: 183)
                }
            )
            Spacer()
        }
        .onTapGesture {
            // 点击空白区域关闭键盘
            isPhoneFieldFocused = false
            isCodeFieldFocused = false
        }
        // 忽略顶部安全距离
        .ignoresSafeArea(.all, edges: .top)
        .padding(0)
        .overlay(
            VStack {
                    Text("手机号")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
    
                    TextField("请输入手机号", text: $phoneNumber)
                        .padding(15)
                        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                        .cornerRadius(6)
                        .padding(.top, 10)
                        .keyboardType(.numberPad)
                        .focused($isPhoneFieldFocused)
    
    
                    Text("验证码")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                        
    
                    TextField("请输入验证码", text: $verificationCode)
                        .padding(15)
                        .padding(.trailing, 100)
                        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                        .cornerRadius(6)
                        .padding(.top, 10)
                        .keyboardType(.numberPad)
                        .focused($isCodeFieldFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Text("")
                                Spacer()
                                Text(isPhoneFieldFocused ? "请输入手机号" : "请输入验证码")
                                    .foregroundStyle(Color("secondary-text"))
                                
                                Spacer()
                                Button("完成") {
                                    isPhoneFieldFocused = false
                                    isCodeFieldFocused = false
                                }
                            }
                        }
                        .overlay(
                            HStack {
                                Spacer()
                                Text("发送验证码")
                                    .foregroundStyle(Color.accentColor)
                                    .padding(.top, 10)
                                    .padding(.trailing, 16)
                            }
                        )
    
    
                    CustomCheckbox(isChecked: $isChecked) {
                        HStack(spacing: 0) {
                            Text("同意")
                            Text("《平台服务协议》")
                                .foregroundColor(Color.accentColor)
                            Text("和")
                            Text("《隐私政策》")
                                .foregroundStyle(Color.accentColor)
                        }
                        .padding(0)
                        .font(.system(size: 12))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 16)
    
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
                    .background(Color.accentColor)
                    .cornerRadius(6)
                    .padding(.top, 20)
    
                    Spacer()
            }
                .padding(12)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // 上半部设置圆角
                .background(Color.white)
                .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                .offset(y: 149)
                .overlay(
                    VStack(spacing: 8) {
                        Spacer()
                        HStack(spacing: 12) {
                            Text("")
                                .frame(maxWidth: 52, maxHeight: 0.5)
                                .background(Color("secondary-text"))
                                .opacity(0.2)
                            Text("其它登录方式")
                            // 增加 css lineHeight
                                .lineSpacing(24)
                                .foregroundStyle(Color.gray)
                            Text("")
                                .frame(maxWidth: 52, maxHeight: 0.5)
                                .background(Color.gray)
                                .opacity(0.2)
                        }
                        HStack(spacing: 16) {
                            VStack(spacing: 4) {
                                Image("quick")
                                    .frame(maxWidth: 40)
                                Text("同意协议并快捷登录")
                                    .foregroundStyle(Color("secondary-text"))
                                    .font(.system(size: 14))
                            }
                            VStack(spacing: 4) {
                                Image("pwd")
                                    .frame(maxWidth: 40)
                                Text("账号登录")
                                    .foregroundStyle(Color("secondary-text"))
                                    .font(.system(size: 14))
                            }
                        }
                    }
                    .opacity((isCodeFieldFocused || isPhoneFieldFocused) ? 0 : 1)
                    // 增加过渡效果
                    .animation(.easeInOut(duration: 0.3), value: isCodeFieldFocused || isPhoneFieldFocused)
                )
        )
        .onTapGesture {
            isPhoneFieldFocused = false
            isCodeFieldFocused = false
        }
    }
}

// 扩展View来支持特定角落的圆角
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ContentView()
}
