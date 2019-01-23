# 浅谈APP架构—MVC

* 本文以iOS为例，Android大佬请自行理解
* 本文将简单讲讲关于APP架构的理解，以及对MVC的认识，对于iOS另一比较流行的MVVM-Rx架构会在后面为大家解析。

## 什么是APP架构

### APP反馈回路

* 在说什么是APP架构之前，我先问一个问题，APP中最核心的两个元素是什么？
* 在APP中最核心的两个元素就是数据和界面，APP其实就是将数据展现在界面上，然后通过对界面的操作来操作数据。这么一系列操作就是APP的反馈回路。

![image-20190122143047155](https://raw.githubusercontent.com/ChaselAn/dev-blog/master/Source/ModelAndView.png)

* 上图就是APP的反馈回路简图。View代表着界面，项目里所有继承自UIView的控件都可以看做是View，Model代表着单一数据或者是数据管理中心。View负责将数据展示出来，当View发生了操作（View Action），通过一系列内部逻辑（Model Action）改变了数据Model，Model发生改变之后再通知（Change Notification）View去更新（View Update）。这就是一套完整的APP反馈回路。

### 存在的问题

* 那么，这种只有View和Model的最基础的模式有什么问题吗？
* 首先，View如果要操作Model，有两种方式。第一种方式是View引用Model的实例对象，直接修改Model。Model修改之后也是通过引用View的实例对象，去更新View。第二种方式则是通过通知的方式，也就是观察者模式，当View发生操作之后，通知Model去修改，Model修改之后再通知View去更新。
* 这两种方式有什么问题呢，首先需要讲一下APP应该如何去设计View与Model。首先一个优秀的View，内部是不包含任何业务逻辑的，View的职责本身就是展示，View只需要提供可以供外界更新自身的方法就够了。为什么View不能包含任何业务逻辑，是因为APP本身就有很多相似的界面，这些界面大多数都是重用同一个View，而这个View在不同界面下可能包含的逻辑不同，如果改动了View的一个逻辑，可能会影响到很多不同界面，牵一发而动全身。并且View的本质只是去做展示和响应事件，它不关心任何业务逻辑，也不关心数据如何更改。同样的，Model只是负责去管理数据、处理数据，它同样不关心View的任何操作。
* 所以上面第一种方式，会使Model与View耦合在一起，又会造成相互引用，处理不好会造成内存泄漏。同时高耦合会造成两者的独立性极差。第二种方式View与Model处理了原本不属于不应属于自己的逻辑，破坏了自己的重用性。
* 知道了这些问题，怎么去解决？这就涉及到了我们的APP架构。那么什么是APP架构呢？

### APP架构的理解

* 我对APP架构的理解是，人们发现上面这些问题之后而提出的解决方案，这个方案被大部分人所认可，并达成共识。这些各种各样的方案本质上都是为了使APP项目内的代码更加健壮。
* 架构是一个APP项目的基础与核心，相当于楼房的地基。没有一个好的地基，房子很容易就造的歪歪扭扭。没有一个好的架构，或者没有严格的去遵守这些架构规则，当你的项目越来越庞大时，你会发现你的项目会越来越难以维护。

## MVC

### 什么是MVC？

* APP架构我们将从MVC开始分析，为什么从MVC开始呢，因为MVC架构是APP架构中最简单、也是最常用的一个架构模式，同样也是苹果Cocoa框架的认证模式，是现有的很多架构模式的一个基准线。

* 那么，什么是MVC呢，MVC的全名是Model View Controller，是模型(model)－视图(view)－控制器(controller)的缩写。这三个字母代表了三个层级，顾名思义，Model层就是数据管理层，负责去管理数据，处理数据。View层就是UI层，负责展示数据，响应事件。Controller层就是控制器层，负责协调View与Model，传递数据，处理业务逻辑。

* > MVC 基于经典的面向对象原则：对象在内部对它们的行为和状态进行管理，并通过类和协议的接口进行通讯；view 对象通常是自包含且可重用的；model 对象独立于表现形式之外，且避免依赖程序的其他部分。而将其他两部分组合起来成为完整的程序，则是 controller 层的责任。
  >

* 那么这个模式数据是怎么通讯的呢？见下图

  ![image-20190122143047155](https://raw.githubusercontent.com/ChaselAn/dev-blog/master/Source/MVCcommunication.png)

* 在MVC中，View不直接引用Model对象，Model对象是会被存储在View Controller中，View Controller将Model对象的相关属性值提取出来，进行变形，然后设置到它持有的View中去。

* 在MVC中观察者模式尤为重要，View Controller负责观察Model，而对于View的变更应该发生在观察的回调中。

* > 观察者模式是在 MVC 中维持 model 和 view 分离的关键。这种方式的优点在于，不论变更究竟是源自哪里 (比如， view 事件、后台任务或者网络)，我们都可以确信 UI 是和 model 数据同步的。而且，在遇到变更请求时，model 将有机会拒绝或者修改这个请求。

### 举个🌰

* 在大体了解了什么是MVC之后，我们将以一个UITableView的cell的删除操作为例，来具体描述MVC的数据是如何通讯的。（[本文的例子链接](https://github.com/ChaselAn/iOSArchitecturesDemo)）

  ![image-20190122143047155](https://raw.githubusercontent.com/ChaselAn/dev-blog/master/Source/MVCDeleteDemo.png)

* 首先我们点击了“delete”按钮，这一步就是View响应用户的操作发送了View Action。

  ```swift
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          guard editingStyle == .delete else { return }
          let repo = model.repositories[indexPath.row]
          model.removeRepo(id: repo.id)
      }
  ```

* 当Controller接收到View Action时，会调用它持有的Model对象的removeRepo方法，这个时候我们是不能操作table view进行deleteRows的View更新操作的。View的更新操作只能发生在Model改变之后的观察者的回调中。

* Model在接受到更改Model的指令后，会进行数据的管理，删除对应的数据，并进行本地的缓存（本地的缓存不是必须的，根据自身的业务需求决定）。

  ```swift
  func removeRepo(id: String) {
          if let index = repositories.firstIndex(where: { $0.id == id }) {
              repositories.remove(at: index)
              MVCStore.shared.save(self, userInfo: [
                  MVCModel.changeReasonKey: ChangeReasonKey.deleteRepo(index: index)
                  ]
              )
          }
      }
  
  class MVCStore {
  
      static let shared = MVCStore()
      private(set) var model: MVCModel
  
      static let changedNotification = Notification.Name("StoreChanged")
      private let diskPath = "MVCStore"
  
      private init() {
          if let data = try? Disk.retrieve(diskPath, from: .documents, as: MVCModel.self) {
              self.model = data
          } else {
              self.model = MVCModel.mock()
          }
      }
  
      func save(_ model: MVCModel, userInfo: [AnyHashable: Any]) {
          try? Disk.save(model, to: .documents, as: diskPath)
          NotificationCenter.default.post(name: MVCStore.changedNotification, object: model, userInfo: userInfo)
      }
  }
  ```

* 我们在进行了一系列数据更改以及缓存之后，会发送通知，告诉它的观察者 View Controller，数据已经变更。View Controler 收到Model发来的通知之后，就要更新相应的View。

  ```swift
  override func viewDidLoad() {
          super.viewDidLoad()
          NotificationCenter.default.addObserver(self, selector: #selector(handleStoreChanged), name: MVCStore.changedNotification, object: nil)
      }
  
  @objc private func handleStoreChanged(notification: Notification) {
          guard let reason = notification.userInfo?[MVCModel.changeReasonKey] as? MVCModel.ChangeReasonKey else { return }
          switch reason {
          case .deleteRepo(index: let index):
              tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
          }
      }
  ```

### MVC存在的问题

* MVC是iOS开发中阻力最低的架构模式，在所有模式中，MVC通常都是代码量最少，设计开销最小的模式。那么MVC有什么缺点吗？
* 第一个缺点在于观察者模式的失效问题，当围绕Model的观察者模式没有被完美执行时，Model和View的同步可能会失效。常见的错误是，我们在变更Model的同时去变更了View，View更新时并没有等到Model的通知，当Model拒绝了这个变更时，View就进行了错误的变更。另一个常见错误是，在构建View时读取了Model值，却没有对后续Model的变更进行订阅。
* 第二个缺点在于MVC模式只能进行集成测试，集成测试的书写比较复杂，因为它不仅仅测试逻辑，也测试了各个部件如何连接。
* MVC最重要的缺点在于View Controller的肥大化。因为View Controller不仅要处理View层的展示、设置属性等，还需要负责Model层的获取数据已经数据的订阅等，很多的业务逻辑都会放在View Controller中，会导致当我们的界面比较复杂的时候，View Controller的代码越来越多，而变得难以管理。
* 为了解决肥大化的问题，衍生了很多其他架构，例如MVP、MVVM等，大家可以自行去学习，这里将不再具体分析。

## 网络层应该放在哪里

<未完待续>

