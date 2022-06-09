//
//  TaskPage.swift
//  SwiftUIDemo
//
//  Created by ZhuChaoJun on 2022/5/27.
//

import SwiftUI

struct TaskPage: View {
    var body: some View {
        VStack {

            Button("create aync task") {
                Task {
                    print("task 1", Thread.current)
                    await createAsyncTask()
                    print("task 2", Thread.current)
                }

            }.padding(.bottom)

            Button("struct concurrency") {
                #if true
                Task {
                    print("task 1", Date.now.description)
                    let a = await performTaskA()
                    let b = await performTaskB()
                    print("task result: \(a + b)", Date.now.description)

                }
/*
 task 1 2022-05-27 00:00:10 +0000
 performTaskA start <_NSMainThread: 0x600002bfc380>{number = 1, name = main} 2022-05-27 00:00:10 +0000
 performTaskA end <NSThread: 0x600002bd5c80>{number = 3, name = (null)} 2022-05-27 00:00:12 +0000
 performTaskB start <NSThread: 0x600002bd5c80>{number = 3, name = (null)} 2022-05-27 00:00:12 +0000
 performTaskB end <NSThread: 0x600002bd5c80>{number = 3, name = (null)} 2022-05-27 00:00:15 +0000
 task result: 5 2022-05-27 00:00:15 +0000
 从结果我们可以看出，整个过程操作下来需要5秒的时间。
 */
                #else
                // 所谓的结构并发就是
                Task {
                    print("task 1", Date.now.description)
                    async let a = performTaskA()
                    async let b = performTaskB()
                    let sum = await (a + b)
                    print("task result: \(sum)", Date.now.description)

                }
                #endif

/*
 task 1 2022-05-26 23:59:03 +0000
 performTaskA start <NSThread: 0x600001b54200>{number = 7, name = (null)} 2022-05-26 23:59:03 +0000
 performTaskB start <NSThread: 0x600001b54200>{number = 7, name = (null)} 2022-05-26 23:59:03 +0000
 performTaskA end <NSThread: 0x600001b88fc0>{number = 3, name = (null)} 2022-05-26 23:59:05 +0000
 performTaskB end <NSThread: 0x600001b88fc0>{number = 3, name = (null)} 2022-05-26 23:59:06 +0000
 createAsyncTask end <NSThread: 0x600001b88fc0>{number = 3, name = (null)} 2022-05-26 23:59:06 +0000
 task 2 <_NSMainThread: 0x600001bc80c0>{number = 1, name = main}
 task result: 5 2022-05-26 23:59:06 +0000
 从结果我们可以看出整个操作下来需要时间是3秒，从而达到了我们任务的并发效果
 */
            }
            .padding(.bottom)
            .buttonStyle(.plain)

            Button("Actor") {
                let counter = Counter(name: "My counter")
                // 因为Counter是用actor修饰，所以直接调用就会出现报错问题
                Task {
                    await counter.addCount()

                }

                // 我们可以使用noisolated，将其从参与保护到中排除。不然getName也需要铜鼓await来进行调用。
                _ = counter.getName()
            }
            .padding(.bottom)


            // create async/await
            Button("convert to Async Task") {
//                Task {
//                   let result = try? await convertToAsyncAwait(input: 11)
//                    print("结果：", result)

//                }
                let imageTask = Task { ()->UIImage? in

                    sleep(3)
                    print("多线程", Thread.current)
                    return nil
                }
                imageTask.cancel()
            }.padding(.bottom)
        }
    }

    private func createAsyncTask() async {
        print("createAsyncTask start", Thread.current, Date.now.description)
        try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        // 如果把上面代码换成sleep(3)，我们会发现整个方法都还是在主线程中执行，这也就证明了async、await只是一个标识，告诉编译器这里可能会使异步，
        // 并不是说会给你开一个异步线程。
        // sleep(3)
        print("createAsyncTask end", Thread.current,Date.now.description)
/*
 输出日志：
 task 1 <_NSMainThread: 0x600003028380>{number = 1, name = main}
 createAsyncTask 1 <_NSMainThread: 0x600003028380>{number = 1, name = main}
 createAsyncTask 2 <NSThread: 0x600003060700>{number = 8, name = (null)}
 task 2 <_NSMainThread: 0x600003028380>{number = 1, name = main}
 */
    }


    // 结构并发
    private func performTaskA() async -> Int {

        print("performTaskA start", Thread.current, Date.now.description)
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        print("performTaskA end", Thread.current, Date.now.description)
        return 2
    }

    private func performTaskB() async -> Int {
        print("performTaskB start", Thread.current, Date.now.description)
        try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
        print("performTaskB end", Thread.current, Date.now.description)
        return 3
    }

    private func convertToAsyncAwait(input: Int) async throws -> String {

        let a: String = try await withCheckedThrowingContinuation { contitunation in
            // 创建一个异步线程执行里面的方法：
            // withCheckedThrowingContinuation有几个注意点：
            // 1、withCheckedThrowingContinuation是被async标记的。因此我们必须使用await，当然这里因为是throw，所以也需要调用try。
            // 2、withCheckedThrowingContinuation里面是开启的子线程。
            // 3、withCheckedThrowingContinuation里面调用的没种情况，都必须要调用一次resume方法，不然会出现continuation leak。
            // 4、返回的类型必须跟resume(returning: )的类型一致。
            fetchNetworkCallBack(input: input) { result in
//                switch result {
//                case .success(let response):
//                    contitunation.resume(returning: response)
//                case .failure(let error):
//                    contitunation.resume(throwing: error)
//                }

                // 这里两种写法都是可以的，他相当于上面的代码。
                contitunation.resume(with: result)
            }
        }
        return a
    }

    private func fetchNetworkCallBack(input: Int, completion: (Result<String, Error>) -> ()) {
        sleep(3)
        if input > 0 {
            completion(.success("成功:\(input)"))
        } else {
            completion(.failure(NSError(domain: "失败", code: -1)))
        }

        
    }
}

struct TaskPage_Previews: PreviewProvider {
    static var previews: some View {
        TaskPage()
    }
}


/*
 actor。
 actor和struct和class一样的使用。
 Actors 是引用类型，简而言之，这意味着副本引用相同的数据。因此，修改副本也会修改原始实例，
 因为它们指向同一个共享实例。
 Actor 与类相比有一个重要的区别：它们不支持继承。
 然而，最大的区别是由 Actor 的主要职责定义的，即隔离对数据的访问。


 */
actor Counter {

    let name: String
    var count = 0
    init(name: String) {
        self.name = name
    }

    // 可能存在竞争关系
    func addCount() {
        count += 1
    }

    // 不会存在竞争关系
    nonisolated func getName() -> String {
        return name
    }
}
