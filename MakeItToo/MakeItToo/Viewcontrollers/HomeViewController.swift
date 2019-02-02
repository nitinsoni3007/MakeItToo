//
//  HomeViewController.swift
//  MakeItToo
//
//  Created by Nitin on 26/01/19.
//  Copyright © 2019 Nitin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblNoItem: UILabel!
    @IBOutlet weak var createNewFolderHUD: UIView!
    @IBOutlet weak var txtFolderName: UITextField!
    @IBOutlet weak var lblUserName: UILabel!
    var arrFolders = [Folder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUserName.text = "Hi \(UserDefaults.standard.value(forKey: GlobalConstants.USER_NAME)!)!"
        loadFolders()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hudTapped))
        createNewFolderHUD.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for vc in self.navigationController!.viewControllers {
            print("vc types = \(vc)")
        }
    }
    
    @objc func hudTapped() {
        createNewFolderHUD.isHidden = true
    }
    
    deinit {
        createNewFolderHUD.removeGestureRecognizer(createNewFolderHUD.gestureRecognizers!.first!)
    }
    
    func loadFolders() {
        //if no folder
//        lblNoItem.isHidden = false
        //else
//        collectionView.isHidden = false
        LoadingView.shared.showOverlay(nil)
        ServiceManager.sharedManager.callAPI(APIAction.GET_FOLDERS, method: "GET", params: [String:String](), success: { (response) in
            print("resp = \(response)")
            let arrDicts = response["data"] as? [[String: String]] ?? [[String: String]]()
            self.arrFolders = arrDicts.map{Folder.init($0)}
            DispatchQueue.main.async {
                LoadingView.shared.hideOverlayView()
                if self.arrFolders.count > 0 {
                self.createNewFolderHUD.isHidden = true
                //                arrFolders.append(folderName)
                self.lblNoItem.isHidden = true
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
                }else {
                    self.createNewFolderHUD.isHidden = true
                    //                arrFolders.append(folderName)
                    self.lblNoItem.isHidden = false
                    self.collectionView.isHidden = true
                }
            }
            
        }) { (reason) in
            LoadingView.shared.hideOverlayView()
            print("failed = \(reason)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCreateNewAction(_ sender: Any) {
        createNewFolderHUD.isHidden = false
    }
    
    @IBAction func btnCreateAction(_ sender: Any) {
        self.view.endEditing(true)
        if let folderName = txtFolderName.text{
            if !folderName.isEmpty {
//                createNewFolderHUD.isHidden = true
////                arrFolders.append(folderName)
//                lblNoItem.isHidden = true
//                collectionView.isHidden = false
//                collectionView.reloadData()
                txtFolderName.text = ""
                addFolder(folderName)
            }
        }
    }
    
    func addFolder(_ folderName: String) {
        LoadingView.shared.showOverlay(nil)
        ServiceManager.sharedManager.callAPI(APIAction.CREATE_FOLDER, method: "POST", params: ["folderName":folderName], success: { (response) in
            print("resp = \(response)")
            LoadingView.shared.hideOverlayView()
            self.loadFolders()
        }) { (reason) in
            LoadingView.shared.hideOverlayView()
            self.showAlert(title: "Folder creation faild", message: reason)
        }
    }
    
    @IBAction func btnLogoutAction(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "logMeOut"), object: nil)
    }
    
    //MARK: collectionview delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFolders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = "folderCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let lblFolderName = cell.contentView.viewWithTag(102) as! UILabel
        lblFolderName.text = arrFolders[indexPath.item].folderName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let folder = arrFolders[indexPath.item]
        let folderDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "FolderDetailsViewController") as! FolderDetailsViewController
        folderDetailsVC.folder = folder
        navigationController?.pushViewController(folderDetailsVC, animated: true)
    }

}
