//
//  ContentView.swift
//  soxen
//
//  Created by WorkSpace on 7/29/25.
//

import SwiftUI
import Foundation



struct LoginView: View {
    @State private var isChecked = false
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var keyboardHeight = 0
    @State private var shouldShakePhone = false
    @State private var phoneNumberRule = false
    @State private var phoneNumberErrText = "请输入正确的手机号"
    @Binding var isLoggedIn: Bool
    @FocusState private var isPhoneFieldFocused: Bool
    @FocusState private var isCodeFieldFocused: Bool
    let statusTop = UIDevice.xp_safeAreaTop()
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    let bgImgRatio = CGFloat(375.0 / 258.0)
    
    var bgImgHeight: CGFloat {
        return screenWidth / bgImgRatio
    }
    var mainContentHeight: CGFloat {
        print("bgImgHeight", bgImgHeight)
        return screenHeight - bgImgHeight + 32
    }
    var body: some View {
        ZStack {
            VStack {
                // 如何计算Image的高度
                Image("login-back")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                Spacer()
            }
            VStack {
                VStack(spacing: 4) {
                    Text("您好，请登录")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: 150, alignment: .leading)
                    Text("硕芯水肥智控")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: 150, alignment: .leading)
                }
                .offset(x: -44, y: (statusTop + 44.0))
                .frame(maxWidth: .infinity, alignment: .trailing)
                Spacer()
            }
            VStack(spacing: 0) {
                Spacer()
                VStack(spacing: 0) {
                    Text("手机号")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                    
                    ZStack {
                        TextField("请输入手机号", text: $phoneNumber)
                            .padding(15)
                            .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                            .cornerRadius(6)
                            .padding(.top, 10)
                            .keyboardType(.numberPad)
                            .focused($isPhoneFieldFocused)
                            .shake(when: $shouldShakePhone)
                        
                        if phoneNumberRule {
                            Text(phoneNumberErrText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(Color.red)
                                .font(.system(size: 14))
                                .offset(y: 42)
                            
                        }
                    }
                    
                    
                    
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
                            HStack(spacing: 0) {
                                Spacer()
                                Button(action: {
                                    let isValid = !isValidPhoneNumber(phoneNumber)
                                    let isEmpty = phoneNumber.isEmpty
                                    if isValid || isEmpty {
                                        let generator = UINotificationFeedbackGenerator()
                                        generator.notificationOccurred(.error)
                                        shouldShakePhone = true
                                        phoneNumberRule = true
                                        phoneNumberErrText = isEmpty ? "手机号不能为空" : "请输入正确的手机号"
                                        return;
                                    }
                                    
                                    Task {
                                        do {
                                            let reponse = try await Api().post(path: "/login/send-sms-code", dictParams: ["phone": phoneNumber])
                                            // 判断response类型
                                            if let json = reponse as? [String: Any] {
                                                if let code = json["code"] as? Int {
                                                    if code == 200 {
                                                        print("✅ 验证码发送成功")
                                                    } else {
                                                        print("❌ 验证码发送失败: \(json["msg"] as? String ?? "未知错误")")
                                                    }
                                                }
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }, label: {
                                    Text("发送验证码")
                                        .foregroundStyle(Color.accentColor)
                                        .padding(.top, 10)
                                        .padding(.trailing, 16)
                                })
                            }
                        )
                    Checkbox(isChecked: $isChecked) {
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
                            print("login")
                            Task {
                                do {
                                    // go to login page
                                    let response = try await Api().post(path: "/login/sms-phone", dictParams: ["phone": phoneNumber, "code": verificationCode])
                                    print("response", response)
                                    
                                }
                            }
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
                    
                    VStack(spacing: 8) {
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
                }
                .padding(12)
                .frame(maxWidth: .infinity, maxHeight: mainContentHeight)
                .background(Color("WhiteBg"))
                .clipShape(RoundedCorner(radius: 25, corners: [.topLeft, .topRight]))
                
                
                
                
            }
            .frame(maxHeight: .infinity)
        }
        .onTapGesture {
            // 点击空白区域关闭键盘
            isPhoneFieldFocused = false
            isCodeFieldFocused = false
        }
        // 忽略顶部安全距离
        .ignoresSafeArea(.all, edges: .top)
        .padding(0)
    }
    
    func isValidPhoneNumber(_ number: String) -> Bool {
        let pattern = "^1[3-9]\\d{9}$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: number.utf16.count)
        return regex.firstMatch(in: number, options: [], range: range) != nil
    }
}

