//
//  ViewController.swift
//  GridTestProject
//
//  Created by Ádám Bella on 9/18/17.
//  Copyright © 2017 Ádám Bella. All rights reserved.
//

import UIKit

extension ViewController : BAGridViewDelegate,BAGridViewDataSource {
   
    func didSelectedLayer(tagIndex : Int, columnIndex : Int, event : BAGridEvent){
        NSLog("selected index = \(tagIndex)")
        
        let alert = UIAlertController(title: "DidClick", message: "selected item index : \(tagIndex), column: \(columnIndex)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    
    func gridNumberOfColums() -> Int {
        return 5
    }
    
    func gridNumberOfRows() -> Int {
        return 10
    }
    
    func gridWidthOfColumn() -> Int {
        return 200
    }
    
    func dataOfEvents() -> [BAGridEvent] {
        return items
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var scrollView: BAGrindScrollView!

    fileprivate var items = [BAGridEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.gridDataSource = self
        scrollView.gridDelegate = self
        
        //change the backgroud color of scrollView
        //scrollView.backgroundColor = UIColor.black
    }
    
    fileprivate final func initStartPackage(){
        var grid = BAGridEvent("Test value 1", backgroundColor: UIColor.cyan, startTimeInMin: 60, endTimeInMin: 300, columnNumber: 1)
        items.append(grid)
        
        grid = BAGridEvent("Test value 2", backgroundColor: UIColor.green, startTimeInMin: 120, endTimeInMin: 300, columnNumber: 1)
        items.append(grid)
        
        grid = BAGridEvent("Test value 3", backgroundColor: UIColor.blue, startTimeInMin: 180, endTimeInMin: 300, columnNumber: 1,borderWidth: 2, borderColor: UIColor.cyan)
        items.append(grid)
        
        grid = BAGridEvent("Test value 4", backgroundColor: UIColor.purple, startTimeInMin: 67, endTimeInMin: 180, columnNumber: 0)
        items.append(grid)
        
        grid = BAGridEvent("Test value 5", backgroundColor: UIColor.green, startTimeInMin: 98, endTimeInMin: 240, columnNumber: 0)
        items.append(grid)
        
        grid = BAGridEvent("Test value 6", backgroundColor: UIColor.blue, startTimeInMin: 300, endTimeInMin: 450, columnNumber: 0,borderWidth: 2, borderColor: UIColor.red)
        items.append(grid)
        
        grid = BAGridEvent("Test value 7", backgroundColor: UIColor.green, startTimeInMin: 98, endTimeInMin: 240, columnNumber: 2,borderWidth: 2, borderColor: UIColor.brown)
        items.append(grid)
        
        scrollView.reloadData()
    }
    
    @IBAction func addPlusItemToList(_ sender: Any) {
        let item = BAGridEvent("Added Test Value", backgroundColor: UIColor.purple, startTimeInMin: 60, endTimeInMin: 270, columnNumber: 3,borderWidth: 2, borderColor: UIColor.blue)
        items.append(item)

        scrollView.reloadData()
    }
}

