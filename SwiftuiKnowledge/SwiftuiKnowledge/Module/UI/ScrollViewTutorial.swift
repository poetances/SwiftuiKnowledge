//
//  ScrollViewTutorial.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/21.
//

import SwiftUI

struct ScrollViewTutorial: View {
    var body: some View {
        ScrollView([.horizontal], showsIndicators: true) {
            HStack{
                Text("Hello,world")
                    .padding()
                    .lineLimit(1)

                Text("Hello,world")
                    .padding()
                    .lineLimit(1)

                Text("Hello,world")
                    .padding()
                    .lineLimit(1)

                Text("Hello,world")
                    .padding()
                    .lineLimit(1)
            }
        }


    }
}

struct ScrollViewTutorial_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewTutorial()
    }
}
