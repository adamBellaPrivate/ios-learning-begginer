//
//  BAGridView.swift
//  GridTestProject
//
//  Created by Ádám Bella on 9/18/17.
//  Copyright © 2017 Ádám Bella. All rights reserved.
//

import UIKit

protocol BAGridViewDelegate {
    func didSelectedLayer(tagIndex : Int, columnIndex : Int,event :BAGridEvent)
    func dataOfEvents() -> [BAGridEvent]
}

@objc protocol BAGridViewDataSource {
    func gridNumberOfColums() -> Int
    func gridNumberOfRows() -> Int
    
    @objc optional func gridHeightOfCell() -> Int
    @objc optional func gridWidthOfColumn() -> Int
}

class BAGridView: UIView {
    var delegate : BAGridViewDelegate?
    var dataSource : BAGridViewDataSource?
    
    fileprivate(set) var numberOfColumns = 5 {
        didSet {
            widthOfContent =  widthOfColumns * numberOfColumns
        }
    }
    
    fileprivate(set) var numberOfRows = 10 {
        didSet {
            heightOfContent =  heightOfRows * numberOfRows
        }
    }
    
    fileprivate var widthOfColumns = 200 {
        didSet {
            widthOfContent =  widthOfColumns * numberOfColumns
        }
    }
    
    fileprivate var heightOfRows = 60 {
        didSet {
            heightOfContent =  heightOfRows * numberOfRows
        }
    }
    
    fileprivate(set) var widthOfContent : Int = 1000
    fileprivate(set) var heightOfContent : Int = 600
    fileprivate let marginLeft = 5
    fileprivate var items = [BAGridEvent]()
    
    final func reloadTable(){
        guard let dataSource = dataSource else {return}
        
        numberOfRows = dataSource.gridNumberOfRows()
        numberOfColumns = dataSource.gridNumberOfColums()
        if let height = dataSource.gridHeightOfCell?() {
            heightOfRows = height
        }
        
        if let width = dataSource.gridWidthOfColumn?() {
            widthOfColumns = width
        }
        
        guard let delegate = delegate else {return}
        items = delegate.dataOfEvents()
        
        frame = CGRect(x:0,y:0,width:widthOfContent,height:heightOfContent)
        setNeedsDisplay()
        
        addEventLayers()
    }
    
    fileprivate final func addEventLayers(){
        if let subLayers = layer.sublayers {
            for subLayer in subLayers {
                subLayer.removeFromSuperlayer()
            }
        }
        for item in items {
            addEventLayer(column: item.columnNumber, startMin: item.startTimeInMin, endMin: item.endTimeInMin, bgColor: item.backgroundColor, text: item.title,borderWidth: item.borderWidth,borderColor: item.borderColor,fontColor: item.textColor)
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.red.cgColor);
        
        // ---------------------------
        // Drawing column lines
        // ---------------------------
        
        for index in 1...numberOfColumns {
            var startPoint = CGPoint()
            var endPoint = CGPoint()
            
            startPoint.x = CGFloat(widthOfColumns * index)
            startPoint.y = 0
            
            endPoint.x = startPoint.x
            endPoint.y = CGFloat(heightOfContent)
            
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            
            context.strokePath()
        }
        
        // ---------------------------
        // Drawing row lines
        // ---------------------------
        
        for index in 1...numberOfRows{
            var startPoint = CGPoint()
            var endPoint = CGPoint()
            
            startPoint.x = 0
            startPoint.y = CGFloat(heightOfRows * index)
            
            endPoint.x = CGFloat(widthOfContent)
            endPoint.y = startPoint.y
            
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            
            context.strokePath()
        }
    }
    
