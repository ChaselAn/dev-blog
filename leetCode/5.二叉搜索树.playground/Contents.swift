import UIKit

// https://leetcode-cn.com/problems/validate-binary-search-tree/
/*
 98. 验证二叉搜索树
 给定一个二叉树，判断其是否是一个有效的二叉搜索树。
 假设一个二叉搜索树具有如下特征：
 节点的左子树只包含小于当前节点的数。
 节点的右子树只包含大于当前节点的数。
 所有左子树和右子树自身必须也是二叉搜索树。
 示例 1:
 输入:
     2
    / \
   1   3
 输出: true
 示例 2:
 输入:
     5
    / \
   1   4
      / \
     3   6
 输出: false
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
    func isValidBST1(_ root: TreeNode?) -> Bool { // O(N)
        // 空树也算二叉搜索树
        guard let root = root else { return true }
        var traversalRes = [Int]()
        // 中序遍历
        func inorder(_ root: TreeNode?, res: inout [Int]) {
            guard let root = root else { return }
            inorder(root.left, res: &res)
            res.append(root.val)
            inorder(root.right, res: &res)
        }
        inorder(root, res: &traversalRes)
        // 二叉搜索树中序遍历后是个升序数列
        for i in 1..<traversalRes.count {
            if traversalRes[i] <= traversalRes[i - 1] {
                return false
            }
        }
        return true
    }
    func isValidBST1Better(_ root: TreeNode?) -> Bool { // O(N)
        // 空树也算二叉搜索树
        guard let root = root else { return true }
        var preVal: Int?
        // 中序遍历改良
        func inorder(_ root: TreeNode?) -> Bool {
            guard let root = root else { return true }
            if !inorder(root.left) { return false }
            if let preVal = preVal, preVal >= root.val {
                return false
            }
            preVal = root.val
            if !inorder(root.right) { return false }
            return true
        }
        return inorder(root)
    }
    func isValidBST2(_ root: TreeNode?) -> Bool { // O(N)
        func isValid(_ root: TreeNode?, min: Int?, max: Int?) -> Bool {
            guard let root = root else { return true }
            if let min = min, root.val <= min { return false }
            if let max = max, root.val >= max { return false }
            return isValid(root.left, min: min, max: root.val) && isValid(root.right, min: root.val, max: max)
        }
        return isValid(root, min: nil, max: nil)
    }
}

// https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-search-tree/
/*
 235. 二叉搜索树的最近公共祖先
 给定一个二叉搜索树, 找到该树中两个指定节点的最近公共祖先。
 百度百科中最近公共祖先的定义为：“对于有根树 T 的两个结点 p、q，最近公共祖先表示为一个结点 x，满足 x 是 p、q 的祖先且 x 的深度尽可能大（一个节点也可以是它自己的祖先）。”
 例如，给定如下二叉搜索树:  root = [6,2,8,0,4,7,9,null,null,3,5]
     6
    /  \
   2    8
  / \   /\
 0  4  7  9
   / \
   3 5
 示例 1:
 输入: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 8
 输出: 6
 解释: 节点 2 和节点 8 的最近公共祖先是 6。
 示例 2:
 输入: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 4
 输出: 2
 解释: 节点 2 和节点 4 的最近公共祖先是 2, 因为根据定义最近公共祖先节点可以为节点本身。
 */
extension Solution {
    func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        guard let root = root, let pV = p?.val, let qV = q?.val else { return nil}
        let rootVal = root.val
        if pV > rootVal, qV > rootVal {
            return lowestCommonAncestor(root.right, p, q)
        } else if pV < rootVal, qV < rootVal {
            return lowestCommonAncestor(root.left, p, q)
        } else {
            return root
        }
    }
}

// https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree/
/*
 236. 二叉树的最近公共祖先
 给定一个二叉树, 找到该树中两个指定节点的最近公共祖先。
 例子上看题👆
 说明:
 所有节点的值都是唯一的。
 p、q 为不同节点且均存在于给定的二叉树中。
 */
extension Solution {
    func lowestCommonAncestor_236(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        guard let root = root else { return nil }
        if p?.val == root.val || q?.val == root.val { return root }
        let left = lowestCommonAncestor(root.left, p, q)
        let right = lowestCommonAncestor(root.right, p, q)
        if left == nil {
            return right
        } else if right == nil {
            return left
        } else {
            return root
        }
    }
}
