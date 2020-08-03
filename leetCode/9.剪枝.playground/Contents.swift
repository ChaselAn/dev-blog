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

// https://leetcode-cn.com/problems/n-queens/
/*
 51. N皇后 (困难！)
 n 皇后问题研究的是如何将 n 个皇后放置在 n×n 的棋盘上，并且使皇后彼此之间不能相互攻击。
 给定一个整数 n，返回所有不同的 n 皇后问题的解决方案。
 每一种解法包含一个明确的 n 皇后问题的棋子放置方案，该方案中 'Q' 和 '.' 分别代表了皇后和空位。
 示例:
 输入: 4
 输出: [
  [".Q..",  // 解法 1
   "...Q",
   "Q...",
   "..Q."],
  ["..Q.",  // 解法 2
   "Q...",
   "...Q",
   ".Q.."]
 ]
 解释: 4 皇后问题存在两个不同的解法。
 提示：
 皇后，是国际象棋中的棋子，意味着国王的妻子。皇后只做一件事，那就是“吃子”。当她遇见可以吃的棋子时，就迅速冲上去吃掉棋子。当然，她横、竖、斜都可走一到七步，可进可退。（引用自 百度百科 - 皇后 ）
 意思就是棋盘中，每一行每一列每一斜都只有一个皇后
 */
extension Solution {
    func solveNQueens(_ n: Int) -> [[String]] {
        if n < 1 { return [] }
        var res: [[String]] = []
        var cols = Set<Int>()
        var pie = Set<Int>()
        var na = Set<Int>()

        var emptyStr = ""
        for _ in 0..<n {
            emptyStr.append(".")
        }

        func dfs(row: Int, curState: [String]) {
            if row >= n {
                res.append(curState)
                return
            }
            for col in 0..<n {
                if cols.contains(col) || pie.contains(row + col) || na.contains(row - col) {
                    continue
                }
                // 把皇后放在这个位置
                cols.insert(col)
                pie.insert(row + col)
                na.insert(row - col)

                var curRes = emptyStr
                let start = emptyStr.index(emptyStr.startIndex, offsetBy: col)
                let end = emptyStr.index(emptyStr.startIndex, offsetBy: col + 1)
                curRes.replaceSubrange(start..<end, with: "Q")

                dfs(row: row + 1, curState: curState + [curRes])

                cols.remove(col)
                pie.remove(row + col)
                na.remove(row - col)
            }
        }

        dfs(row: 0, curState: [])
        return res
    }
}

// https://leetcode-cn.com/problems/n-queens-ii/
/*
 52. N皇后 II
 n 皇后问题研究的是如何将 n 个皇后放置在 n×n 的棋盘上，并且使皇后彼此之间不能相互攻击。
 上图为 8 皇后问题的一种解法。
 给定一个整数 n，返回 n 皇后不同的解决方案的数量。
 示例:
 输入: 4
 输出: 2
 解释: 4 皇后问题存在如下两个不同的解法。
 [
  [".Q..",  // 解法 1
   "...Q",
   "Q...",
   "..Q."],

  ["..Q.",  // 解法 2
   "Q...",
   "...Q",
   ".Q.."]
 ]
 */
extension Solution {
    func totalNQueens(_ n: Int) -> Int {
        return solveNQueens(n).count
    }
}
