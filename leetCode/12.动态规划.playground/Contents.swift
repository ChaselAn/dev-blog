import UIKit

// https://leetcode-cn.com/problems/climbing-stairs/
/*
 70. 爬楼梯
 假设你正在爬楼梯。需要 n 阶你才能到达楼顶。
 每次你可以爬 1 或 2 个台阶。你有多少种不同的方法可以爬到楼顶呢？

 注意：给定 n 是一个正整数。
 示例 1：
 输入： 2
 输出： 2
 解释： 有两种方法可以爬到楼顶。
 1.  1 阶 + 1 阶
 2.  2 阶
 示例 2：
 输入： 3
 输出： 3
 解释： 有三种方法可以爬到楼顶。
 1.  1 阶 + 1 阶 + 1 阶
 2.  1 阶 + 2 阶
 3.  2 阶 + 1 阶
 */
class Solution {
    func climbStairs(_ n: Int) -> Int {
        // 斐波那契数列
        if (0...2).contains(n) {
            return n
        }
        var map: [Int: Int] = [1: 1, 2: 2]
        for i in 3...n {
            map[i] = map[i - 1]! + map[i - 2]!
        }
        return map[n] ?? 0
    }
}

// https://leetcode-cn.com/problems/triangle/
/*
 120. 三角形最小路径和
 给定一个三角形，找出自顶向下的最小路径和。每一步只能移动到下一行中相邻的结点上。
 相邻的结点 在这里指的是 下标 与 上一层结点下标 相同或者等于 上一层结点下标 + 1 的两个结点。
 例如，给定三角形：

 [
      [2],
     [3,4],
    [6,5,7],
   [4,1,8,3]
 ]
 自顶向下的最小路径和为 11（即，2 + 3 + 5 + 1 = 11）。
 说明：
 如果你可以只使用 O(n) 的额外空间（n 为三角形的总行数）来解决这个问题，那么你的算法会很加分。
 */
extension Solution {
    func minimumTotal(_ triangle: [[Int]]) -> Int {
        var map: [Int: [Int: Int]] = [:]
        let count = triangle.count
        var res: Int?
        func cal(row: Int, col: Int) -> Int? {
            if row < 0 || col < 0 { return nil }
            if col > triangle[row].count - 1 { return nil }
            let curValue = triangle[row][col]
            let first = map[row - 1]?[col] ?? cal(row: row - 1, col: col)
            let second = map[row - 1]?[col - 1] ?? cal(row: row - 1, col: col - 1)
            let res: Int
            if let first = first, let second = second {
                res = min(first, second) + curValue
            } else if let first = first {
                res = first + curValue
            } else if let second = second {
                res = second + curValue
            } else {
                res = curValue
            }
            if var rowMap = map[row] {
                rowMap[col] = res
                map[row] = rowMap
            } else {
                map[row] = [col: res]
            }
            return res
        }
        for (index, value) in triangle[count - 1].enumerated() {
            let cur = cal(row: count - 1, col: index) ?? value
            res = res == nil ? cur : (cur < res! ? cur : res!)
        }
        print(map)
        return res ?? 0
    }

    func minimumTotalBest(_ triangle: [[Int]]) -> Int {
        if triangle.count == 0 { return 0 }
        let count = triangle.count
        var res: [Int] = triangle[count - 1]
        for i in 0..<triangle.count - 2 {
            for j in 0..>triangle[i]
        }
    }
}

Solution().minimumTotal([[2],[3,4],[6,5,7],[4,1,8,3]])
