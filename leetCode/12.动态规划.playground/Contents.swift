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
