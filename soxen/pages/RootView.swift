//
//  RootView.swift
//  soxen
//
//  Created by WorkSpace on 8/3/25.
//

import SwiftUI

struct RootView: View {
    @State private var isLoggedIn = false

    var body: some View {
            if isLoggedIn {
                MainTabView()
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
    }
}

#Preview {
    RootView()
}
