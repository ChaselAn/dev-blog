# IAP接入与丢单处理

* 本文只记录消耗型项目的内购，非消耗型和订阅型项目没有接触过，暂不记录

## IAP接入

* 关于IAP在App Store Connect中的添加内购项目和添加沙盒测试员就不再说了，百度中很多教程。

* 要接入IAP内购，需要在项目配置中Capabilities中的In-App Purchase选项打开。

  ![IAPConfig](https://raw.githubusercontent.com/ChaselAn/dev-blog/master/Source/IAPConfig.png)

* iOS的IAP内购是通过StoreKit框架实现的，可以看一下相关的文档，能对IAP有更好的了解。

### IAP流程

* IAP的流程大致分为下面几步。

* 第一步：在账单队列中，添加事务的观察者，具体方法为`SKPaymentQueue.default().add(self)`。账单队列（SKPaymentQueue）是用来处理账单的一个队列，是IAP中最重要的一个元素。一次充值就可以理解为一个事务，我们需要观察整个充值的过程，就要对账单队列添加观察者，什么时候去添加观察者呢？苹果文档建议在应用启动时添加，我建议在用户登录后进行添加，添加过程要避免重复添加。

* 第二步：判断用户是否在系统设置中禁止应用内购买，如果用户禁用了，后面的流程都走不了。iOS12系统下这个设置在 设置>屏幕使用时间>内容和隐私访问限制>iTunes Store 与 App Store 购买项目 中。具体判断方法为`SKPaymentQueue.canMakePayments()`。

* 第三步：拿到商品的Identifier。这个Identifier是在App Store Connect配置的，建议存在服务器中，去服务器中获取，不建议直接通过常量写在项目中。

* 第三步：通过商品的Identifier，去苹果服务器拿到商品的信息。具体方法为：

  ```swift
  let request = SKProductsRequest(productIdentifiers: Set([productIdentifier]))
  request.delegate = self
  request.start()
  ```

  商品的信息是在代理方法`func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse)`中获得。

* 第四步：拿到商品信息后，生成账单（SKPayment），将账单放入账单队列中。

  ```swift
      public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
          let products = response.products
          guard !products.isEmpty else {
              // TODO: 弹框 商品不存在
              return
          }
          let payment = SKPayment(product: products[0])
          SKPaymentQueue.default().add(payment)
      }
  ```

  账单放入队列中之后，界面上就会显示苹果的一系列付款确认弹框。

* 第五步：接收界面上付款成功或者付款取消的事务回调，为什么能收到这个回调，是因为我们在第一步添加了观察者。我们需要在回调中根据事务的状态进行相应的处理。

  ```swift
      public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
          for transaction in transactions {
              switch transaction.transactionState {
              case .purchasing: // 充值中
                  break
              case .purchased, .restored: // 充值成功或者重新购买
                  transactionPurchased(transaction)
              case .failed: // 充值失败 付款取消
                  // 处理充值失败的情况
              case .deferred: // 交易延期
                  break
              }
          }
      }
  ```

  restored状态在消耗型项目中没遇到过，此状态一般用于非消耗型和订阅型项目。

  在充值失败的处理中，需要调用`SKPaymentQueue.default().finishTransaction(transaction)`方法，此方法是用来告诉账单队列，这个事务已经完成，如果不告诉队列已完成，这个事务会一直存在队列中，你也会一直在上面的事务回调方法中收到这个事务。

* 第六步：收到上面苹果服务器充值成功后的回调之后，再用商品Identifier去苹果服务器请求交易的收据，这个收据是用来向自己服务端验证此次交易是否入账。

  ```swift
      private func transactionPurchased(_ transaction: SKPaymentTransaction) {
          let productIdentifier = transaction.payment.productIdentifier
          guard !productIdentifier.isEmpty, let receiptURL = Bundle.main.appStoreReceiptURL else {
              SKPaymentQueue.default().finishTransaction(transaction)
              return
          }
          let configuration = URLSessionConfiguration.default
          configuration.timeoutIntervalForResource = 60
          let session = URLSession(configuration: configuration)
          session.dataTask(with: receiptURL, completionHandler: { [weak self] (data, _, _) in
              guard let data = data else {
                  // TODO: 失败弹框
                  return
              }
              let receiptData = data.base64EncodedString(options: .endLineWithLineFeed)
              self?.checkReceipt(receiptData)
          }).resume()
      }
  ```

  收据建议进行base64的加密再发给服务端去检验。

* 第七步：将收据发给服务端去验证此次交易是否入账，校验成功后，此次充值才算真正的成功，然后去刷新账户余额。检验成功后千万别忘记调用`SKPaymentQueue.default().finishTransaction(transaction)` 去通知账单队列事务完成。

## IAP丢单处理

### 什么是IAP丢单？

* IAP丢单就是用户付了钱，却没有收到货。

### 丢单是怎么造成的？

* 首先用户付款是在上面流程的第四步，用户付完款之后才会收到第五步的回调，如果我们在第四步用户付完款之后，后面的流程没有走或者出现了问题，就会造成丢单。
* 比如第六步中我们去苹果服务器请求收据出现断网情况，第七步中我们请求自家服务器出现断网情况，都无法通知服务端去校验交易入账，就无法给用户充值。

### 如何处理丢单？

* 在丢单是怎么造成的里面，我已经说过，丢单是因为第四步之后出现了问题，那么怎么处理呢？大家可以看一下第七步，在检验成功之后，我们会调用`SKPaymentQueue.default().finishTransaction(transaction)`方法，也就是说，在丢单情况下，我们是不会调用finish方法的。在第五步最后我已经说过，如果我们没有调用finish方法，这个账单会一直保存在账单队列中。
* 这样我们就有办法去解决丢单问题了，我们可以再合适的时候，移除账单队列的观察者，重新添加观察者，我们在重新添加观察者的时候，如果账单队列中有未完成的账单，会立即收到`func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])`的事务回调，如果是已经付款的丢单，会回调一个state为purchased的事务，这个时候在去将丢的账单重新发给服务端校验就可以了。什么是合适的时候去重新添加观察者呢？这个可以根据需求来定，可以再应用启动的时候，或者在下一次充值之前，或者网络状态切换的时候都可以。

### 怎么分辨丢的账单是否是当前用户？

* 如果用户在应用内有多个账号，我们怎么去确定，丢的账单是不是当前用户呢？

* 在IAP流程的第四步中，我们在生成账单时，可以看到SKPayment类中有一个属性可以供我们解决这个问题，就是`applicationUsername`属性，我们可以将当前用户的标识或者ID存到这个属性中。当然这个属性在SKPayment类中是只读类型，我们要用的是`SKMutablePayment`类。第四步生成账单的代码就要改成：

  ```swift
      let payment = SKMutablePayment(product: products[0])
      payment.applicationUsername = userID
      SKPaymentQueue.default().add(payment)
  ```

  同时在第六步处理付款成功的方法中去判断`applicationUsername`与当前用户的标识是否一致，一致的话才去处理丢单的校验。

