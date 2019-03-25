# 通过Cocoapods在iOS项目中集成Flutter

* 当前环境Xcode：10.1，Flutter：1.3.14-pre.66

## 创建iOS项目

* 创建一个空的iOS项目FlutterDemo，或者使用老项目。
* 集成cocoapods
* ![podinit](https://raw.githubusercontent.com/ChaselAn/dev-blog/master/Source/flutter_podinit.png)

## 创建Flutter模块

```ruby
$ cd xxx/FlutterDemo
$ flutter create -t module flutter_module
```

## 修改Podfile

* 在podfile文件中添加代码

* ```ruby
  flutter_application_path = '../flutter_module'
  eval(File.read(File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')), binding)
  ```

* ![podinit](https://raw.githubusercontent.com/ChaselAn/dev-blog/master/Source/flutter_podfile.png)

* 然后pod install

##  配置iOS项目

* 打开iOS项目，在targets中Build Phases里点击 + 号按钮，选择New Run Script Phase。

* ![podinit](https://raw.githubusercontent.com/ChaselAn/dev-blog/master/Source/flutter_buildphases.png)

* 添加以下脚本

* ```shell
  "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build
  "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" embed
  ```

* ![podinit](https://raw.githubusercontent.com/ChaselAn/dev-blog/master/Source/flutter_runscript.png)

* 在Build Settings中，将Enable Bitcode改为No
* ![podinit](https://raw.githubusercontent.com/ChaselAn/dev-blog/master/Source/flutter_bitcode.png)
* 最后Command + B，编译项目

## 测试

* 尝试在ViewController中present一个FlutterViewController

* ```swift
  import UIKit
  import Flutter
  
  class ViewController: UIViewController {
  
      override func viewDidLoad() {
          super.viewDidLoad()
  
      }
  
      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          present(FlutterViewController(), animated: true, completion: nil)
      }
  }
  ```

* 出现以下页面，集成成功！😄

* ![podinit](https://raw.githubusercontent.com/ChaselAn/dev-blog/master/Source/flutter_vc.png)

## 热重载(hot reload)

* 不借助其他IDE的情况下，只在Xcode环境中进行hot reload需要在终端中实现

* 首先停止运行项目，执行终端命令

```ruby
$ cd xxx/FlutterDemo/flutter_module
$ flutter attach
```

* 等出现`Waiting for a connection from Flutter on iPhone XS…`这句话时运行项目
* 可以看到控制台如下信息

```ruby
To hot reload changes while running, press “r”. To hot restart (and rebuild state), press “R”.
An Observatory debugger and profiler on Android SDK built for x86 is available at: http://127.0.0.1:61513/
For a more detailed help message, press “h”. To detach, press “d”; to quit, press “q”.
```

* 修改/FlutterDemo/flutter_module/lib/main.dart文件，在命令行输入r，查看hot reload效果。