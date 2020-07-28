import UIKit

// https://leetcode-cn.com/problems/binary-tree-level-order-traversal/
/*
102. 二叉树的层序遍历
 给你一个二叉树，请你返回其按 层序遍历 得到的节点值。 （即逐层地，从左到右访问所有节点）。
 示例：
 二叉树：[3,9,20,null,null,15,7],
     3
    / \
   9  20
     /  \
    15   7
 返回其层次遍历结果：
 [
   [3],
   [9,20],
   [15,7]
 ]
 */
public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}
class Solution {
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        guard let root = root else { return [] }
        var res: [[Int]] = []
        var queue: [[TreeNode]] = [[root]]

        while !queue.isEmpty {
            let curList = queue.removeFirst()
            var nextList: [TreeNode] = []
            var curRes: [Int] = []
            for cur in curList {
                if let left = cur.left {
                    nextList.append(left)
                }
                if let right = cur.right {
                    nextList.append(right)
                }
                curRes.append(cur.val)
            }
            if !nextList.isEmpty {
                queue.append(nextList)
            }
            if !curRes.isEmpty {
                res.append(curRes)
            }
        }
        return res
    }
}

// https://leetcode-cn.com/problems/maximum-depth-of-binary-tree/
/*
 104. 二叉树的最大深度
 给定一个二叉树，找出其最大深度。
 二叉树的深度为根节点到最远叶子节点的最长路径上的节点数。
 说明: 叶子节点是指没有子节点的节点。
 示例：
 给定二叉树 [3,9,20,null,null,15,7]，
     3
    / \
   9  20
     /  \
    15   7
 返回它的最大深度 3 。
 */
extension Solution {
    func maxDepth(_ root: TreeNode?) -> Int {
        guard let root = root else { return 0 }
        var level = 0
        func dfs(node: TreeNode, curLevel: Int) {
            if curLevel > level {
                level = curLevel
            }
            if let left = node.left {
                dfs(node: left, curLevel: curLevel + 1)
            }
            if let right = node.right {
                dfs(node: right, curLevel: curLevel + 1)
            }
        }
        dfs(node: root, curLevel: level)
        return level + 1
    }
    func maxDepthBest(_ root: TreeNode?) -> Int {
        guard let root = root else { return 0 }
        return max(maxDepthBest(root.left), maxDepthBest(root.right)) + 1
    }
}

// https://leetcode-cn.com/problems/minimum-depth-of-binary-tree/
/*
 111. 二叉树的最小深度
 给定一个二叉树，找出其最小深度。
 最小深度是从根节点到最近叶子节点的最短路径上的节点数量。
 说明: 叶子节点是指没有子节点的节点。
 示例:
 给定二叉树 [3,9,20,null,null,15,7],
     3
    / \
   9  20
     /  \
    15   7
 返回它的最小深度  2.
 */
extension Solution {
    func minDepth(_ root: TreeNode?) -> Int {
        guard let root = root else { return 0 }
        var minlevel: Int?
        func dfs(node: TreeNode, curLevel: Int) {
            if let left = node.left {
                dfs(node: left, curLevel: curLevel + 1)
            }
            if let right = node.right {
                dfs(node: right, curLevel: curLevel + 1)
            }
            if node.left == nil, node.right == nil {
                if let tempMinlevel = minlevel {
                    if curLevel < tempMinlevel {
                        minlevel = curLevel
                    }
                } else {
                    minlevel = curLevel
                }
            }
        }
        dfs(node: root, curLevel: 0)
        return (minlevel ?? 0) + 1
    }
}
