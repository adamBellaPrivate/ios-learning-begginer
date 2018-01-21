//
//  BAGrindScrollView.swift
//  GridTestProject
//
//  Created by Ádám Bella on 9/18/17.
//  Copyright © 2017 Ádám Bella. All rights reserved.
//

import UIKit

class BAGrindScrollView: UIScrollView {
    fileprivate let grid = BAGridView()
    
    override var backgroundColor: UIColor? {
        didSet {
            grid.backgroundColor = backgroundColor
        }
    }
    
    var gridDelegate : BAGridViewDelegate? {
        didSet {
            grid.delegate = gridDelegate
        }
    }
    
    var gridDataSource : BAGridViewDataSource? {
        didSet {
            grid.dataSource = gridDataSource
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(grid)
        backgroundColor = UIColor.yellow
        grid.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(grid)
        backgroundColor = UIColor.yellow
        grid.isUserInteractionEnabled = true
    }
    
    final func reloadData(){
        grid.reloadTable()
        contentSize = CGSize(width: grid.widthOfContent, height: grid.heightOfContent)
    }
}
