//
//  FormTutorial.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/24.
//

import SwiftUI

struct FormTutorial: View {
    var body: some View {
        Form {
            Group {
                Text("hello")
                Text("hello")
            }
            Group {
                Text("hello")
                Text("hello")
            }

            Section("section1") {
                Text("section1--row0")
                Text("section1--row1")
                Text("section1--row2")
            }

            Section("section2") {
                Text("section2--row0")
                Text("section2--row1")
                Text("section2--row2")
            }

            Section("section2") {
                Text("section2--row0")
                Text("section2--row1")
                Text("section2--row2")
            }

            Section("section2") {
                Text("section2--row0")
                Text("section2--row1")
                Text("section2--row2")
            }

            Section("section2") {
                Text("section2--row0")
                Text("section2--row1")
                Text("section2--row2")
            }

            Section("section2") {
                Text("section2--row0")
                Text("section2--row1")
                Text("section2--row2")
            }

            Section("section2") {
                Text("section2--row0")
                Text("section2--row1")
                Text("section2--row2")
            }

            Section("section2") {
                Text("section2--row0")
                Text("section2--row1")
                Text("section2--row2")
            }

        }
    }
}

struct FormTutorial_Previews: PreviewProvider {
    static var previews: some View {
        FormTutorial()
    }
}
