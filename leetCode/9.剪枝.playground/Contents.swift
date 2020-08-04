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

// https://leetcode-cn.com/problems/valid-sudoku/
/*
 36. 有效的数独
 判断一个 9x9 的数独是否有效。只需要根据以下规则，验证已经填入的数字是否有效即可。
 数字 1-9 在每一行只能出现一次。
 数字 1-9 在每一列只能出现一次。
 数字 1-9 在每一个以粗实线分隔的 3x3 宫内只能出现一次。
 数独部分空格内已填入了数字，空白格用 '.' 表示。
 示例 1:
 输入:
 [
   ["5","3",".",".","7",".",".",".","."],
   ["6",".",".","1","9","5",".",".","."],
   [".","9","8",".",".",".",".","6","."],
   ["8",".",".",".","6",".",".",".","3"],
   ["4",".",".","8",".","3",".",".","1"],
   ["7",".",".",".","2",".",".",".","6"],
   [".","6",".",".",".",".","2","8","."],
   [".",".",".","4","1","9",".",".","5"],
   [".",".",".",".","8",".",".","7","9"]
 ]
 输出: true
 示例 2:
 输入:
 [
   ["8","3",".",".","7",".",".",".","."],
   ["6",".",".","1","9","5",".",".","."],
   [".","9","8",".",".",".",".","6","."],
   ["8",".",".",".","6",".",".",".","3"],
   ["4",".",".","8",".","3",".",".","1"],
   ["7",".",".",".","2",".",".",".","6"],
   [".","6",".",".",".",".","2","8","."],
   [".",".",".","4","1","9",".",".","5"],
   [".",".",".",".","8",".",".","7","9"]
 ]
 输出: false
 解释: 除了第一行的第一个数字从 5 改为 8 以外，空格内其他数字均与 示例1 相同。
      但由于位于左上角的 3x3 宫内有两个 8 存在, 因此这个数独是无效的。
 说明:
 一个有效的数独（部分已被填充）不一定是可解的。
 只需要根据以上规则，验证已经填入的数字是否有效即可。
 给定数独序列只包含数字 1-9 和字符 '.' 。
 给定数独永远是 9x9 形式的。
 */
extension Solution {
    func isValidSudoku(_ board: [[Character]]) -> Bool {
        var colMap = [Int: Set<Character>]()
        var threeMap = [Int: Set<Character>]()
        for (rowIndex, row) in board.enumerated() {
            var rowSet = Set<Character>()
            for (colIndex, col) in row.enumerated() {
                if (rowIndex == 3 || rowIndex == 6) && colIndex == 0 {
                    threeMap = [:]
                }
                if col == "." { continue }
                if rowSet.contains(col) {
                    return false
                } else {
                    rowSet.insert(col)
                }
                if let colSet = colMap[colIndex] {
                    if colSet.contains(col) {
                        return false
                    } else {
                        var newColSet = colSet
                        newColSet.insert(col)
                        colMap[colIndex] = newColSet
                    }
                } else {
                    colMap[colIndex] = Set<Character>([col])
                }
                let threeIndex = colIndex / 3
                if let threeSet = threeMap[threeIndex] {
                    if threeSet.contains(col) {
                        return false
                    } else {
                        var newThreeSet = threeSet
                        newThreeSet.insert(col)
                        threeMap[threeIndex] = newThreeSet
                    }
                } else {
                    threeMap[threeIndex] = Set<Character>([col])
                }
            }
        }
        return true
    }
}

// https://leetcode-cn.com/problems/sudoku-solver/
/*
 37. 解数独
 编写一个程序，通过已填充的空格来解决数独问题。
 一个数独的解法需遵循如下规则：
 数字 1-9 在每一行只能出现一次。
 数字 1-9 在每一列只能出现一次。
 数字 1-9 在每一个以粗实线分隔的 3x3 宫内只能出现一次。
 空白格用 '.' 表示。

 给定的数独序列只包含数字 1-9 和字符 '.' 。
 你可以假设给定的数独只有唯一解。
 给定数独永远是 9x9 形式的。
 */
extension Solution {
    func solveSudoku(_ board: inout [[Character]]) {
        if board.isEmpty { return }

        func isValid(_ board: [[Character]], row: Int, col: Int, c: Character) -> Bool {
            for i in 0..<board.count {
                // check row
                if board[i][col] == c { return false }
                // check column
                if board[row][i] == c { return false }
                // check 3*3
                if board[3 * (row / 3) + i / 3][3 * (col / 3) + i % 3] == c { return false}
            }
            return true
        }

        func solve(_ board: inout [[Character]]) -> Bool {
            for i in 0..<board.count {
                for j in 0..<board[i].count {
                    guard board[i][j] == "." else { continue }
                    for ci in 1...9 {
                        let c = Character("\(ci)")
                        if isValid(board, row: i, col: j, c: c) {
                            board[i][j] = c
                            if solve(&board) {
                                return true
                            } else {
                                board[i][j] = "."
                            }
                        }
                    }
                    return false
                }
            }
            return true
        }

        solve(&board)

    }
}
