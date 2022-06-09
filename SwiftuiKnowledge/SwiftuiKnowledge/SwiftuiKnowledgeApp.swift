//
//  SwiftuiKnowledgeApp.swift
//  SwiftuiKnowledge
//
//  Created by ZhuChaoJun on 2022/6/9.
//

import SwiftUI

@main
struct SwiftuiKnowledgeApp: App {

    init() {
        // do some cfg...
        setup()
    }

    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
    }

    private func setup() {
        let commonAttr: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "tsmg_blue")!
        ]

        UINavigationBar.appearance().largeTitleTextAttributes = commonAttr
        UINavigationBar.appearance().titleTextAttributes = commonAttr
        UIBarButtonItem.appearance().setTitleTextAttributes(commonAttr, for: .normal)

        UIWindow.appearance().tintColor = UIColor(named: "tsmg_blue")
    }
}
