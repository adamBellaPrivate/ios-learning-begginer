//
//  ViewController.swift
//  TemperatureUnitConverter
//
//  Created by Ádám Bella on 1/29/18.
//  Copyright © 2018 Ádám Bella. All rights reserved.
//

import UIKit

extension ViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addKeyboardObserver(scrollView, viewToScrollTo: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let newValue : Double = Double(textField.text ?? "") ?? 0
        if textField == celsiusInputTextField {
            temperature = Temperature(celsius: newValue)
        }else if textField == fahrenheitInputTextField {
            temperature = Temperature(fahrenheit: newValue)
        }else if textField == kelvinInputTextField {
            temperature = Temperature(kelvin: newValue)
        }
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var celsiusInputTextField: UITextField!
    @IBOutlet weak var fahrenheitInputTextField: UITextField!
    @IBOutlet weak var kelvinInputTextField: UITextField!
    
    fileprivate var dismissSingleTapRecognizer : UITapGestureRecognizer?
    fileprivate var baseScrollView  : UIScrollView?
    fileprivate var baseViewToScrollTo : UIView?
    fileprivate var temperature : Temperature? {
        didSet {
            guard let temp = temperature else {
                celsiusInputTextField.text = ""
                fahrenheitInputTextField.text = ""
                kelvinInputTextField.text = ""
                return
            }
            celsiusInputTextField.text = "\(temp.celsius)"
            fahrenheitInputTextField.text = "\(temp.fahrenheit)"
            kelvinInputTextField.text = "\(temp.kelvin)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissKeyboardGestureRecognizerToView(view)
    }
    
    //MARK: - Keyboard controls
    
    final func addDismissKeyboardGestureRecognizerToView(_ customView : UIView){
        dismissSingleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.singleTapGestureCaptured(_:)))
        
        customView.addGestureRecognizer(dismissSingleTapRecognizer!)
    }
    
    final func removeDismissSignleTapRecognizer(_ customView : UIView){
        if let checkedDissmisRecognizer = dismissSingleTapRecognizer{
            customView.removeGestureRecognizer(checkedDissmisRecognizer)
        }
    }
    
    @objc final func singleTapGestureCaptured(_ gesture : UITapGestureRecognizer){
        dismissKeyboardByManual()
    }
    
    final func dismissKeyboardByManual(){
        view.endEditing(false)
    }
    
    //MARK: Keyboards observers
    
    final func addKeyboardObserver(_ scrollView: UIScrollView, viewToScrollTo : UIView){
        baseScrollView = scrollView
        baseViewToScrollTo = viewToScrollTo
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardDidShow, object: nil, queue: OperationQueue.main){ [weak self](notification) in
            guard let wSelf = self else {return}
            wSelf.keyboardWasShown(notification)
        }
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { [weak self](notification) in
            guard let wSelf = self else {return}
            wSelf.keyboardWillBeHidden(notification)
        }
    }
    
    final func removeKeyboardObserver(){
        baseScrollView = nil
        baseViewToScrollTo = nil
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    final func keyboardWasShown(_ noti : Notification){
        guard let info  = noti.userInfo as? [String:AnyObject] else {return}
        
        guard var keyboardRect = info[UIKeyboardFrameEndUserInfoKey]?.cgRectValue else {return}
        
        keyboardRect = view.convert(keyboardRect, from: nil)
        
        guard let adjustableScrollView = baseScrollView else {return}
        
        let scrollViewRect = view.convert(adjustableScrollView.frame, from: adjustableScrollView.superview)
        
        let hiddenScrollViewRect = scrollViewRect.intersection(keyboardRect)
        
        if hiddenScrollViewRect.isNull == false {
            let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, hiddenScrollViewRect.size.height, 0.0)
            
            adjustableScrollView.contentInset = contentInsets
            adjustableScrollView.scrollIndicatorInsets = contentInsets
            
            guard let correctView = baseViewToScrollTo, keyboardRect.origin.y < correctView.frame.origin.y else {return}
            
            let scrollPoint : CGPoint = CGPoint(x: 0.0, y: correctView.frame.origin.y - (scrollViewRect.size.height - keyboardRect.size.height) + correctView.frame.size.height)
            adjustableScrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    final func keyboardWillBeHidden(_ noti : Notification){
        guard let adjustableScrollView = baseScrollView else {return}
        
        adjustableScrollView.contentInset = UIEdgeInsets.zero
        adjustableScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }


}