    fileprivate final func addEventLayer(column : Int, startMin : Int, endMin : Int, bgColor : UIColor, text : String,borderWidth : Int = 0, borderColor : UIColor = .clear, fontColor : UIColor = .white){
        let eventLayer = BAGridLayer()
        eventLayer.shouldRasterize = true
        eventLayer.rasterizationScale = UIScreen.main.scale
        eventLayer.drawsAsynchronously = true
        
        //TODO: check the new event position on the table
        eventLayer.index = layer.sublayers?.count ?? 0
        eventLayer.column = column
        
        let x : CGFloat = CGFloat(marginLeft + column * widthOfColumns)
        let y : CGFloat = CGFloat(startMin)
        
        eventLayer.frame = CGRect(x:x,y:y,width: CGFloat(widthOfColumns - marginLeft),height: CGFloat(endMin - startMin))
        
        if let existsSublayers = layer.sublayers {
            var count : CGFloat = 1
            
            for sublayer in existsSublayers {
                if sublayer.frame.intersects(eventLayer.frame) {
                    count += 1
                }
            }
            
            var modifiedCount : CGFloat = 0
            let correctedWidth = eventLayer.frame.size.width / count
            
            for sublayer in existsSublayers {
                if sublayer.frame.intersects(eventLayer.frame) {
                    if modifiedCount != 0 {
                        
                        let newWidth = eventLayer.frame.size.width - (modifiedCount * correctedWidth)
                        let x = sublayer.frame.origin.x + (sublayer.frame.size.width - newWidth)
                        
                        sublayer.frame = CGRect(x:x,y:sublayer.frame.origin.y, width: newWidth, height: sublayer.frame.size.height)

                        modifiedCount += 1
                    }else{
                        modifiedCount += 1
                    }

                    if let subsubLayer = sublayer.sublayers {
                        for tempTextLayer in subsubLayer {
                            if let textLayer = tempTextLayer as? CATextLayer{
                                textLayer.frame = CGRect(x:5,y:5,width: correctedWidth - 7 ,height:sublayer.frame.height)
                                textLayer.fontSize = getMaxFontSize(text,frame:textLayer.frame)
                                textLayer.font = UIFont.boldSystemFont(ofSize: textLayer.fontSize)
                            }
                        }
                    }
                }
            }
            
            if count != 1 {
                let newWidth = eventLayer.frame.size.width - (modifiedCount * correctedWidth)
                let x = eventLayer.frame.origin.x + (eventLayer.frame.size.width - newWidth)
                
                eventLayer.frame = CGRect(x:x,y:eventLayer.frame.origin.y, width: newWidth, height: eventLayer.frame.size.height)
            }
        }
        
        getCornerMask(eventLayer,borderWidth: borderWidth,borderColor: borderColor,backgroundColor: bgColor)

        if !text.isEmpty {
            let textLayer = CATextLayer()
            textLayer.shouldRasterize = true
            textLayer.rasterizationScale = UIScreen.main.scale
            textLayer.drawsAsynchronously = true
            textLayer.string = text
            textLayer.truncationMode = kCATruncationEnd
            textLayer.isWrapped = true
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.frame = CGRect(x:5,y:5,width:eventLayer.frame.width - 10,height:eventLayer.frame.height - 10)
            textLayer.foregroundColor = fontColor.cgColor
            textLayer.fontSize = getMaxFontSize(text,frame:textLayer.frame)
            textLayer.font = UIFont.boldSystemFont(ofSize: textLayer.fontSize)
            
            eventLayer.addSublayer(textLayer)
        }
        
        layer.addSublayer(eventLayer)
    }
    
    fileprivate final func getCornerMask(_ layer : CALayer, borderWidth : Int, borderColor : UIColor, backgroundColor : UIColor? = UIColor.white){
        
        let path = UIBezierPath(roundedRect:layer.bounds,
                                byRoundingCorners:[.topLeft, .bottomLeft],
                                cornerRadii: CGSize(width: 10, height: 10))
        
        let shape = CAShapeLayer()
        shape.rasterizationScale = UIScreen.main.scale
        shape.frame = frame
        shape.shouldRasterize = true
        shape.drawsAsynchronously = true
        shape.path = path.cgPath
        shape.lineWidth = CGFloat(borderWidth)
        shape.strokeColor = borderColor.cgColor
        shape.fillColor = backgroundColor?.cgColor

        if let sublayerIndex = layer.sublayers?.index(where: { (sublayer) -> Bool in
            guard let _ = sublayer as? CAShapeLayer else {return false}
            return true
        }) {
            if let sublayer = layer.sublayers?[sublayerIndex] {
                sublayer.removeFromSuperlayer()
            }
        }
        
        
        layer.addSublayer(shape)
    }
    
    fileprivate final func getMaxFontSize(_ text : String,frame : CGRect) -> CGFloat{
        var shouldCalculate = true
        var fontSize : CGFloat = 16
        let minFont : CGFloat = 12
        
        while shouldCalculate {
            let constraintRect = CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)
            
             let boundingBox = text.boundingRect(with:constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:  UIFont.boldSystemFont(ofSize: fontSize)], context: nil)
            if frame.size.height > boundingBox.height {
                shouldCalculate = false
            }else{
                fontSize -= 1
                if minFont > fontSize {
                    fontSize = minFont
                    shouldCalculate = false
                }
            }
        }
        
        return fontSize
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch : UITouch = event?.allTouches?.first {
            let point = touch.location(in: self)
            if let sublayers = layer.sublayers {
                for sublayer in sublayers.reversed() {
                    if sublayer.frame.contains(point), let castedsubLayer = sublayer as? BAGridLayer {
                        delegate?.didSelectedLayer(tagIndex: castedsubLayer.index,columnIndex: castedsubLayer.column,event: items[castedsubLayer.index])
                        break
                    }
                }
            }
        }
        
    }
    
    
}
