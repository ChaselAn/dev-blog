# Swift

* <iOS 10>iOS10中(更低的版本可能也是这样)，UIButton在init方法中，layer.insertSublayer(gradientLayer, at: 0)，这时如果button.setBackgroundImage(.iconLoginNormal, for: .normal)，gradientLayer会显示在最上层，需要在layoutSubviews方法中插入才可以。具体原因需要在深入了解。

* <iOS 10>较大的音频文件创建AVURLAsset时，获取asset.duration是0，需要用以下方法创建才可以获得准确的duration

  ```swift
  let asset = AVURLAsset(url: fileURL, options: [AVURLAssetPreferPreciseDurationAndTimingKey: NSNumber(value: true)])
  ```

* <iOS 10>iOS10中(更低的版本可能也是这样), PHImageManager及其子类不能提前创建并引用，否则当没有相册权限时会crash。如果需要引用，建议使用lazy去懒加载，不需要引用时，需要用到时再去创建。怀疑是因为内部释放的顺序导致。

* 集合类型的线程安全问题：Swift中集合类型内部并没有自带读写的线程安全，当涉及到多线程的读写时，需要自己控制线程安全。

* Swift4.2的项目升级Swift5.0时，笔者猜测，Swift4.2版本中集合类型读写可能做了一些线程安全的锁(只是猜测，有兴趣的话可以去看下源码)，Swift5.0可能为了性能移除了这些，导致项目中如果之前没有控制集合类型的线程安全，Swift5.0崩溃率会大幅增高，所以升级项目时一定要告知测试组同学，做好压力测试等，避免不必要的崩溃。

# Texture

* <version 2.6>如果给ASTextNode同时设置了maximumLine和paragraphStyle的lineSpacing，lineSpacing不会生效，可以使用lineHeightMultiple代替，或者使用ASTextNode2代替。
  But！ASTextNode2会有一些其他的问题，例如其他控件响应失效。

* <version 2.6,iOS 11.3>Texture里的ASTextNode如果实现了

  ```swift
  - (BOOL)textNode:(ASTextNode *)textNode shouldLongPressLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point;
  ```

  为true时，如果点击了一个不带有link的attribute的区域，会crash。可以考虑自定义一个longPressGesture来实现自己的功能。

* <version 2.7,iOS 11.4>ASTableNode的机制是每次刷新数据源时，都会创建新的ASCellNode，将旧的ASCellNode释放掉，然而，测试发现，tableNode会hold住两次cellNode，当第二次刷新的时候，才会释放掉第一次本应该释放的cellNode，注意此处的坑，当cellNode监听某些事件时，不要以为只有当前的cellNode在监听，之前还没释放的并且不再界面上显示的那个cellNode也在监听，监听操作中建议使用tableNode.visibleNodes.contains(self)判断一下再去做操作。

# Git

* rebase 之后不要用 push -f (force) 而是尽量用 --force-with-lease 来代替
  [https://www.oschina.net/translate/12-git-tips-gits-12th-birthday](https://www.oschina.net/translate/12-git-tips-gits-12th-birthday)详见该文章的第6条
* revert操作后再次merge，代码会有被冲掉的问题，revert需谨慎

# Cocoapods

* Pod版本1.5.3升级到1.6.1之后，如果项目中是多target的模式，或者多framework的模式，在Podfile文件中需要将其他target(framework)用到的pod库也添加到主target中。

  ```ruby
  # 主target
  target 'App' do
    pod 'EasyPeasy'
  end
  
  # 其他的target(framework)
  target 'Data' do
    pod 'Alamofire'
  end
  ```

  ——————————>

  ```ruby
  # 主target
  target 'App' do 
    pod 'EasyPeasy'
    pod 'Alamofire'
  end
  
  # 其他的target(framework)
  target 'Data' do
    pod 'Alamofire'
  end
  ```

  如果不添加可能会报下面两种错误：

  1.`ld: framework not found 'Alamofire'`

  2.`dyld: Library not loaded: @rpath/Alamofire.framework/Alamofire`

    `Referenced from: /Users/chaselan/Library/Developer/Xcode/DerivedData/App-dxkseibbwfgjgtabcdefgzpsfogf/Build/Products/Debug-iphonesimulator/Data.framework/Data`

   `Reason: image not found`
  
# Jenkins

## You cannot run CocoaPods as root问题

* 在`centos`环境中配置`jenkins`的时候，通过`rubygem`安装了`cocoapods`，如果是root用户，执行`pod`命令时，会报`You cannot run CocoaPods as root`的错误，这个时候需要使用其他用户来执行`pod`命令。
  
* 如果`jenkins`的配置文件中的`JENKINS_USER`也是root的话，再执行`jenkins`自动打包的`shell`脚本里，`pod`命令就会报上面的错误，因为你的`jenkins`是用root用户的来执行的，但是root用户又无法执行`pod`命令
  
* 解决方案：将`/etc/sysconfig/jenkins`目录的配置文件的`JENKINS_USER`值改成其他用户，比如改成默认的jenkins用户，同时修改目录的相应权限：
  
  ```ruby
    sudo chown -R 用户名(比如修改后的jenkins) /var/log/jenkins
    sudo chgrp -R 用户名 /var/log/jenkins
    sudo chown -R 用户名 /var/lib/jenkins 
    sudo chgrp -R 用户名 /var/lib/jenkins
    sudo chown -R 用户名 /var/cache/jenkins
    sudo chgrp -R 用户名 /var/cache/jenkins
  ```
  
    