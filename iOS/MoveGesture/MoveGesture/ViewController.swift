//
//  ViewController.swift
//  MoveGesture
//
//  Created by Ádám Bella on 3/26/17.
//  Copyright © 2017 Ádám Bella. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var backgroundImageView: UIImageView!

    fileprivate var counter = 0
    fileprivate let colors : [UIColor] = [.green,.yellow,.red]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    fileprivate final func newPin(){
        let player = UIImageView(frame: CGRect(x:0,y:0,width:50,height:50))
        counter += 1
        player.tag = 100 + counter
        
        let diceRoll = Int(arc4random_uniform(UInt32(colors.count)))
        
        player.backgroundColor = colors[diceRoll]
        player.isUserInteractionEnabled = true
        //player.image = UIImage(named: "")
        
       //backgroundImageView.addSubview(player)
       view.insertSubview(player, aboveSubview: backgroundImageView)
        
        addPanGestureRecognizer(player)
        addRemoveGestureRecognizer(player)
    }

    //MARK: MOVE
    
    fileprivate final func addPanGestureRecognizer(_ playerSubview : UIImageView){
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.movePlayer(_:)))
        gesture.delegate = self
        gesture.maximumNumberOfTouches = 1
        playerSubview.addGestureRecognizer(gesture)
    }
    
    @objc func movePlayer(_ pan : UIPanGestureRecognizer){
        switch pan.state {
        case .began:
            break
        case .changed:
            guard let targetView = pan.view else{return}
            
            let offset = pan.translation(in: targetView.superview!)
            
            var center = targetView.center
            
            center.x += offset.x
            center.y += offset.y
            
            targetView.center = center
            
            pan.setTranslation(CGPoint.zero, in: targetView)
            
            break
        case .ended:
            break
        default:
            return
        }
    }
    
    //MARK: DELETE
    
    fileprivate final func addRemoveGestureRecognizer(_ playerSubview : UIImageView){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.deletePlayerFromSuperView(_:)))
        gesture.minimumPressDuration = 2
        playerSubview.addGestureRecognizer(gesture)
    }
    
    @objc func deletePlayerFromSuperView(_ gestureRecognizer : UILongPressGestureRecognizer){
        switch gestureRecognizer.state {
        case .ended:
            gestureRecognizer.view?.removeFromSuperview()
            break
        default:
            return
        }
    }

    @IBAction func addNewPlayer(_ sender: Any) {
         newPin()
    }
}

