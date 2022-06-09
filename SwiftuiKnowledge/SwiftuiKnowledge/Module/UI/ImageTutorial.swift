//
//  ImageTutorial.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/21.
//

import SwiftUI

struct ImageTutorial: View {



    var body: some View {

        let url = URL(string: "https://img1.doubanio.com/view/photo/l/public/p2292035027.jpg")
        return VStack {
            // asset图片
            Image("iAppStroe_icon")
                .padding(.bottom)
            // sf图标
            Image(systemName: "cloud.heavyrain.fill")
                .padding(.bottom)
            Image(systemName: "cloud.sun.rain.fill")
                .renderingMode(.original) // 渲染模式
                .font(.largeTitle) // 显示大小
                .padding() // 边距
                .background(Color.black) // 背景色
                .clipShape(Circle()) // 边缘效果

            // uiimage
            Image(uiImage: UIImage(named: "Apple_icon")!)
                .resizable()
                .frame(width: 100, height: 100)

            // 网络图片
            AsyncImage(url: url) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView("Hel")
                    .progressViewStyle(.circular)
            }.frame(width: 200, height: 200)


            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView().progressViewStyle(.circular)
                case .success(let img):
                    img.resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(_):
                    Text("error")
                @unknown default:
                    Text("Unknown error. Please try again.")
                }
            }.frame(width: 200, height: 200)
                .background(.red)
                .clipped()

           
        }
    }
}

struct ImageTutorial_Previews: PreviewProvider {
    static var previews: some View {
        ImageTutorial()
    }
}
