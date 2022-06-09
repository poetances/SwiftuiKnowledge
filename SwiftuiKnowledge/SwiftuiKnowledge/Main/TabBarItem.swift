//
//  TabBarItem.swift
//  SwiftuiKnowledge
//
//  Created by ZhuChaoJun on 2022/6/9.
//

import SwiftUI

struct TabBarItem: View {
    let title: String
    let image: String

    var body: some View {
        VStack {
            Image(systemName: image)
                .imageScale(.large)
            Text(title)
        }
    }
}
