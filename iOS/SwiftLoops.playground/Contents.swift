//: Playground - noun: a place where people can play

import UIKit

//For loop
let cities : [String] = ["London", "New York", "Las Vegas", "Los Angeles"]

for city in cities {
    print("City: \(city)")
}

print("--------")

for (index, city) in cities.enumerated() {
    print("Index: \(index), City: \(city)")
}

print("--------")

//Unordered
for (key, value) in ["London": true, "Las Vegas": false, "New York" : true, "Los Angeles" : false] {
    print("Key: \(key), Value: \(value)")
}

print("--------")

for index in 1...5 {
    print("Index: \(index)")
}

print("--------")

for index in 1..<5 {
    print("Index: \(index)")
}

print("--------")

for value in stride(from: 0, through: 5, by: 1) {
   print("\(value)")
}

print("--------")

//While loop

var counter = 0
while(counter < 5){
    print("Counter's value: \(counter)")
    counter += 1
}

print("--------")

//Repeat while
counter = 0

repeat {
    print("Counter's value: \(counter)")
    counter += 1
} while counter < 5

//while evaluates its condition at the start of each pass through the loop.
//repeat-while evaluates its condition at the end of each pass through the loop.
