import UIKit

// https://leetcode-cn.com/problems/implement-trie-prefix-tree/
/*
 208. 实现 Trie (前缀树)
 实现一个 Trie (前缀树)，包含 insert, search, 和 startsWith 这三个操作。
 示例:
 Trie trie = new Trie();

 trie.insert("apple");
 trie.search("apple");   // 返回 true
 trie.search("app");     // 返回 false
 trie.startsWith("app"); // 返回 true
 trie.insert("app");
 trie.search("app");     // 返回 true
 说明:

 你可以假设所有的输入都是由小写字母 a-z 构成的。
 保证所有输入均为非空字符串。
 */

class Trie {

    var child: [Trie?] = [Trie?](repeating: nil, count: 26)
    var isEnd: Bool = false
    var letter: String?

    let aAsciiValue = Int(Character("a").asciiValue ?? 97)

    /** Initialize your data structure here. */
    init() {

    }

    /** Inserts a word into the trie. */
    func insert(_ word: String) {
        var current: Trie = self

        for character in word  {
            guard let asciiValue = character.asciiValue else { // ascii value
                return
            }

            let index = Int(asciiValue) - aAsciiValue //  小写字母 a 的索引，在数组中的位置

            var nextNode = current.child[index]

            if nextNode == nil { // 如果为空，创建一个，并插入到对应的位置
                nextNode = Trie()
                current.child[index] = nextNode
            }
            // 最后切换到nextNode里面进行设置下一个字符
            current = nextNode!
        }
        current.isEnd = true
    }

    /** Returns if the word is in the trie. */
    func search(_ word: String) -> Bool {
        var current: Trie = self

        for character in word {

            guard let asciiValue = character.asciiValue else { // ascii value
                return false
            }

            let index =  Int(asciiValue) - aAsciiValue //  小写字母 a 的索引，在数组中的位置

            guard let nextNode = current.child[index] else { // 如果找不到，就说明没有这个单词
                return false
            }

            current = nextNode
        }

        // 到这里，说明已经遍历完成了，需要看是不是最后一个的，例如 and 里面包含了 an，但不包含这个单词
        return current.isEnd
    }

    /** Returns if there is any word in the trie that starts with the given prefix. */
    func startsWith(_ prefix: String) -> Bool {
        var current: Trie = self

        for character in prefix {

            guard let asciiValue = character.asciiValue else { // ascii value
                return false
            }

            let index =  Int(asciiValue) - aAsciiValue //  小写字母 a 的索引，在数组中的位置

            guard let nextNode = current.child[index] else { // 如果找不到，就说明没有这个单词
                return false
            }

            current = nextNode
        }
        // 到这里，说明已经遍历完成了，需要看是不是最后一个的，例如 and 里面包含了 an，但不包含这个单词
        return true
    }
}

// https://leetcode-cn.com/problems/word-search/
/*
79. 单词搜索
 给定一个二维网格和一个单词，找出该单词是否存在于网格中。
 单词必须按照字母顺序，通过相邻的单元格内的字母构成，其中“相邻”单元格是那些水平相邻或垂直相邻的单元格。同一个单元格内的字母不允许被重复使用。
 示例:
 board =
 [
   ['A','B','C','E'],
   ['S','F','C','S'],
   ['A','D','E','E']
 ]
 给定 word = "ABCCED", 返回 true
 给定 word = "SEE", 返回 true
 给定 word = "ABCB", 返回 false
 */

// https://leetcode-cn.com/problems/word-search-ii/
/*
 212. 单词搜索 II
 给定一个二维网格 board 和一个字典中的单词列表 words，找出所有同时在二维网格和字典中出现的单词。
 单词必须按照字母顺序，通过相邻的单元格内的字母构成，其中“相邻”单元格是那些水平相邻或垂直相邻的单元格。同一个单元格内的字母在一个单词中不允许被重复使用。
 示例:
 输入:
 words = ["oath","pea","eat","rain"] and board =
 [
   ['o','a','a','n'],
   ['e','t','a','e'],
   ['i','h','k','r'],
   ['i','f','l','v']
 ]
 输出: ["eat","oath"]
 说明:
 你可以假设所有输入都由小写字母 a-z 组成。
 */

class Solution {

    func findWords(_ board: [[Character]], _ words: [String]) -> [String] {

    }
}
