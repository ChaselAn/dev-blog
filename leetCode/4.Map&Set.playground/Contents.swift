import UIKit

//https://leetcode-cn.com/problems/valid-anagram/
/* 242. 有效的字母异位词
 给定两个字符串 s 和 t ，编写一个函数来判断 t 是否是 s 的字母异位词。
 示例 1:
 输入: s = "anagram", t = "nagaram"
 输出: true
 示例 2:
 输入: s = "rat", t = "car"
 输出: false
 说明:
 你可以假设字符串只包含小写字母。
 进阶:
 如果输入字符串包含 unicode 字符怎么办？你能否调整你的解法来应对这种情况？
 */
class Solution {
    func isAnagram(_ s: String, _ t: String) -> Bool {
        func createMap(str: String) -> [Character: Int] {
            var map: [Character: Int] = [:]
            for c in str {
                if let count = map[c] {
                    map[c] = count + 1
                } else {
                    map[c] = 1
                }
            }
            return map
        }
        if s.count != t.count { return false }
        return createMap(str: s) == createMap(str: t)
    }
}

//https://leetcode-cn.com/problems/two-sum/
/* 1. 两数之和
 给定一个整数数组nums和一个目标值target，请你在该数组中找出和为目标值的那 两个 整数，并返回他们的数组下标。
 你可以假设每种输入只会对应一个答案。但是，数组中同一个元素不能使用两遍。
 示例:
 给定 nums = [2, 7, 11, 15], target = 9
 因为 nums[0] + nums[1] = 2 + 7 = 9
 所以返回 [0, 1]
 */
extension Solution {
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var map: [Int: Int] = [:]
        for i in 0..<nums.count {
            let dif = target - nums[i]
            if let index = map[dif], index != i {
                return [i, index]
            }
            map[nums[i]] = i
        }
        return []
    }
}

//https://leetcode-cn.com/problems/3sum/
/*
 15. 三数之和
 给你一个包含 n 个整数的数组 nums，判断 nums 中是否存在三个元素 a，b，c ，使得 a + b + c = 0 ？请你找出所有满足条件且不重复的三元组。
 注意：答案中不可以包含重复的三元组。
 示例：
 给定数组 nums = [-1, 0, 1, 2, -1, -4]，
 满足要求的三元组集合为：
 [
   [-1, 0, 1],
   [-1, -1, 2]
 ]
 */
extension Solution {
    func threeSum(_ nums: [Int]) -> [[Int]] {
        if nums.count < 3 { return [] }
        let nums = nums.sorted()
        var res: [[Int]] = []
        for i in 0..<nums.count - 2 {
            //最小的数大于0直接跳出循环
            if nums[i] > 0 { break }
            let a = nums[i]
            if i > 0, nums[i - 1] == a { continue }
            var bIndex = i + 1
            var cIndex = nums.count - 1
            while bIndex < cIndex {
                let b = nums[bIndex]
                let c = nums[cIndex]
                if a + b + c > 0 {
                    repeat {
                        cIndex -= 1
                    } while bIndex < cIndex && nums[cIndex] == nums[cIndex + 1]
                } else if a + b + c < 0 {
                    repeat {
                        bIndex += 1
                    } while bIndex < cIndex && nums[bIndex] == nums[bIndex - 1]
                } else if a + b + c == 0 {
                    res.append([a, b, c])
                    repeat {
                        bIndex += 1
                    } while bIndex < cIndex && nums[bIndex] == nums[bIndex - 1]
                    repeat {
                        cIndex -= 1
                    } while bIndex < cIndex && nums[cIndex] == nums[cIndex + 1]
                }
            }
        }
        return res
    }
}
