//
//  TabBarView.swift
//  SwiftuiKnowledge
//
//  Created by ZhuChaoJun on 2022/6/9.
//

import SwiftUI

struct TabBarView: View {
    @State var selectedIndex = TabIndex.ui

    var body: some View {
        TabView(selection: $selectedIndex) {
            // ui
            SDSwiftUIKitPage()
                .tabItem {
                    TabBarItem(title: "ui", image: "arrow.up.arrow.down.square")
                }.tag(TabIndex.ui)

            // knowledge
            SDKnowledgePage()
                .tabItem {
                    TabBarItem(title: "knowledge", image: "magnifyingglass.circle.fill")
                }
                .tag(TabIndex.knowledge)
        }
    }
}

extension TabBarView {

    enum TabIndex: Int {
        case ui, knowledge
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

