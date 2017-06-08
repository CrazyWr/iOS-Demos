//
//  NewClass.swift
//  TestSwift
//
//  Created by wei on 2017/3/22.
//  Copyright © 2017年 wei. All rights reserved.
//

import Foundation

class myClass: NSObject {
    var name : String
    var age : Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func desc() {
        print(self.name + "  " + String(self.age))
    }
    
}


class Shap: NSObject {
    var numbersOfSide : Int
    init(numbersOfSide: Int) {
        self.numbersOfSide = numbersOfSide
    }
    func desc(){
        print("a shap with \(numbersOfSide) sides")
    }
}

class Square: Shap {
    var sideLength : Double
    
    init(sideLength: Double) {
        self.sideLength = sideLength
        super.init(numbersOfSide: 0)
    }
    override func desc() {
        print("a square with length \(sideLength)")
    }
}






