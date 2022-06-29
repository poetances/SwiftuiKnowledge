
import SwiftUI

SwiftUI，声明式界面开发。

1、swiftui 中，我们声明的配置项，这点和flutter其实是很像的。而且使用结构体的话，也会降低性能的开销。真的的渲染我们是留给框架黑盒处理。

2、@State属性包装。我们看苹果的声明，其实就是结构体。

@State var showFavoritesOnly = true
Toggle(isOn: $showFavoritesOnly) {
    Text("Favious Only")
}

// State的本质
@frozen @propertyWrapper public struct State<Value> : DynamicProperty {
    public init(initialValue value: Value)

    public var value: Value { get nonmutating set }

    public var binding: Binding<Value> { get }

    public var delegateValue: Binding<Value> { get }
}

// 上面的代码，其实可以转换为如下
var showFavoritesOnly = State(initialValue: true)

Toggle(isOn: showFavoritesOnly.binding) {

}

if showFavoritesOnly.value {

}

// 总结：
>所以@State其实就是State struct的一种简写而已。State里对如何读写属性进行了定义，读取的话直接使用State.value就可以。
>而$showFavoritesOnly只是对showFavoritesOnly.binding进行简写而已。binding将创建showFavoritesOnly的一个引用，并将值传给Toggle
>而State的value didSet将触发body的刷新。
>@State只能修饰值类型。如果修饰引用类型，可能没有效果。
>@State需要用private 修饰，同时，只能用于view和子View。
当我们@State创建一个属性时，我们会将其控制权交给SwiftUI，这样只要试图存在，它就会存在内容中保持持久性。

3、@Binding主要作用
>在不持有数据源的情况下，任意读取
>从State获取数据，并保持同步
>对包装值采用传址而不是传值

>常见使用就是配合@State使用。

4、ObservableObject。 是一个协议，类似RxSwift发布者和订阅者模式。
(public protocol ObservableObject : AnyObject {} )
>ObservableObject是一个协议，必须要类实现改协议。适用于多个ui之间的数据同步。
>在实际开发中，很多数据其实并不是在View内部产生，这些数据可能是一些本地数据，或者一些网络数据，
    这些数据默认和Swiftui没有关系，而且也不能使用@State进行修饰。所以想要与SwiftUI建立联系，就需要
    用到ObservableObject，同时需要配和@ObservedObject和@Publish两个修饰符。
>@Published修饰的属性一旦发生了变化，会自动触发ObservableObject的objectwillChange的send方法，刷新
    页面，这一步是系统帮我们实现的。
>@ObservedObject：被观察者对象，告诉SwiftUI，这个对象是可以被观察的，里面包含了被@Published包含的属性。
>@ObservedObect包装的对象，必须遵循ObserveableObject协议。也就是必须是class，而不能是struct。
>@ObservedObject允许外部进行访问和修改。

// 这点很重要
因为ObservedObject不拥有ObservableObject的生命周期，所以引入StateObject。
当我们将一个属性用StateObject声明时，它提供一个初始值，SwiftUI将会在第一次执行body内容前初始化这个值。
SwiftUI将会在view的生命周期中保持这个对象一直存在。


5、EnvironmentObject。包装的属性是全局的，整个app都能使用。
>主要是为了解决跨组件数据传递问题。
>组件层级嵌套太深，就会出现数据逐级传递的问题，@EnvironmentObject可以帮助组件快速访问全局数据，避免不必要
    的组件数据传递问题。
>使用基本上和@ObservedObject一样，但@EnvironmentObject突出强调此数据将由某个外部实体提供，所以不需要初始化，
    一般由外部提供。
>使用@EnvironmentObject，SwiftUI将立即在环境中搜索正确类型对象。如果找不到这样的对象，程序会立即崩溃，所以要
    谨慎使用。
    
6、StateObject。包装属性和ObservedObject的区别。


##所以一般Property、@State、@Binding一般修饰的都是View内部的数据。
##@ObservedObject、@EnvironmentObject都是修饰View外部的数据：
##    比如本地数据、网络数据等。


