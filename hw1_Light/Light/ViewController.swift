//
//  ViewController.swift
//  Light
//
//  Created by AIBN on 2020/9/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var myLabel: UILabel!
    @IBAction func changeState(){
        if myLabel.text == "ON"{
            myLabel.text = "OFF"
            self.view.backgroundColor = UIColor.white
        }
        else{
            myLabel.text = "ON"
            self.view.backgroundColor = UIColor.black
        }
    }
    
}

