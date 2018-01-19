//: Playground - noun: a place where people can play

import UIKit // This statement allows you to use anything from this framework

var str = "Hello, playground" //This is a string type

//Check your console window on the bottom of the screen. This method can be very useful later.
print(str)

//Create a new variable

var firstIntValue : Int = 32

//Create a new constant
//Info: The constant is a type of variable, but it is special. We create a new constant variable with a value that won't be able to change during the lifetime of the code.

let firstConstantVariable : String = "BMW"
//Info: If you try give a new value to 'firstContantVariable' variable, the compailer will throw an error. You can't do it.
//firstConstantVariable = "Mercedes"

//Info: The different between the two types of variable is type of declaration.
//'let' vs 'var' keywords

//Info: Names can't contain mathematical symbols, spaces and begin with a number.

//Example for other types of variable:

let firstDoubleVariable : Double = 3.14
var firstBooleanVariable : Bool = false
firstBooleanVariable = true

//Compound assignment operator

var myScore = 0
myScore += 9 // Adds 9 to myScore, this statement eqauls with myScore = myScore + 9
myScore -= 3 // Subtracts 3 from myScore
myScore *= 5 // Multiples myScore by 5
myScore /= 2 // Divides myScore by 2

let largeUglyNumber = 1000000000
let largePrettyNumber = 1_000_000_000

//Create an array of strings
var brands : [String] = [] //or var brands = [String]()
brands.append("BMW")
brands.append("Audi")
brands.insert("Mercedes", at: 1)
brands.append("Mclaren")
brands.append("Ferrari")
print(brands)

brands.removeLast(2)
print(brands)

//Append a string to other string
var favoriteCarSentence = "My favorite car is the"
print("\(favoriteCarSentence) \(brands.first!)")

var fullSentence = favoriteCarSentence + " " + brands.first! // equal with "\(favoriteCarSentence) \(brands.first!)"

//Opcional variable
//In this case the variable can be null
var favoriteCarBrand : String?

//In this case the variable can't be null. You have to give a default value to variable.
var favoriteMotorBrand : String = ""
