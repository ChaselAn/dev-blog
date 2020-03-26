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
