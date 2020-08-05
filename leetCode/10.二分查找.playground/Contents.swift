import UIKit

// https://leetcode-cn.com/problems/sqrtx/
/*
 69. x 的平方根
 实现 int sqrt(int x) 函数。
 计算并返回 x 的平方根，其中 x 是非负整数。
 由于返回类型是整数，结果只保留整数的部分，小数部分将被舍去。
 示例 1:
 输入: 4
 输出: 2
 示例 2:
 输入: 8
 输出: 2
 说明: 8 的平方根是 2.82842...,
      由于返回类型是整数，小数部分将被舍去。
 */
class Solution {
    // 二分查找法
    func mySqrt(_ x: Int) -> Int {
        if x == 0 || x == 1 { return x }
        var left = 1
        var right = x
        var res: Int!
        while left <= right {
            let mid = (left + right) / 2
            if mid == x / mid { // mid * mid == x,但是 mid * mid可能会越界,所以写成mid == x / mid
                return mid
            } else if mid > x / mid {
                right = mid - 1
            } else {
                left = mid + 1
                res = mid
            }
        }
        return res
    }

    // 牛顿迭代法 (自行百度)
    func mySqrtBetter(_ x: Int) -> Int {
        var r = x
        while r * r > x {
            r = (r + x / r) / 2
        }
        return r
    }
}