@propertyWrapper @frozen public struct ObservedObject<ObjectType> : DynamicProperty where ObjectType : ObservableObject { }

@frozen @propertyWrapper public struct EnvironmentObject<ObjectType> : DynamicProperty where ObjectType : ObservableObject { }

public protocol ObservableObject : AnyObject {}

#####
在SwiftUI中构建一个View的结构体实例只是短暂的存在，当View被渲染到屏幕上后，这个结构体实例就会被销毁。

当我们用State来标记一个属性时，SwiftUI会接管这个属性的storage。上面提到，SwiftUI中views是短暂存在的，当它们完成渲染后就会销毁，但是当我们标记其中的属性为State时，SwiftUI会维护这个属性，当属性发生改变时，SwiftUI会重新生成对应的view实例，然后根据这个属性值再次渲染。

7、SceneStore和AppStore。
    AppStore属性包装器，通过UserDefault来进行存储。
    @AppStorage("emailAddress") var emailAddress: String = "sample@email.com"
    // 这句话的意思，通过UserDefaults.standard.string(forKey: "emailAddress")来获取值，
    如果有就取值，就将值赋给emaailAddress变量，如果没有就给默认值“sample@email.com”

    
    类似
    @State var emailAddress: String = "sample@email.com" {
    get {
        UserDefaults.standard.string(forKey: "emailAddress")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "emailAddress")
    }
}

7、Swift package manager。即SPM的使用。通过SPM来替代cocoapod进行package管理。
    这里肯定有个问题，就是去github上面拉取资源，但是实际上，xocode是不能使用代理的，这样
    就会导致updating package会特别慢。
    
8、关于静态库和动态库。静态库有.a  .framework。 动态库有.tylb  .framework。
    区别静态库加载和执行速度更快。
    动态库更加节省资源。
    静态库在编译时加载，动态库在运行时加载。
    
    import和include其实就是将.h头文件的内容拷贝一份到当前文件中。
    
    在使用方面，如果是静态库，直接将代码拖入项目中就可以使用。
    如果是动态库，必须要将framework进行配置，即添加到Framework、libary和embedded content里面才能使用。
    
.a文件：是一个静态库文件，是目标文件.o的集合，经过链接可生成可执行文件。
.dylib文件：是一个动态库文件。
.framework文件：Framework是Mac OS/iOS平台特有的文件格式。Framework实际上是一种打包方式，将库的二进制文件、头文件和有关的资源打包到一起，方便管理和分发。Framework有静态库也有动态库，静态库的Framwork = .a+头文件+资源文件 + 签名；动态库的framework=.dylib+头文件+资源文件 + 签名。
我们自己创建的Framework和系统的Framework比如（UIKit.framework）还是有很大的区别的。系统的Framework不需要拷贝到目标程序中，我们自己做出来的Framework哪怕是动态库的，最后也还是要拷贝到APP中（APP和Extension的Bundle是共享的），因此苹果又把这种Framework称为Embedded Framework。
Embedded Framework 开发中使用的动态库会被放入ipa下的framework目录下，基于沙盒运行。不同的APP使用相同的动态库，并不会只在系统中存一份，而是会在多个app中各自打包、签名、加载一份。

5.30
1、ModeifiedContent值，修饰器的深层嵌套。
    我们在按钮上使用padding、background和cornerRadius Api并不会简单的取更改按钮的属性。实际上，这些方法（我
    们通常称其为“修饰器”）的调用都会在view树上创建新的一层。在按钮上调用.padding() 会将按钮包装为
    ModeifiedContent类型的值，这个值中包含有关应该如何设置padding填充的信息。在该值上再调用 .background，又会把现有值包装起来，创建另一个 ModifiedContent 值，这一次将添加有关背景色的信息。
    很可能会出现：
    ModifiedContent<ModifiedContent<Text, _FlexFrameLayout>, _EnvironmentKeyWritingModifier<Optional<Color>>>, _EnvironmentKeyWritingModifier<Optional<Font>>>
    这样的结果。
    
