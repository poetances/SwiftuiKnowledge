//
//  SDBindingPage.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/23.
//

import SwiftUI

struct BindingPage: View {
    @State private var count = 1
    var body: some View {
        VStack {
            SDBindingContent(count: $count)
            Text("当前数字：\(count)")
                .font(.title)
        }
    }
}

//struct SDBindingPage_Previews: PreviewProvider {
//    static var previews: some View {
//        SDBindingPage()
//    }
//}

struct SDBindingContent: View {

    @Binding var count: Int
    var body: some View {
        Button("\(count)") {
            self.count += 1
        }
    }
}
