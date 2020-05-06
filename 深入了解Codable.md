# 深入了解Codable

## 什么是Codable

> A type that can convert itself into and out of an external representation.

* 来看苹果官文文档的解释：可以将自身转换为外部表示形式的类型。大体的意思就是一个对象和它的表示之间可以进行相互转换。

* 例如`Swift`中的结构体等数据对象在网络请求中的表现形式常用`JSON`去表示，`Codable`就可以将结构体对象与`JSON`进行相互转换。这也是`Codable`使用最多的一个场景。

* 现在来贴一段简单的代码，来看下他是怎么将结构体与`JSON`互相转换的

* ```swift
  // 首先定义一个结构体和json字符串
  struct Model: Codable {
      var name: String
      var id: Int
  }
  let model = Model(name: "chasel", id: 0)
  let jsonStr = """
  {
      "name": "chasel",
      "id": 172
  }
  """
  // 下面将json字符串转换成Model这个结构体
  let jsonData = jsonStr.data(using: .utf8)!
  let decoder = JSONDecoder()
  let modelRes = try! decoder.decode(Model.self, from: jsonData) // model就已经是一个Model类型的结构体实例了
  print(modelRes.name) // "chasel"
  
  // 下面将model对象转换成json字符串
  let encoder = JSONEncoder()
  let jsonResData = try! encoder.encode(model)
  let jsonRes = String(data: jsonResData, encoding: .utf8)
  print(jsonRes) // "{"name":"chasel","id":0}"
  ```

* 你会发现短短的三句代码就能实现结构体和`JSON`的互相转换。接下来我们来深入研究`Codable`

## 解剖Codable

* 我们在`Swift`的API文档里，可以看到`Codable`的定义

  ```swift
  public typealias Codable = Decodable & Encodable
  ```

  由此可以看出，`Codable`是一个别名，由`Decodable`和`Encodable`两个协议构成

### Decodable与Encodable

* 从字面上看，`Decodable`就是用来解码的，`Encodable`就是用来编码的，在上面的例子中，结构体转换成`JSON`的行为就是解码，反之就是编码。

* 我们从`Swift`的API文档中，就可以看到关于`Decodable`和`Encodable`两个协议的内容

  ```swift
  /// A type that can encode itself to an external representation.
  public protocol Encodable {
      func encode(to encoder: Encoder) throws
  }
  
  /// A type that can decode itself from an external representation.
  public protocol Decodable {
      init(from decoder: Decoder) throws
  }
  ```

* 由此我们可以猜测出，`Codable`是通过`Encoder`(编码器)和`Decoder`(解码器)来完成编码解码工作的。在上面的结构体与`JSON`互转的例子中，我们就用到了`JSONEncoder`和`JSONDecoder`两个用来专门处理`JSON`的解/编码器，来完成转换的功能。

* 