2、swifui渲染原理。
    swiftui中的View是一个协议，需要遵循body协议。
    当我们界面需要刷新的时候，通过state进行状态管理，当state改变，我们发现是会调用body的。
    也就是说，声明一个属性时，SwiftUI会将当前属性的状态与对应视图的绑定，当属性的状态发生改变的时候，
    当前视图会销毁以前的状态并及时更新，
    
    需要理解的重要一点是，当我们将修改器应用于视图时，我们并没有直接修改它。没有要真正修改的属性。
    相反，当应用修改器时，会返回一个ModifiedContent，它包装了我们应用修改器的视图。
    比如：
    let view = Rectangle().frame(width: 100, height: 100)
    type(of: view) // ModifiedContent<Rectangle, _FrameLayout>

    // ModifyContent，其实结构很简单
    struct ModifiedContent<Content, Modifier> {

        var content: Content
        var modifier: Modifier
    }

    请注意，Modified Content在其声明中没有实现View协议。相反，ModifiedContent根据Content和Modifier
    通用属性实现的协议实现了不同的协议。这种方法使ModifiedContent本身尽可能简单，同时允许其可扩展。

    ModifiedContent实现View，例如，当Content和Modifier分别实现View和ViewModifier协议时。
    extension ModifiedContent: View where Content: View, Modifier: ViewModifier 
    { ... }

    Scene和Widget的ModifiedContent也以相同的方式实现，但使用SceneModifier和WidgetModifier。
    ViewModifer是一个协议，唯一的要求是一个body功能。
    public protocol ViewModifier {
        associatedtype Body : SwiftUI.View
        func body(content: Self.Content) -> Self.Body
    }
    
3、关于视图View。
    struct ContentView: View {
        var body: some View {
            Text("Hello, world!")
                .background(Color.yellow)
                .font(.title)
                .dump()
        }
    }

    extension View {
        func dump() -> Self {
            print(Mirror(reflecting: self))
            return self
        }
    }
    打印结果：
    Mirror for ModifiedContent<ModifiedContent<Text, _BackgroundModifier<Color>>, _EnvironmentKeyWritingModifier<Optional<Font>>>

    struct ContentView_: View {
        var body: some View {
            Group {
                if true {
                    Color.yellow
                } else {
                    Text("Impossible")
                }
            }
            .dump()
        }
    }
    打印结果：
    Mirror for Group<_ConditionalContent<Color, Text>>
    虽然Text永远不会变得可见，但它仍然存在于_ConditionalContent<Color, Text>.
    
4、swiftui中的color。 extension Color : ShapeStyle {}
    extension Color : View {}

5、async/await、actor。 
    actor的引入其实就是为了解决数据争夺的。


6.2
1、PreferencKey。
    PreferenceKey是一个协议：
    public protocol PreferenceKey {

        associatedtype Value
        // 默认值
        static var defaultValue: Self.Value { get }
        // 主要是处理，当父试图找到多个值时候，value值应该怎么处理。
        static func reduce(value: inout Self.Value, nextValue: () -> Self.Value)
    }
    我们发现其实很简单，就一个defaultValue和reduce方法。
    a>首先PreferenceKey是为了解决子视图传信息给父试图的。
    b>工作原理也很简单，就是通过key-value的方式进行传值。
    c>经常配合onPreferenceChange一起使用，父试图通过onPreferenceChange来获取子类传的值。
    d>当然还有overlayPreferenceValue、backgroundPreferenceValue等modify可以使用。
    d>注意Anchor的使用。Anchor其实是一个结构体。

2、Swiftui布局流程分为三个步骤：
    1、父试图将为子视图提供建议大小。
    2、子视图会选择自己的大小。（注意，在swiftui中，父试图无法强制其子视图设置大小，因为必须尊重子视图）
    3、然后，父试图需要将子视图放置在其自己的坐标空间中的某个位置。默认会放在中心。


