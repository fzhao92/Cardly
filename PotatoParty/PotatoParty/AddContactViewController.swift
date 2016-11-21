//
//  AddContactViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddContactViewController: UIViewController {

    var nameTextField = UITextField()
    var emailTextField = UITextField()
    var addButton = UIButton()
    var groupDropDown = UIPickerView()
    var importContactsButton = UIButton()
    var cancelButton = UIButton()
    let namePlaceholder = "Name"
    let emailPlaceholder = "example@serviceprovider"
    
    var dataDict = [String: String] ()
    
    var userUID: String = ""
    
    let contactRef = FIRDatabase.database().reference(withPath: "contacts")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutElements()
        print("USERUID: \(userUID)")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func cancelButtonTapped () {
        dismiss(animated: true, completion: nil)
    }

    func importContactButtonTapped () {
        print ("import Contact Button Tapped")
    }

    func addButtonTapped () {
        guard let email = emailTextField.text, let name = nameTextField.text else { return }
        let contact = Contact(fullName: name, email: email, phone: "7322225678")
        let userContactsRef = contactRef.child(userUID)
        let contactItemRef = userContactsRef.childByAutoId()
        contactItemRef.setValue(contact.toAny())
        
        nameTextField.text = namePlaceholder
        emailTextField.text = emailPlaceholder
    }
    
    
    
   
    

}
