//
//  ViewController.swift
//  HelloWorld
//
//  Created by Ádám Bella on 1/19/18.
//  Copyright © 2018 Ádám Bella. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var pageTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Called by viewDidLoad")
        pageTitleLabel.text = "Hello World!"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Called by viewwillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Called by viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Called by viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Called by viewDidDisappear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("Called by deinit")
    }
}

