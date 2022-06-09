//
//  GeometryReaderPage.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/6/2.
//

import SwiftUI

struct GeometryReaderPage: View {
    var body: some View {
//         basicGero
//        customGeo
        stickHeader
    }

    // MAKR: GeometryReader
    var basicGero: some View {
        // 默认是有安全区域的
        GeometryReader { geoproxy in
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .position(x: geoproxy.frame(in: .local).midX, y: geoproxy.frame(in: .local).minY)

            VStack (spacing: 10) {
                Text("w:\(geoproxy.size.width)    h:\(geoproxy.size.height)")
                Text("localW:\(geoproxy.frame(in: .local).width)    localH:\(geoproxy.frame(in: .local).height)")
                Text("globalW:\(geoproxy.frame(in: .global).width)    globalH:\(geoproxy.frame(in: .global).height)")
                Text("screenW:\(UIScreen.main.bounds.size.width)    screenH:\(UIScreen.main.bounds.size.height)")
                Text("safeArea:\(geoproxy.safeAreaInsets.top) \(geoproxy.safeAreaInsets.bottom)")

                // 子Geometry， 我们可以看出，其实是撑满整个屏幕的。默认是有safeArea的。
                GeometryReader { geoproxy in
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                        .position(x: geoproxy.frame(in: .local).midX, y: geoproxy.frame(in: .local).minY)

                    VStack (spacing: 10) {
                        Text("w:\(geoproxy.size.width)    h:\(geoproxy.size.height)")
                        Text("localW:\(geoproxy.frame(in: .local).midX)    localH:\(geoproxy.frame(in: .local).minY)")
                        Text("globalW:\(geoproxy.frame(in: .global).midX)    globalH:\(geoproxy.frame(in: .global).minY)")
                        Text("screenW:\(UIScreen.main.bounds.size.width)    screenH:\(UIScreen.main.bounds.size.height)")
                        Text("safeArea:\(geoproxy.safeAreaInsets.top) \(geoproxy.safeAreaInsets.bottom)")
                    }

                }
                .ignoresSafeArea()
                .background(.red.opacity(0.2))
            }

        }
        .background(.purple.opacity(0.2))
    }

    // MARK: custom
    var customGeo: some View {
        // 默认是有安全区域的
        GeometryReader { geoproxy in
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .position(x: geoproxy.frame(in: .local).midX, y: geoproxy.frame(in: .local).minY)

            VStack (spacing: 10) {
                Text("w:\(geoproxy.size.width)    h:\(geoproxy.size.height)")
                Text("localW:\(geoproxy.frame(in: .local).width)    localH:\(geoproxy.frame(in: .local).height)")
                Text("globalW:\(geoproxy.frame(in: .global).width)    globalH:\(geoproxy.frame(in: .global).height)")
                Text("screenW:\(UIScreen.main.bounds.size.width)    screenH:\(UIScreen.main.bounds.size.height)")
                Text("safeArea:\(geoproxy.safeAreaInsets.top) \(geoproxy.safeAreaInsets.bottom)")


                // 子Geometry， 我们可以看出，其实是撑满整个屏幕的。默认是有safeArea的。
                GeometryReader { geoproxy in

                    VStack (spacing: 10) {
                        Text("w:\(geoproxy.size.width)    h:\(geoproxy.size.height)")
                        Text("localW:\(geoproxy.frame(in: .local).midX)    localH:\(geoproxy.frame(in: .local).minY)")
                        Text("globalW:\(geoproxy.frame(in: .global).midX)    globalH:\(geoproxy.frame(in: .global).minY)")
                        Text("screenW:\(UIScreen.main.bounds.size.width)    screenH:\(UIScreen.main.bounds.size.height)")
                        Text("safeArea:\(geoproxy.safeAreaInsets.top) \(geoproxy.safeAreaInsets.bottom)")

                        
                        Text("customW:\(geoproxy.frame(in: .named("text")).minX) customH:\(geoproxy.frame(in: .named("text")).minY)")
                    }

                }
                .ignoresSafeArea()
                .background(.red.opacity(0.2))

            }
            


        }
        .background(.purple.opacity(0.2))
    }


    // stick header
    @State var heightx: CGFloat = 100
    var stickHeader: some View {
        ScrollView {
            ZStack {
                VStack {

                    ForEach(DTCourse.sample) { course in
                        GroupBox {
                            Text(course.subtitle)
                                .bold()
                            Text(course.desc)
                                .foregroundColor(.secondary)

                        } label: {
                            Text(course.title)
                                .font(.title2)
                        }
                        .padding()
                        .shadow(radius: 10)
                    }
                }
                .padding(.top, 100)

                // sticky header
                GeometryReader { geoProxy in
                    VStack {
                        Text("DevTechie Courses")
                            .font(.title)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: self.getHeight(minHeight: 100,
                                                  maxHeight: 100,
                                                  yOffset: geoProxy.frame(in: .global).origin.y))

                    .background(Color.orange.opacity(0.95))
                    .offset(y: (geoProxy.frame(in: .global).origin.y < 0 ? abs(geoProxy.frame(in: .global).origin.y) : -geoProxy.frame(in: .global).origin.y))
                }
            }

        }
        .edgesIgnoringSafeArea(.vertical)
    }

    func getHeight(minHeight: CGFloat, maxHeight: CGFloat, yOffset: CGFloat) -> CGFloat {
        // scrolling up
        if maxHeight + yOffset < minHeight {
            return minHeight
        }

        // scrolling down
        return maxHeight + yOffset
    }
}

struct GeometryReaderPage_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReaderPage()
    }
}

struct DTCourse: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var desc: String
}
extension DTCourse {
    static var sample: [DTCourse] {
        [
            DTCourse(title: "Masting SwiftUI 3", subtitle: "Learn SwiftUI 3 by Example", desc: "在本课程中，我们将从头开始学习 SwiftUI 3 中的 iOS 应用程序开发。 "),
            DTCourse(title: "TodoList with combine", subtitle: "了解 Combine 和 SwiftUI", desc: "这门课程是关于一起使用 SwiftUI 和 Combine。"),
            DTCourse(title: "DisneyPlus Clone in SwiftUI" , subtitle: "Build DisneyPlus Clone", desc: "在本课程中，我们将使用 SwiftUI 构建功能齐全的 DisneyPlus 克隆。"),
            DTCourse(title: "Masting SwiftUI 3", subtitle: "Learn SwiftUI 3 by Example",desc: "在本课程中，我们将从头开始学习 SwiftUI 3 中的 iOS 应用程序开发。"),
            DTCourse(title: "TodoList with Combine", subtitle: "了解Combine 和SwiftUI", desc: "本课程是关于一起使用SwiftUI 和Combine。"),
            DTCourse(title: "DisneyPlus Clone in SwiftUI", subtitle: "Build DisneyPlus Clone", desc: "在本课程中，我们将使用 SwiftUI 构建功能齐全的 DisneyPlus 克隆。")
        ]
    }
}
