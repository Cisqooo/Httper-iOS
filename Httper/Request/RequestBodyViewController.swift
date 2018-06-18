//
//  RequestBodyViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 12/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit
import MGKeyboardAccessory

class RequestBodyViewController: UIViewController {

    var characters: [String]!
    
    var body: String!
    
    @IBOutlet weak var rawBodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if body != nil {
            rawBodyTextView.text = body
        } else {
            rawBodyTextView.text = ""
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        rawBodyTextView.setupKeyboardAccessory(UserManager.sharedInstance.characters!, barStyle: .black)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        characters = UserManager.sharedInstance.characters!
        rawBodyTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "bodyChanged"), object: rawBodyTextView.text)
    }

    // MARK: - Action
    @IBAction func cleatRequestBody(_ sender: Any) {
        let alertController = UIAlertController(title: NSLocalizedString("tip_name", comment: ""),
                                                message: NSLocalizedString("clear_request_body", comment: ""),
                                                preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: NSLocalizedString("cancel_name", comment: ""),
                                                style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("yes_name", comment: ""),
                                                style: .destructive) { action in
            self.rawBodyTextView.text = ""
        })
        self.present(alertController, animated: true, completion: nil)
    }
    

    func addTab() {
        if rawBodyTextView.isFirstResponder {
            rawBodyTextView.text = rawBodyTextView.text! + "  "
        }
    }
}
