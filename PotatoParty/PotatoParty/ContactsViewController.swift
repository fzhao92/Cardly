//
//  ContactsViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseDatabase
import FirebaseAuth
import SnapKit
import MobileCoreServices


class ContactsViewController: UIViewController, DropDownMenuDelegate, AddContactsDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Views
    var collectionView: ContactsCollectionView!
    var bottomNavBar: BottomNavBarView!
    var navigationBarMenu: DropDownMenu!
    var titleView: DropDownTitleView!
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    var timer = Timer()
    var pickGroup = UIPickerView()
    var pickerData = ["All", "Family", "Friends", "Coworkers", "Other"]
    var chosenGroup = ""

    fileprivate let cellHeight: CGFloat = 210
    fileprivate let cellSpacing: CGFloat = 20
    
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    let ref = FIRDatabase.database().reference(withPath: "contacts")
    let uid = User.shared.uid
    
    var shared = User.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        // MARK: - Setup Views
        setupViews()
        collectionView.contactDelegate = self
        self.restorationIdentifier = "contactsVC"
        
        self.navigationBarMenu = DropDownMenu()
        
        pickGroup.delegate = self
        pickGroup.dataSource = self

        let title = prepareNavigationBarMenuTitleView()
        prepareNavigationBarMenu(title)
        
  
        
        let rightBtn = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(self.selectBtnClicked))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        
        
        let btnName = UIButton()
        btnName.setTitle("Settings", for: .normal)
        btnName.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        btnName.addTarget(self, action: #selector(self.navToSettingsVC), for: .touchUpInside)
        
        //.... Set Right/Left Bar Button item
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftBarButton
        
//        let leftBtn = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(self.navToSettingsVC))
//        self.navigationItem.leftBarButtonItem = leftBtn
        
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        retrieveContacts(for: User.shared.groups[0], completion: { contacts in
            self.collectionView.contacts = contacts
            self.collectionView.reloadData()
        })
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationBarMenu.container = view
    }
    
    // MARK: - Navigation Bar Dropdown
    
    func prepareNavigationBarMenuTitleView() -> String {
        titleView = DropDownTitleView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        
        titleView.addTarget(self, action: #selector(self.willToggleNavigationBarMenu(_:)), for: .touchUpInside)
        titleView.addTarget(self, action: #selector(self.didToggleNavigationBarMenu(_:)), for: .valueChanged)
        
        titleView.titleLabel.textColor = UIColor.black
        titleView.title = "Lists"
        
        navigationItem.titleView = titleView
        
        return titleView.title!
    }
    
    func showToolbarMenu() {
        if titleView.isUp {
            titleView.toggleMenu()
        }
        navigationBarMenu.show()
    }
    
    func willToggleNavigationBarMenu(_ sender: DropDownTitleView) {
        navigationBarMenu.hide()
        
        if sender.isUp {
            navigationBarMenu.hide()
        }
        else {
            navigationBarMenu.show()
        }
    }
    
    func didToggleNavigationBarMenu(_ sender: DropDownTitleView) {
        print("Sent did toggle navigation bar menu action")
    }
    
    func didTapInDropDownMenuBackground(_ menu: DropDownMenu) {
        if menu == navigationBarMenu {
            titleView.toggleMenu()
        }
        else {
            menu.hide()
        }
    }
    
    
    func prepareNavigationBarMenu(_ currentChoice: String) {
        navigationBarMenu = DropDownMenu(frame: view.bounds)
        
        navigationBarMenu.delegate = self
        
        let arrayofWeddingLists = User.shared.groups
        
        var menuCellArray = [DropDownMenuCell]()
        for list in arrayofWeddingLists {
            let firstCell = DropDownMenuCell()
            firstCell.textLabel!.text = list

            firstCell.menuAction = #selector(selectGroup(_:))

            firstCell.menuTarget = self
            if currentChoice == list {
                firstCell.accessoryType = .checkmark
            }
            
            menuCellArray.append(firstCell)
        }
        
        navigationBarMenu.menuCells = menuCellArray
        navigationBarMenu.selectMenuCell(menuCellArray[0])
        navigationBarMenu.visibleContentOffset = navigationController!.navigationBar.frame.size.height + 24
        
        // For a simple gray overlay in background
        navigationBarMenu.backgroundView = UIView(frame: navigationBarMenu.bounds)
        navigationBarMenu.backgroundView!.backgroundColor = UIColor.black
        navigationBarMenu.backgroundAlpha = 0.7
    }
    
    func selectGroup(_ sender: UITableViewCell) {
        guard let group = sender.textLabel?.text?.lowercased() else { return }
        self.retrieveContacts(for: group, completion: { contacts in
            self.collectionView.contacts = contacts
            self.collectionView.reloadData()
        })
        navigationBarMenu.hide()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // AlertConroller & UIPicker View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            chosenGroup = "all"
            updateGroup {
                shared.selectedContacts.removeAll()
                
            }
            self.dismiss(animated: true, completion: nil)
            print( "all")
        case 1:
            chosenGroup = "family"
            updateGroup {
                shared.selectedContacts.removeAll()
                //self.collectionView.reloadData()
//                //removed red border/"selected state"
//                contentView.layer.borderWidth = 0.0
//                contentView.layer.borderColor = UIColor.clear.cgColor
            }
            self.dismiss(animated: true, completion: nil)
            print("family")
        case 2:
            chosenGroup = "friends"
            updateGroup {
                shared.selectedContacts.removeAll()
                self.collectionView.reloadData()
            }
            self.dismiss(animated: true, completion: nil)
        case 3:
            chosenGroup = "coworkers"
            updateGroup {
                shared.selectedContacts.removeAll()
            }
            self.dismiss(animated: true, completion: nil)
        case 4:
            chosenGroup = "other"
            updateGroup {
                shared.selectedContacts.removeAll()
            }
            self.dismiss(animated: true, completion: nil)
            print("other")
        default:
            print("error")
        }
    }
    
    func showPickerInAlert() {
    let alert = UIAlertController(title: "Choose Group", message: "\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet)
        //set up pickGroup frame
       // var okayAction =  UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        //alert.addAction(okayAction)
        alert.view.addSubview(pickGroup)
        
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Layout view elements

extension ContactsViewController {
    
    // Setup all views
    func setupViews() {
        setupCollectionView()
        setupTopNavBarView()
        setupBottomNavBarView()
    }
    
    // Setup individual views
    func setupCollectionView() {
        collectionView = ContactsCollectionView(frame: self.view.frame)
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    func setupBottomNavBarView() {
        bottomNavBar = BottomNavBarView()
        bottomNavBar.leftIconView.delegate = self
        bottomNavBar.rightIconView.delegate = self
        bottomNavBar.middleIconView.delegate = self
        self.view.addSubview(bottomNavBar)
        bottomNavBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.125)
        }
        
    }
    
    func setupTopNavBarView() {
        
    }
    
}


// MARK: - Navigation methods (buttons)

extension ContactsViewController: BottomNavBarDelegate {
    
    func navToSettingsVC(_ sender: UIButton) {
        print("hey im being pressed!!!")
        let destVC = SettingsViewController()
        //navigationController?.pushViewController(destVC, animated: true)
        
        
        destVC.modalPresentationStyle = .custom
        destVC.transitioningDelegate = self
        
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        
//        
//        view.backgroundColor = UIColor.white
//       
        presentationAnimator.animationDuration = 0.2
        //presentationAnimator.
        presentationAnimator.animationDelegate = destVC as? GuillotineAnimationDelegate
        //presentationAnimator.supportView = navigationController!.navigationBar
        presentationAnimator.presentButton = view
        present(destVC, animated: true, completion: nil)     
    }
    
    func selectBtnClicked() {
        let destVC = ContactsViewController()
        navigationController?.pushViewController(destVC, animated: false)
        print("\n\n Select Button Clicked Working")
    }

    func goToAddContact(){
        print("go to Add Contact function")
        let destVC = AddContactViewController()
        navigationController?.pushViewController(destVC, animated: false)
        //send to ADD contacts view controller
    }
    
    func deleteButtonPressed() {
        
        deleteContacts {
            retrieveContacts(for: User.shared.groups[0], completion: { contacts in
                self.collectionView.contacts = contacts
                self.collectionView.reloadData()
            })
            //collectionView.reloadData()
        }
    
    }
    
    func editGroupButtonPressed(){
        showPickerInAlert()
        print("edit group button pressed")
    }
    
    //Updates Contact Group property and reloaded Collection View
    
    func updateGroup(completion: () -> ()){
        for (index, contact) in shared.selectedContacts.enumerated() {
            
            removeFromSomeGroupsinFB(contact: contact)
            
            shared.selectedContacts[index].group_key = chosenGroup
       
            //update group bucket
            let groupsRef = FIRDatabase.database().reference(withPath: "groups")
            let allGroupPath = groupsRef.child("\(uid)/\(chosenGroup)")
            let groupItemRef = allGroupPath.child(contact.key)
            groupItemRef.setValue(contact.toAny())

           
            //update contact group bucket
            let contactsPath = ref.child("\(uid)/\(chosenGroup)")
            let contactItemRef = contactsPath.child(contact.key)
            contactItemRef.setValue(contact.toAny())
            
            }
        
    }
    
    func enableBottomNavButtons(){
        
    }
    
    func sendToButtonPressed() {
        
        navToRecordCardVC()
    }
    
    
    func navToRecordCardVC() {
        let _ = startCameraFromViewController(self, withDelegate: self)
    }
    
    
    
    
}

// MARK: - Firebase methods

extension ContactsViewController {
    
    func retrieveContacts(for group: String, completion: @escaping (_: [Contact]) -> Void) {
        var contacts: [Contact] = []
        let path = "\(uid)/\(group.lowercased())/"
        let contactBucketRef = ref.child(path)
        contactBucketRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                for item in snapshot.children.allObjects {
                    contacts.append(Contact(snapshot: item as! FIRDataSnapshot))
                }
            }
            completion(contacts)
        })
    }
    
    func deleteContacts(completion: ()->()) {
        
        for contact in shared.selectedContacts{
            removeFromAllGroupsinFB(contact: contact)
            shared.selectedContacts.removeAll()
            shared.contacts.removeAll()
           
        }
        
        completion()
    }
    func removeFromSomeGroupsinFB(contact: Contact){
        
        let familyPath = "\(uid)/family/\(contact.key)"
        let friendsPath = "\(uid)/friends/\(contact.key)"
        let coworkersPath = "\(uid)/coworkers/\(contact.key)"
        let otherPath = "\(uid)/other/\(contact.key)"
        
        ref.child(familyPath).removeValue()
        ref.child(friendsPath).removeValue()
        ref.child(coworkersPath).removeValue()
        ref.child(otherPath).removeValue()
        
        let groupsRef = FIRDatabase.database().reference(withPath: "groups")
        let familyGroupPath = "\(uid)/family/\(contact.key)"
        let friendsGroupPath = "\(uid)/friends/\(contact.key)"
        let coworkersGroupPath = "\(uid)/coworkers/\(contact.key)"
        let otherGroupPath = "\(uid)/other/\(contact.key)"
        
        groupsRef.child(familyGroupPath).removeValue()
        groupsRef.child(friendsGroupPath).removeValue()
        groupsRef.child(coworkersGroupPath).removeValue()
        groupsRef.child(otherGroupPath).removeValue()
    }
    
    func removeFromAllGroupsinFB(contact: Contact) {
        let allPath = "\(uid)/all/\(contact.key)"
        let familyPath = "\(uid)/family/\(contact.key)"
        let friendsPath = "\(uid)/friends/\(contact.key)"
        let coworkersPath = "\(uid)/coworkers/\(contact.key)"
        let otherPath = "\(uid)/other/\(contact.key)"
        ref.child(allPath).removeValue()
        ref.child(familyPath).removeValue()
        ref.child(friendsPath).removeValue()
        ref.child(coworkersPath).removeValue()
        ref.child(otherPath).removeValue()
        
        let groupsRef = FIRDatabase.database().reference(withPath: "groups")
        let allGroupPath = "\(uid)/all/\(contact.key)"
        let familyGroupPath = "\(uid)/family/\(contact.key)"
        let friendsGroupPath = "\(uid)/friends/\(contact.key)"
        let coworkersGroupPath = "\(uid)/coworkers/\(contact.key)"
        let otherGroupPath = "\(uid)/other/\(contact.key)"
        groupsRef.child(allGroupPath).removeValue()
        groupsRef.child(familyGroupPath).removeValue()
        groupsRef.child(friendsGroupPath).removeValue()
        groupsRef.child(coworkersGroupPath).removeValue()
        groupsRef.child(otherGroupPath).removeValue()
      
    }
    
}


