//
//  TextTutorial.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/21.
//

import SwiftUI

class Pp: ObservableObject {
    init() {
        print("Pp init")
    }

    deinit {
        print("Pp deinit")
    }
}

struct TextSub: View {
    @ObservedObject var per = Pp()

    var body: some View {
        Text("sub")
    }
}

struct TextTutorial: View {


    var body: some View {
        // basic
        // textFit
        // textFormate
        // textOtherStyle
        // textCombine
        // textLocalized
        TextSub()
    }

    // MARK: - Basc
    var basic: some View {
        VStack(spacing: 10) {
            Text("Hamlet")
            Text("Hamlet")
                .foregroundColor(.red)
            Text("Hamlet")
                .foregroundColor(.blue)
                .font(.title)
                .italic()
                .bold()
            Text("Hamlet")
                .font(.system(size: 20, weight: .bold, design: .monospaced))
            Text("Hamlet")
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Text("Hamlet")
                .font(.system(size: 20, weight: .bold, design: .serif))
            Text("Hamlet")
                .font(.system(size: 20, weight: .bold, design: .default))
        }
    }

    // MARK: - TextFit
    var textFit: some View {
        VStack {
            Text("To be, or not to be, that is question:")
            Text("To be, or not to be, that is question:")
                .frame(width: 100)
            Text("To be, or not to be, that is question:")
                .frame(width: 120)
                .lineLimit(2)
            Text("To be, or not to be, that is question:")
                .frame(width: 270)
                .lineLimit(1)
                .allowsTightening(true) // 如果能够差不多放下，那么允许间距变小
            Text("To be, or not to be, that is question:")
                .frame(width: 120)
                .lineLimit(1)
                .minimumScaleFactor(0.5) // 字体缩放

            Text("To be, or not to be, that is question:")
                .frame(width: 120)
                .lineLimit(1)
                .truncationMode(.head)// 截断的位置
        }
    }

    // MARK：- 格式化显示
    let price = 100.343599
    let startDate = Date.now
    var textFormate: some View {
        VStack {
            // 两种格式化方式
            Text("\(price, specifier: "%0.2f")")
            Text(String(format: "%0.2f", price))

            // 显示时间
            Text(startDate, style: .time)

            //
            Text(startDate, style: .date)

            Text(startDate, style: .offset)

        }
    }

    // MARK: - other set
    var textOtherStyle: some View {
        VStack {
            Text("Hamlet")
                .font(.title)
                .strikethrough()

            Text("Hamelet")
                .font(.subheadline)
                .underline()

            Text("Hamelet")
                .font(.caption)
                .unredacted()

            Text("Hamelet")
                .font(.title)
                .kerning(4)
                .padding(20)

            Text("Hamelet")
                .font(.title)
                .tracking(4)

            Text("Hamelet")
                .baselineOffset(3)

            Text("SwiftUI Facebook SDK : App ID not found. Add a string value with your app ID for the key FacebookAppID to the Info.plist")
                .frame(width: 300, height: 100, alignment: .center)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Combine Text
    var textCombine: some View {
        // 可以实现富文本效果
        VStack {
            Text("Hamelet")
                .font(.title)
                .foregroundColor(.blue) +
            Text("is gold")
                .font(.system(size: 15))
                .foregroundColor(Color("h_gold"))
        }
    }

    // MARK：- Localized
    var textLocalized: some View {
        VStack {

            Text("key_penciel")
            Text(verbatim: "key_penciel")
            Text(LocalizedStringKey("key_penciel"))
        }
    }
}

struct TextTutorial_Previews: PreviewProvider {
    static var previews: some View {
        TextTutorial()
    }
}
