//
//  ViewController.swift
//  FileUsing
//
//  Created by Ádám Bella on 1/21/18.
//  Copyright © 2018 Ádám Bella. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        BALog("I want to present my log solution")
        
        let result = Result.Success("It was success")
        
        print(result)
        
        switch result {
            case .Success(let value): print("\(value)")
            case .Fail(let value): print("\(value)")
        }
        
        if case let .Success(value) = result {
            print("False value: \(value)")
        }
        
        if let path = Bundle.main.path(forResource: "TextFile", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
               // TextView.text = myStrings.joined(separator: ", ")
            } catch {
                print(error)
            }
        }
        
    }
}