// MARK: - Show Camera VC
extension ContactsViewController {
    
    func startCameraFromViewController(_ viewController: UIViewController, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = true //allow video editing
        cameraController.cameraCaptureMode = .video
        cameraController.delegate = delegate
        cameraController.videoQuality = .typeHigh
        cameraController.videoMaximumDuration = 20.0
        
        let maxRecordTime = "Max Record Time is 20 sec"
        let maxTimeLabel = UILabel()
        maxTimeLabel.text = maxRecordTime
        maxTimeLabel.textAlignment = .center
        maxTimeLabel.textColor = UIColor.red
        cameraController.view.addSubview(maxTimeLabel)

        maxTimeLabel.snp.makeConstraints { (make) in
            make.topMargin.equalToSuperview().offset(50)
            make.leadingMargin.equalToSuperview().offset(-300)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        
        present(cameraController, animated: true, completion: {
            cameraController.view.layoutIfNeeded()
            
            maxTimeLabel.snp.remakeConstraints({ (make) in
                make.topMargin.equalToSuperview().offset(50)
                make.centerX.equalToSuperview()
                make.width.equalTo(300)
                make.height.equalTo(20)
            })
            
            cameraController.view.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut, animations: {
                print("In animation")
                cameraController.view.layoutIfNeeded()
            }, completion: { (complete) in
                UIView.animate(withDuration: 2, animations: {
                    maxTimeLabel.alpha = 0
                })
            })
        })
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ContactsViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("In did finish picking media")
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        dismiss(animated: true, completion: nil)
        // Handle a movie capture
        if mediaType == kUTTypeMovie {
            guard let unwrappedURL = info[UIImagePickerControllerMediaURL] as? URL else { return }
            
            // Pass video to edit video viewcontroller
            let editVideoVC = EditCardViewController()
            editVideoVC.fileLocation = unwrappedURL
            navigationController?.pushViewController(editVideoVC, animated: true)
        }
    }
    
    
}

// MARK: - UINavigationControllerDelegate

extension ContactsViewController: UINavigationControllerDelegate {
    
}


// MARK: - Animated Settings Button


extension ContactsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}



//extension ContactsViewController: GuillotineAnimationDelegate {
//    
//    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation) {
//        print("menuDidFinishPresentation")
//    }
//    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation) {
//        print("menuDidFinishDismissal")
//    }
//    
//    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation) {
//        print("willStartPresentation")
//    }
//    
//    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation) {
//        print("willStartDismissal")
//    }
//}
//


protocol AddContactsDelegate: class {
   func goToAddContact()
}





