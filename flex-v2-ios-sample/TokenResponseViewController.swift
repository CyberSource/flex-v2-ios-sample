//
//  TokenResponseViewController.swift
//  flex-api-ios-sample-app
//
//  Created by Rakesh Ramamurthy on 27/03/21.
//

import Foundation
import UIKit

class TokenResponseViewController: UIViewController {
    @IBOutlet weak var responseTextView:UITextView!
    @IBOutlet weak var repeatDemoButton:UIButton!

    var responseString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.responseTextView.text = self.responseString
        setupUI()
    }
    
    func setupUI() {
        self.repeatDemoButton.backgroundColor = UIColor.init(red: 48.0/255.0, green: 85.0/255.0, blue: 112.0/255.0, alpha: 1.0)

        responseTextView.layer.cornerRadius = 5.0;
        responseTextView.layer.masksToBounds = true;
        responseTextView.layer.borderWidth = 0.5;
        responseTextView.layer.shadowColor = UIColor.black.cgColor;
        responseTextView.layer.shadowOpacity = 0.4;
        responseTextView.layer.shadowRadius = 2.0;
    }

    @IBAction func repeatDemo() {
        self.navigationController?.popViewController(animated: true)
    }

}
