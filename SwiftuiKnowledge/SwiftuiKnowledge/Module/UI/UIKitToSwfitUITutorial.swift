//
//  UIKitToSwfitUITutorial.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/6/8.
//

import SwiftUI

struct UIKitToSwfitUITutorial: View {
    var body: some View {
        UIKitView()
            .frame(width: 100, height: 100)
    }
}

struct UIKitToSwfitUITutorial_Previews: PreviewProvider {
    static var previews: some View {
        UIKitToSwfitUITutorial()
    }
}


// swiftui使用uikit，通过UIViewRepresentable协议实现。
struct UIKitView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        let v = UILabel()
        v.backgroundColor = UIColor.purple
        return v
    }

    func updateUIView(_ uiView: UIView, context: Context) {

    }
}


// uikit使用swiftui，通过
class CustomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        let swfitUIv = UIHostingController(rootView: Text("这是swiftui text"))
        swfitUIv.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(swfitUIv.view)

        NSLayoutConstraint.activate([

            swfitUIv.view.widthAnchor.constraint(equalToConstant: 100),
            swfitUIv.view.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
