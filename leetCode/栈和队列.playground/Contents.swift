import UIKit

//https://leetcode-cn.com/problems/valid-parentheses/
/*
 20. 有效的括号
 给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串，判断字符串是否有效。
 有效字符串需满足：
 左括号必须用相同类型的右括号闭合。
 左括号必须以正确的顺序闭合。
 注意空字符串可被认为是有效字符串。
 */
func isValid(_ s: String) -> Bool {
    var stack = [String.Element]()
    for c in s {
        if c == "(" || c == "[" || c == "{" {
            stack.append(c)
        } else if c == ")" {
            if stack.isEmpty { return false }
            if stack.last != "(" {
                return false
            } else {
                stack.popLast()
            }
        } else if c == "]" {
            if stack.isEmpty { return false }
            if stack.last != "[" {
                return false
            } else {
                stack.popLast()
            }
        } else if c == "}" {
            if stack.isEmpty { return false }
            if stack.last != "{" {
                return false
            } else {
                stack.popLast()
            }
        }
    }
    return stack.isEmpty
}
func betterIsValid(_ s: String) -> Bool {
    var stack = [String.Element]()
    let map: [String.Element: String.Element] = [")": "(", "]": "[", "}": "{"]
    for c in s {
        if let value = map[c] {
            if value != stack.last {
                return false
            } else {
                stack.popLast()
            }
        } else {
            stack.append(c)
        }
    }
    return stack.isEmpty
}

//https://leetcode-cn.com/problems/implement-queue-using-stacks/
/*
 232. 用栈实现队列
 使用栈实现队列的下列操作：
 push(x) -- 将一个元素放入队列的尾部。
 pop() -- 从队列首部移除元素。
 peek() -- 返回队列首部的元素。
 empty() -- 返回队列是否为空。
 示例:
 */
class MyQueue {
    
    class Stack {
        private var array = [Int]()
        func push(_ x: Int) {
            array.append(x)
        }
        func pop() -> Int {
            return array.popLast()!
        }
        func top() -> Int {
            return array.last!
        }
        func empty() -> Bool {
            return array.isEmpty
        }
    }
    
    private var inputStack = Stack()
    private var outputStack = Stack()

    /** Initialize your data structure here. */
    init() {
    }
    
    /** Push element x to the back of queue. */
    func push(_ x: Int) {
        inputStack.push(x)
    }
    
    /** Removes the element from in front of queue and returns that element. */
    func pop() -> Int {
        pour()
        return outputStack.pop()
    }
    
    /** Get the front element. */
    func peek() -> Int {
        pour()
        return outputStack.top()
    }
    
    /** Returns whether the queue is empty. */
    func empty() -> Bool {
        return inputStack.empty() && outputStack.empty()
    }
    
    private func pour() {
        guard outputStack.empty() else { return }
        while !inputStack.empty() {
            let input = inputStack.pop()
            outputStack.push(input)
        }
    }
}

//https://leetcode-cn.com/problems/implement-stack-using-queues/
/*
 225. 用队列实现栈
 使用队列实现栈的下列操作：

 push(x) -- 元素 x 入栈
 pop() -- 移除栈顶元素
 top() -- 获取栈顶元素
 empty() -- 返回栈是否为空
 */
class MyStack {
    
    class Queue {
        private var array = [Int]()
        func push(_ x: Int) {
            array.append(x)
        }
        func pop() -> Int {
            let first = array.first!
            array.removeFirst()
            return first
        }
        func peek() -> Int {
            return array.first!
        }
        func empty() -> Bool {
            return array.isEmpty
        }
        func size() -> Int {
            return array.count
        }
    }

    private var firstQueue = Queue()
    private var secondQueue = Queue()
    /** Initialize your data structure here. */
    init() {
    }
    
    /** Push element x onto stack. */
    func push(_ x: Int) {
        firstQueue.push(x)
    }
    
    /** Removes the element on top of the stack and returns that element. */
    func pop() -> Int {
        while firstQueue.size() > 1 {
            let value = firstQueue.pop()
            secondQueue.push(value)
        }
        let popValue = firstQueue.pop()
        firstQueue = secondQueue
        secondQueue = Queue()
        return popValue
    }
    
    /** Get the top element. */
    func top() -> Int {
        while firstQueue.size() > 1 {
            let value = firstQueue.pop()
            secondQueue.push(value)
        }
        let top = firstQueue.peek()
        let value = firstQueue.pop()
        secondQueue.push(value)
        firstQueue = secondQueue
        secondQueue = Queue()
        return top
    }
    
    /** Returns whether the stack is empty. */
    func empty() -> Bool {
        return firstQueue.empty() && secondQueue.empty()
    }
}
