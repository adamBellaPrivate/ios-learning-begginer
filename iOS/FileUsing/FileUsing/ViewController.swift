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

        //BALog.init("Teszt log")
        BALog("teszt 2 log")
        
        let result = Valami.Success("dadsa")
        
        print(result)
        
        switch result {
        case .Success(let value): print("Yes, \(value) is in the lower half!")
        case .Fail(let value): print("\(value) Not in the lower half.")
        }
        
        if case let .Success(value) = result {
            print("\(value) Not in the lower half.")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

public enum Valami<T> {
    case Success(T)
    case Fail(T)
}

