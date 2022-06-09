//
//  RedBackgroudAndCornerView.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/20.
//

import SwiftUI

struct RedBackgroudAndCornerView<Content: View>: View {
    private let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background(Color.red)
            .cornerRadius(5)
    }
}
