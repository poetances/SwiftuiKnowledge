//
//  Environment.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/6/6.
//

import SwiftUI

struct EnvironmentPage: View {

    @Environment(\.sizeCategory) var sizeCategory

    var body: some View {
        VStack {
            Text("isAccessibilityCategory::\(sizeCategory.isAccessibilityCategory.description)")

            Text("catch")
                .frame(maxWidth: .infinity)

        }
        .environment(\.multilineTextAlignment, .leading)
    }
}

struct Environment_Previews: PreviewProvider {
    static var previews: some View {
        EnvironmentPage()
    }
}
