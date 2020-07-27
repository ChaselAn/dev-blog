import UIKit

// https://leetcode-cn.com/problems/powx-n/
/*
 50. Pow(x, n)
 实现 pow(x, n) ，即计算 x 的 n 次幂函数。
 示例 1:
 输入: 2.00000, 10
 输出: 1024.00000
 示例 2:
 输入: 2.10000, 3
 输出: 9.26100
 示例 3:
 输入: 2.00000, -2
 输出: 0.25000
 解释: 2^-2 = 1/2^2 = 1/4 = 0.25
 说明:
 -100.0 < x < 100.0
 n 是 32 位有符号整数，其数值范围是 [−231, 231 − 1] 。
 */
class Solution {
    func myPow(_ x: Double, _ n: Int) -> Double {
        if n == 0 { return 1 }

        var x = x
        var n = n

        if n < 0 {
            x = 1 / x
            n = -n
        }

        let half = myPow(x, n / 2)
        return half * half * (n % 2 == 1 ? x : 1)
    }
}

// https://leetcode-cn.com/problems/majority-element/
/* 169. 多数元素
给定一个大小为 n 的数组，找到其中的多数元素。多数元素是指在数组中出现次数大于 ⌊ n/2 ⌋ 的元素。
 你可以假设数组是非空的，并且给定的数组总是存在多数元素。
 示例 1:
 输入: [3,2,3]
 输出: 3
 示例 2:
 输入: [2,2,1,1,1,2,2]
 输出: 2
 */
extension Solution {
    func majorityElement(_ nums: [Int]) -> Int {
        // 摩尔投票法
        var num = 0
        var count = 0
        for n in nums {
            if count == 0 {
                num = n
            }
            count = n == num ? (count + 1) : (count - 1)
        }
        return num
    }
}
