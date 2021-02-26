# Swift

* <iOS 10>iOS10中(更低的版本可能也是这样)，UIButton在init方法中，layer.insertSublayer(gradientLayer, at: 0)，这时如果button.setBackgroundImage(.iconLoginNormal, for: .normal)，gradientLayer会显示在最上层，需要在layoutSubviews方法中插入才可以。具体原因需要在深入了解。

* <iOS 10>较大的音频文件创建AVURLAsset时，获取asset.duration是0，需要用以下方法创建才可以获得准确的duration

  ```swift
  let asset = AVURLAsset(url: fileURL, options: [AVURLAssetPreferPreciseDurationAndTimingKey: NSNumber(value: true)])
  ```

* <iOS 10>iOS10中(更低的版本可能也是这样), PHImageManager及其子类不能提前创建并引用，否则当没有相册权限时会crash。如果需要引用，建议使用lazy去懒加载，不需要引用时，需要用到时再去创建。怀疑是因为内部释放的顺序导致。

* <iOS 12>iOS12中，使用同一个webView加载不同的页面时，比如先load一个页面，然后stopLoading，重新load一个新的页面，偶现在didFailProvisionalNavigation代理中返回`Error Domain=NSPOSIXErrorDomain Code=53 "Software caused connection abort"`错误，并且不走didFinish的代理。处理方式：可以捕捉这个错误，进行重新reload。

  ```swift
  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
          if let posixError = (error as? POSIXError), posixError.code == .ECONNABORTED {
  //            Error Domain=NSPOSIXErrorDomain Code=53 "Software caused connection abort"
              // ios 12中会出现这个错误，导致webView报错时不返回finish的代理，导致UI一直转菊花中
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                  webView.reload()
              }
              return
          }
      }
  ```

* <iOS 13>如果UITableViewCell中有UIActivityIndicatorView，并且当indicator正在转动的时候，该cell划出了屏幕，会调用stopAnimating方法，会导致indicator停止转动，甚至消失(前提是hidesWhenStopped为true)。解决方法：记一个状态，在cell重新出现的时候，如果需要还没转完，重新调用startAnimating方法。

* <iOS 12>在ios12中，`UIActivityIndicatorView`就算设置了isHidden = true，如果重新添加在view上，仍然会出现在界面上，并且是转动状态。iOS 13中无此问题。解决方案，isHidden = true的同时，调用stopAnimating()

# Texture

* ~~<version 2.6>如果给ASTextNode同时设置了maximumLine和paragraphStyle的lineSpacing，lineSpacing不会生效，可以使用lineHeightMultiple代替，或者使用ASTextNode2代替。
  But！ASTextNode2会有一些其他的问题，例如其他控件响应失效。~~

* <version 2.6,iOS 11.3>Texture里的ASTextNode如果实现了

  ```swift
  - (BOOL)textNode:(ASTextNode *)textNode shouldLongPressLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point;
  ```

  为true时，如果点击了一个不带有link的attribute的区域，会crash。可以考虑自定义一个longPressGesture来实现自己的功能。

* <version 2.7,iOS 11.4>ASTableNode的机制是每次刷新数据源时，都会创建新的ASCellNode，将旧的ASCellNode释放掉，然而，测试发现，tableNode会hold住两次cellNode，当第二次刷新的时候，才会释放掉第一次本应该释放的cellNode，注意此处的坑，当cellNode监听某些事件时，不要以为只有当前的cellNode在监听，之前还没释放的并且不再界面上显示的那个cellNode也在监听，监听操作中建议使用tableNode.visibleNodes.contains(self)判断一下再去做操作。

* <version 2.8.1,iOS 12.3>使用`transitionLayout(withAnimation: Bool, shouldMeasureAsync: Bool, measurementCompletion: (() -> Void)?)`方法重新布局node时，如果使用shouldMeasureAsync为true进行异步layout时，在前面去修改子node的属性时，有可能会失败，例如

  ```swift
      func setMemberActionType(_ type: MemberActionType) {
          switch type {
          case .add:
              lastMemberNode.image = .iconConversationMembersAdd // image的修改可能会失败
          case .see:
              lastMemberNode.image = .iconConversationMembersSee // image的修改可能会失败
          }
          transitionLayout(withAnimation: true, shouldMeasureAsync: true, measurementCompletion: nil)
      }
  ```

  解决方案是使用shouldMeasureAsync为false的同步layout，或者在将修改node的属性的代码放在`DispatchQueue.main.async {}`中
  
* <version 2.8.1,iOS 13>在ASCellNode中添加一个ASButtonNode，如果频繁的对buttonNode设置图片，有图片消失并且设置不成功的可能，如果出现此问题，建议使用ASImageNode添加手势来实现功能。

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
  
    