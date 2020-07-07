import UIKit

//https://leetcode-cn.com/problems/kth-largest-element-in-a-stream/
/* 703.数据流中的第K大元素
 设计一个找到数据流中第K大元素的类（class）。注意是排序后的第K大元素，不是第K个不同的元素。
 你的 KthLargest 类需要一个同时接收整数 k 和整数数组nums 的构造器，它包含数据流中的初始元素。每次调用 KthLargest.add，返回当前数据流中第K大的元素。
 示例:
 int k = 3;
 int[] arr = [4,5,8,2];
 KthLargest kthLargest = new KthLargest(3, arr);
 kthLargest.add(3);   // returns 4
 kthLargest.add(5);   // returns 5
 kthLargest.add(10);  // returns 5
 kthLargest.add(9);   // returns 8
 kthLargest.add(4);   // returns 8
 说明:
 你可以假设 nums 的长度≥ k-1 且k ≥ 1。
 */
class KthLargest {
    /**
    * Your KthLargest object will be instantiated and called as such:
    * let obj = KthLargest(k, nums)
    * let ret_1: Int = obj.add(val)
    */

    private var nums: [Int]
    private let k: Int

    init(_ k: Int, _ nums: [Int]) {
        self.k = k
        self.nums = nums

    }

    // 维护k个值，每次进来新的值，快排排序，O(N*K*logK)
    func add(_ val: Int) -> Int {
        self.nums.append(val)
        sort()
        return nums[k-1]
    }

    // 维护一个size为k的小顶堆，如果新值比堆顶元素大，入堆，调整堆，堆顶元素就是结果，O(N*logK)
//    func addBest(_ val: Int) -> Int {
//
//    }

    private func sort() {
        nums = nums.sorted(by: { $0 > $1 })
        nums = Array(self.nums[0..<k])
    }
}

//https://leetcode-cn.com/problems/sliding-window-maximum/
/* 239. 滑动窗口最大值
 给定一个数组nums，有一个大小为 k 的滑动窗口从数组的最左侧移动到数组的最右侧。你只可以看到在滑动窗口内的 k 个数字。滑动窗口每次只向右移动一位。
 返回滑动窗口中的最大值。
 进阶：
 你能在线性时间复杂度内解决此题吗？
 示例:
 输入: nums = [1,3,-1,-3,5,3,6,7], 和 k = 3
 输出: [3,3,5,5,6,7]
 解释:
 滑动窗口的位置                最大值
 ---------------               -----
 [1  3  -1] -3  5  3  6  7       3
 1 [3  -1  -3] 5  3  6  7       3
 1  3 [-1  -3  5] 3  6  7       5
 1  3  -1 [-3  5  3] 6  7       5
 1  3  -1  -3 [5  3  6] 7       6
 1  3  -1  -3  5 [3  6  7]      7
 */
class Solution {
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
    func maxSlidingWindow(_ nums: [Int], _ k: Int) -> [Int] {
        var res: [Int] = []
        for i in 0...nums.count - k {
            let window = Array(nums[i..<i+k])
            let sorted = window.sorted(by: { $0 > $1 })
            res.append(sorted[0])
        }
        return res
    }
    // 维护一个size为k的大顶堆，每次移动调整堆，堆顶元素就是结果，O(N*logK)
    //    func maxSlidingWindowBetter(_ nums: [Int], _ k: Int) -> [Int] {
    //
    //    }

    // 双端队列实现，O(N)
    func maxSlidingWindowBest(_ nums: [Int], _ k: Int) -> [Int] {
        if nums.isEmpty { return [] }
        var window: Deque<Int> = Deque() // 双端队列
        var res: [Int] = []
        for (i, num) in nums.enumerated() {
            if i >= k, window.peekFront()! <= i - k { // 将左边滑出界的出队
                window.dequeue() // 左端出队
            }
            while !window.isEmpty, nums[window.peekBack()!] <= num { // 将队内小于新值的从右端出队
                window.dequeueBack() // 右端出队
            }
            window.enqueue(i)
            if i >= k-1 {
                res.append(nums[window.peekFront()!])
            }
        }
        return res
    }

    // 双端队列
    public struct Deque<T> {
        private var array = [T]()

        public var isEmpty: Bool {
            return array.isEmpty
        }

        public var count: Int {
            return array.count
        }

        public mutating func enqueue(_ element: T) {
            array.append(element)
        }

        public mutating func enqueueFront(_ element: T) {
            array.insert(element, at: 0)
        }

        public mutating func dequeue() -> T? {
            if isEmpty {
                return nil
            } else {
                return array.removeFirst()
            }
        }

        public mutating func dequeueBack() -> T? {
            if isEmpty {
                return nil
            } else {
                return array.removeLast()
            }
        }

        public func peekFront() -> T? {
            return array.first
        }

        public func peekBack() -> T? {
            return array.last
        }
    }
}
