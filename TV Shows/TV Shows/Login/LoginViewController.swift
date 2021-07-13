//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 13.07.2021..
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    private var numberOfTaps = 0
    private var timer: Timer!
    
    @IBAction func buttonTouchUpInside(_ sender: Any) {
        numberOfTaps += 1
        labelView.text = "The button has been tapped \(numberOfTaps) times!"
        
        //every time the button is pressed if indicator is spinning stop it,
        //if not, start spinning for 3 seconds
        if timer.isValid {
            timer.invalidate()
            activityIndicatorView.stopAnimating()
        } else {
            resetTimer()
        }
    }
    
    @IBOutlet weak var buttonView: UIButton!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelView.text = "Please tap the button."
        labelView.layer.cornerRadius = 10
        activityIndicatorView.startAnimating()
        createTimer()
    }
    
    func createTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [self] timer in
            activityIndicatorView  .stopAnimating()
                   }
        activityIndicatorView.startAnimating()
    }
    
    func resetTimer() {
        timer.invalidate()
        createTimer()
    }
}
