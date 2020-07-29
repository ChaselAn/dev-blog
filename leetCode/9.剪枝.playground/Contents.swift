import UIKit

// https://leetcode-cn.com/problems/generate-parentheses/
/*
 22. 括号生成
 数字 n 代表生成括号的对数，请你设计一个函数，用于能够生成所有可能的并且 有效的 括号组合。
 示例：
 输入：n = 3
 输出：[
        "((()))",
        "(()())",
        "(())()",
        "()(())",
        "()()()"
      ]
 */
class Solution {
    func generateParenthesis(_ n: Int) -> [String] {
        var list: [String] = []

        func _gen(left: Int, right: Int, res: String) {
            if left == n, right == n {
                list.append(res)
                return
            }
            if left < n {
                _gen(left: left + 1, right: right, res: res + "(")
            }
            if left > right, right < n {
                _gen(left: left, right: right + 1, res: res + ")")
            }
        }
        _gen(left: 0, right: 0, res: "")
        return list
    }
}

// https://leetcode-cn.com/problems/zi-fu-chuan-de-pai-lie-lcof/
/*
 剑指 Offer 38. 字符串的排列
 输入一个字符串，打印出该字符串中字符的所有排列。
 你可以以任意顺序返回这个字符串数组，但里面不能有重复元素。
 示例:
 输入：s = "abc"
 输出：["abc","acb","bac","bca","cab","cba"]
 */
extension Solution {
    func permutation(_ s: String) -> [String] {
        let count = s.count

        var list: Set<String> = []

        func _p(target: String, res: String) {
            if res.count == count {
                list.insert(res)
                return
            }
            for (index, c) in target.enumerated() {
                var newTarget = target
                let i = target.index(target.startIndex, offsetBy: index)
                newTarget.remove(at: i)
                _p(target: newTarget, res: res + String(c))
            }
        }
        _p(target: s, res: "")
        return Array(list)
    }
}

Solution().permutation("aab")
