//
//  SendablePage.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/30.
//

import SwiftUI

/*
 增加了对“可发送”数据的支持，即可以安全地传输到另一个线程的数据。这
 是通过新Sendable协议和@Sendable功能属性来实现的。
 */
struct SendablePage: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SendablePage_Previews: PreviewProvider {
    static var previews: some View {
        SendablePage()
    }
}
