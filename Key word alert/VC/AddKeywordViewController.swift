//
//  AddKeywordViewController.swift
//  Key word alert
//
//  Created by Borui Zhou on 2018-03-07.
//  Copyright © 2018 Borui Zhou. All rights reserved.
//

import UIKit
import CoreData

class AddKeywordViewController: UIViewController {
    
    // MARK: -Properties
    
    var managedContext: NSManagedObjectContext!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var inputKeyword: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var forumField: UITextField!
    @IBOutlet weak var frequencyField: UITextField!
    @IBOutlet weak var exipringDateField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: .UIKeyboardWillShow, object: nil)
        //inputKeyword.becomeFirstResponder()
    
    }
    
    // MARK: Actions
    @objc func keyboardWillShow(with notification: Notification){
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height + 16
        
        bottomConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
        inputKeyword.resignFirstResponder()
    }
    
    @IBAction func done(_ sender: UIButton) {
        guard let keywordName = inputKeyword.text, !keywordName.isEmpty else {
            return
        }
        
        let keyword = Keyword(context: managedContext)
        keyword.keyword = inputKeyword.text
        //keyword.timestamp = Date()
        
        do {
            try managedContext.save()
            dismiss(animated: true)
            inputKeyword.resignFirstResponder()
        } catch {
            print("Error saving keywords: \(error)")
        }
     
    }


}

extension AddKeywordViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ inputKeyword: UITextField) {
        if doneButton.isHidden{
            inputKeyword.text?.removeAll()
            inputKeyword.textColor = .black
            
            doneButton.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
        }
    }
   
}
