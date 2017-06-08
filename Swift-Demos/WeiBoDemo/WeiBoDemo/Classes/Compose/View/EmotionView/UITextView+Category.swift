//
//  UITextView+Category.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/19.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit


extension UITextView{
    func insertEmotion(emotion: Emotion){
        
        // 删除按钮
        if emotion.isRemoveButton {
            self.deleteBackward()
            return
        }
        
        if emotion.emojiStr != nil{
            // 插入emoji表情
            self.replace(self.selectedTextRange!, withText: emotion.emojiStr!)
        }else if emotion.png != nil {
            // 插入图片表情
            let fontSize = self.font?.lineHeight
            // 图片属性字符串
            let imageText = EmotionAttachment.imageText(emotion: emotion, fontSize: fontSize!)
            
            // 替换选中位置
            let range =  self.selectedRange
            let strM = NSMutableAttributedString(attributedString: self.attributedText)
            strM.replaceCharacters(in: range, with: imageText)
            // 设置属性字符串大小
            strM.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: fontSize!), range: NSMakeRange(range.location, 1))
            self.attributedText = strM
            // 重置光标
            self.selectedRange = NSMakeRange(range.location + 1, 0)
        }
    }
}
