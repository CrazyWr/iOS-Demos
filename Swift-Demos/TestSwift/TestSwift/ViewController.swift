//
//  ViewController.swift
//  TestSwift
//
//  Created by wei on 2017/3/22.
//  Copyright © 2017年 wei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let my = myClass(name:"name", age:67)
        my.desc()
        
        let square = Square(sideLength: 65)
        square.desc()
        
        let label = UILabel(frame: CGRect(x:100, y:100, width:200, height:300))
        label.backgroundColor = UIColor.red
        self.view.addSubview(label)
        
        var array = [String]()
        array.append("nnnnnn")
        array.append(contentsOf: ["点击放大就返回", "fjdfdjkf", "893dfuj"])
        
        for (key, value) in array.enumerated() {
            print(key, value)
        }
        
        var array2 = ["ghfhgfghfhgfgh", "678", "454", "99889"]
        print(array2)
        var reverseArray2 = array2.sorted(by:{(s1:String, s2:String)->Bool in
            return s1>s2
        })
        print(reverseArray2)
        
        var reverseArray = array.sorted(by: <)
        print(reverseArray)
        
        let count = array2.count
        switch count {
        case 3:
            print("count > 3")
            fallthrough
        case 2:
            print("count == 2")
        default:
            print("default")
        }
        
        var a = 10, b = 20
        print("a= \(a), b= \(b)")
        switchNum(&a, &b)
        print("a= \(a), b= \(b)")
        
        
        var numbers = [23, 43, 5, 45, 234];
        print(numbers.sorted(by:>))
        
    }
    
    func switchNum(_ a : inout Int,_ b : inout Int) {
        let temp = a
        a = b
        b = temp
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

