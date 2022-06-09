//
//  SDPushPage.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/23.
//

import SwiftUI

struct PushPage: View {
    @Binding var showSelf: Bool
    var body: some View {

        Button("back") {
            self.showSelf = false
        }
    }
}

//struct SDPushPage_Previews: PreviewProvider {
//    static var previews: some View {
//        SDPushPage(showSelf: true)
//    }
//}