3、GeometryReader。它将占用父级给出的建议大小。
    GeometryReader其实和ZStack有点像，但是不能设置aligment属性，而且默认是对方在左上角的。
    GeometryReader中GeometryProxy，直接获取size，就是当前试图的size，其实和geo.frame(in: .loacal)、geo.frame(in: .global)获取的size是一样的。
    但是其frame的x、y这些肯定是不一样的。
    特点就是：
    .gloabal是相对屏幕的空间。
    .loacal是相对父试图的控件。
    相对于其它试图，可以使用自定义空间。


6.6
1、ViewBuilder。
    @_functionBuilder struct ViewBuilder，可能结果构造器
    
    @available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
    extension ViewBuilder {
        public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleView<(C0, C1)> where C0 : View, C1 : View
    }

    @ViewBuilder有一个静态buildBlock方法，改方法接受两个试图，将它们组合并返回TupleView。
    当然它还有其它BuildBlock方法，它接受1到10个子视图，它们都将子视图组合成一个TupleView。这就是为什么@ViewBuilder最多只能接受十个视图的原因。
    
    @ViewBuilder还能通过if和switch表达式的支持。

2、Mirror反射
    public struct Mirror {

          public enum DisplayStyle {
            case `struct`, `class`, `enum`, tuple, optional, collection
            case dictionary, `set`
          }
    
        // 表示类型，被反射主体的类型
        public let subjectType: Any.Type

        // 所有的熟悉
        public let children: Children

        // 显示类型，基本类型为nil 枚举值: struct, class, enum, tuple, optional, collection, dictionary, set
        public let displayStyle: DisplayStyle?

        /// 父类反射， 没有父类为nil
        public var superclassMirror: Mirror? {
          return _makeSuperclassMirror()
        }
    }
    
    // 如果是oc的话，是基于runtime的，所以获取动态类型及成员信息是很方便的。 但是swift静态语言，要动态获取属性这些就必须借助Mirror这个结构体。

3、Environment获取系统环境设置的。 当我们Swiftui创建第一个View的时候，系统就已经创建了一个Environment。

    SwiftUI使用Environment来传递系统范围的设置，例如ContentSizeCategory、LayoutDirection、ColorScheme等。

4、Modifier。
    我们都知道，每次一个View进行.xxxx操作的时候，都会生成一个新的ModifiedContent。这个是最基本的原理。
    每次我们将Modifier应用到SwiftUI视图时，我们实际上创建了一个应用了该Modifier的新的视图（注意：并不会在原地修改现有视图)。如果我们仔细想想，这种行为是
    很有道理的：我们的View其实是struct，保存的也是确切的属性，所以如果我们设置背景颜色或者字体大小，就没有地方存储这些数据了。
    比如：
    Button("Hello, world!") {
    // do nothing
    }    
    .background(.red)
    .frame(width: 200, height: 200)
    
    上面的代码并不会生成带有"Hello，world"的200*200红色按钮。这点和UIKit是有很大差别的。 
    我们其实看到的是200*200的空放个，上面是红色矩形，红色矩形里面是“Hello,wrold”


6.8
1、UIKit和SwiftUI混合开发。
    UIKit使用SwiftUI，通过UIHostingController进行包装。
    SwiftUi使用UIKit，通过UIViewRepresentable来添加。

2、Github现在不让使用密码登录，需要使用token登录，这里就有点麻烦，登录还好，但是如果要进行push和pull的认证就很麻烦。所以我们最好使用ssh进行认证。
    首先要github上配置ssh。 其实配置完成后，mac电脑下面~/.ssh里面会有isa_xxx的文件，同时github -> setting -> ssh上面就会有相应的key。
    这样我们在配置项目，时候就可以将url 替换为 git:xxxx 这样的路径。不要使用https。
    
6.28
1、PropertyWrapper。是swift新增的特性。其目的就是移除一些多余、重复的代码。

