//
//  ViewController.swift
//  Cal
//
//  Created by AIBN on 2020/10/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var res: UILabel!
    var calculator = Calculator()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func number(_ sender: UIButton){
        let input = sender.titleLabel?.text
        res.text = calculator.HandleNum(input!)
    }
    
    @IBAction func operation(_ sender: UIButton){
        let input = sender.titleLabel?.text
        res.text = calculator.HandleOp(input!)
    }

}

