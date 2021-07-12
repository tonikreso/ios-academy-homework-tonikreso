//
//  ViewController.swift
//  TV Shows
//
//  Created by Infinum on 08.07.2021..
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("test")
        self.titleLabel.text = "This is my second app"
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            SVProgressHUD.dismiss()
        }
    }


}

