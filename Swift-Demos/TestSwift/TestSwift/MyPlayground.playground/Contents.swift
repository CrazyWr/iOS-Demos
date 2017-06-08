//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

print(str)

let changliang = "changliang  can not set up twrice"


var strTest = changliang + "  " + String(34)

var value = 45
var value2 = 34

var str2 = "I have a \(value + value2) girl"

var array = [String]()//空数组
var dict = [String : Float]()//空字典

var array2 = ["dffdf", "sdfdf", 45, 2222] as Any

var value3 : Double? = 100

if value3 != nil {
    value = 46
    print(value)
}else{
    print("nil")
}

//??
let nickName: String? = nil
let fullName: String = "John Appleseed"
let informalGreeting = "Hi \(nickName ?? fullName)"

//switch
let vegetable = "red pepper"
switch vegetable {
case "celery":
    print("Add some raisins and make ants on a log.")
case "cucumber", "watercress":
    print("That would make a good tea sandwich.")
case let x where x.hasSuffix("pepperx"):
    print("Is it a spicy \(x)?")
default:
    print("Everything tastes good in soup.")
}


let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]
var largest = 0
for (kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
        }
    }
}
print(largest)


func greet(person: String, day: String) -> String {
    return "Hello \(person), today is \(day)."
}
print(greet(person: "Bob", day: "Tuesday"))


func greet(_ person: String, on day: String) -> String {
    return "Hello \(person), today is \(day)."
}
print(greet("John", on: "Wednesday"))
print(greet("Bob", on: "Tuesday"))

func returnMultValues(person: String) -> [Any]{
    print(person)
    return ["ssss", "dsfsfsdf", "dsfsdfdf", 5, 89]
}







