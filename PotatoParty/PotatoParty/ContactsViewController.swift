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


class ContactsViewController: UIViewController, DropDownMenuDelegate {

    var navigationBarMenu: DropDownMenu!
    var titleView: DropDownTitleView!
    // Views
    var bottomNavBar = BottomNavBarView()
    var collectionView = ContactsCollectionView()
    let ref = FIRDatabase.database().reference(withPath: "contacts")
    var user: User?
    var userUid: String?
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        // Setup views
        setupViews()
        
        // Firebase methods
        self.restorationIdentifier = "contactsVC"
        // Do any additional setup after loading the view.
        
        self.navigationBarMenu = DropDownMenu()
        
        let title = prepareNavigationBarMenuTitleView()
        prepareNavigationBarMenu(title)
        
        let rightBtn = UIBarButtonItem(title: "Select", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = rightBtn
        // TO DO: Write some code in place of "nil" after "action:"
        
        let leftBtn = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftBtn
        // TO DO: Write some code in place of "nil" after "action:"
        
        //navigationController?.navigationBar.isHidden = true
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            guard let user = user else { return }
            self.user = User(authData: user)
            self.userUid = user.uid
            print("Current logged in user email - \(self.user?.email)")
        })
        
        ref.observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                for item in snapshot.children.allObjects {
                    self.contacts.append(Contact(snapshot: item as! FIRDataSnapshot))
                }
                print("Current contacts list contains:")
                dump(self.contacts)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationBarMenu.container = view
        
        //toolbarMenu.container = view
    }
    
    
    func prepareNavigationBarMenuTitleView() -> String {
        // Both title label and image view are fixed horizontally inside title
        // view, UIKit is responsible to center title view in the navigation bar.
        // We want to ensure the space between title and image remains constant,
        // even when title view is moved to remain centered (but never resized).
        titleView = DropDownTitleView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        
        
        titleView.addTarget(self, action: #selector(self.willToggle), for: .touchUpInside)
        titleView.titleLabel.textColor = UIColor.black
        titleView.title = "Lists"
        
        navigationItem.titleView = titleView
        
        return titleView.title!
    }
    
    public func didTapInDropDownMenuBackground(_ menu: DropDownMenu) {
        
    }
    
    func willToggle(){
        if self.titleView.isUp{
            navigationBarMenu.hide()
        }else{
            navigationBarMenu.show()
        }
    }
    
    
    func prepareNavigationBarMenu(_ currentChoice: String) {
        navigationBarMenu = DropDownMenu(frame: view.bounds)
        
        navigationBarMenu.delegate = self
        
        let firstCell = DropDownMenuCell()
        
        firstCell.textLabel!.text = "List 1"
        firstCell.menuAction = nil
        firstCell.menuTarget = self
        if currentChoice == "List 1" {
            firstCell.accessoryType = .checkmark
        }
        
        let secondCell = DropDownMenuCell()
        
        secondCell.textLabel!.text = "List 2"
        secondCell.menuAction = nil
        secondCell.menuTarget = self
        if currentChoice == "List 2" {
            firstCell.accessoryType = .checkmark
        }
        
        navigationBarMenu.menuCells = [firstCell, secondCell]
        navigationBarMenu.selectMenuCell(secondCell)
        
        // If we set the container to the controller view, the value must be set
        // on the hidden content offset (not the visible one)
        navigationBarMenu.visibleContentOffset =
            navigationController!.navigationBar.frame.size.height + 24
        
        // For a simple gray overlay in background
        navigationBarMenu.backgroundView = UIView(frame: navigationBarMenu.bounds)
        navigationBarMenu.backgroundView!.backgroundColor = UIColor.black
        navigationBarMenu.backgroundAlpha = 0.7
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ContactsViewController {
    
    // Setup all views
    func setupViews() {
        setupCollectionView()
        setupTopNavBarView()
        setupBottomNavBarView()
    }
    
    // Setup individual views
    func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.875)
        }
    }
    
    func setupBottomNavBarView() {
        self.view.addSubview(bottomNavBar)
        bottomNavBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.125)
        }
    }
    
    func setupTopNavBarView() {
        // Do this
    }
    
}
