import UIKit

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

//https://leetcode-cn.com/problems/reverse-linked-list/
/* 206. 反转链表
反转一个单链表。
示例:
输入: 1->2->3->4->5->NULL
输出: 5->4->3->2->1->NULL
*/
func reverseList(_ head: ListNode?) -> ListNode? {
    var cur = head
    var new: ListNode? = nil
    while cur != nil {
        let temp = cur?.next
        cur?.next = new
        new = cur
        cur = temp
    }
    return new
}
func reverseListBest(_ head: ListNode?) -> ListNode? {
    var cur = head
    var pre: ListNode? = nil
    while cur != nil {
        (cur!.next, pre, cur) = (pre, cur, cur!.next)
    }
    return pre
}

//https://leetcode-cn.com/problems/swap-nodes-in-pairs/
/* 24. 两两交换链表中的节点
给定一个链表，两两交换其中相邻的节点，并返回交换后的链表。
你不能只是单纯的改变节点内部的值，而是需要实际的进行节点交换。
示例:
给定 1->2->3->4, 你应该返回 2->1->4->3.
 */
func swapPairs(_ head: ListNode?) -> ListNode? {
    var head = head
    let dummy = ListNode(-1)
    dummy.next = head
    var pre = dummy
    
    while let first = head, let second = head?.next {
        pre.next = second
        first.next = second.next
        second.next = first
        pre = first
        head = first.next
    }
    return dummy.next
}

// https://leetcode-cn.com/problems/linked-list-cycle/
/*
 141. 环形链表
 给定一个链表，判断链表中是否有环。
 */
public class ListNodeO: NSObject {
    public var val: Int
    public var next: ListNodeO?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}
func hasCycle1(_ head: ListNodeO?) -> Bool {
    var set = Set<String>()
    var head: ListNodeO? = head
    while head != nil {
        let address = String(format: "%p", head!)
        if set.contains(address) {
            return true
        } else {
            set.insert(address)
        }
        head = head?.next
    }
    return false
}

func hasCycle2(_ head: ListNodeO?) -> Bool {
    var slow = head
    var fast = head?.next
    while slow != nil, fast != nil {
        if slow == fast {
            return true
        } else {
            slow = slow?.next
            fast = fast?.next?.next
        }
    }
    return false
}

// https://leetcode-cn.com/problems/linked-list-cycle-ii/
/*
 142. 环形链表 II
 给定一个链表，返回链表开始入环的第一个节点。 如果链表无环，则返回 null。
 说明：不允许修改给定的链表。
 */
func detectCycle(_ head: ListNodeO?) -> ListNodeO? {
    var set = Set<ListNodeO>()
    var head: ListNodeO? = head
    while head != nil {
        if set.contains(head!) {
            return head
        } else {
            set.insert(head!)
        }
        head = head?.next
    }
    return nil
}

// https://leetcode-cn.com/problems/reverse-nodes-in-k-group/
/*
 25. K 个一组翻转链表
 给你一个链表，每 k 个节点一组进行翻转，请你返回翻转后的链表。
 k 是一个正整数，它的值小于或等于链表的长度。
 如果节点总数不是 k 的整数倍，那么请将最后剩余的节点保持原有顺序。
 示例：
 给你这个链表：1->2->3->4->5
 当 k = 2 时，应当返回: 2->1->4->3->5
 当 k = 3 时，应当返回: 3->2->1->4->5
 说明：
 你的算法只能使用常数的额外空间。
 你不能只是单纯的改变节点内部的值，而是需要实际进行节点交换。
 */
func reverseKGroup(_ head: ListNode?, _ k: Int) -> ListNode? {
    return nil
}
