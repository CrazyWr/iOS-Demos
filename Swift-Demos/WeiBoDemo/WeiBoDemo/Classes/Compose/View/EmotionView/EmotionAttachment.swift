//
//  EmotionAttachment.swift
//  WeiBoDemo
//
//  Created by wei on 2017/4/19.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit

class EmotionAttachment: NSTextAttachment {
    // 图片表情对应的文字
    var chs: String?
    
    // 根据表情创建 表情字符串
    class func imageText(emotion: Emotion, fontSize: CGFloat) -> NSAttributedString{
        let attachment = EmotionAttachment()
//        attachment.bounds = CGRect(x: 0, y: -0.15*fontSize, width: fontSize+2, height: fontSize+2)
        attachment.image = UIImage(contentsOfFile: emotion.imagePath!)
        attachment.chs = emotion.chs
        return NSAttributedString(attachment: attachment)
    }
}
