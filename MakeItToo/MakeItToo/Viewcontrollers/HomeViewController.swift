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
    var arrFolders = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFolders()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hudTapped))
        createNewFolderHUD.addGestureRecognizer(tapGesture)
    }
    
    @objc func hudTapped() {
        createNewFolderHUD.isHidden = true
    }
    
    deinit {
        createNewFolderHUD.removeGestureRecognizer(createNewFolderHUD.gestureRecognizers!.first!)
    }
    
    func loadFolders() {
        //if no folder
        lblNoItem.isHidden = false
        //else
//        collectionView.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCreateNewAction(_ sender: Any) {
        createNewFolderHUD.isHidden = false
    }
    
    @IBAction func btnCreateAction(_ sender: Any) {
        if let folderName = txtFolderName.text{
            if !folderName.isEmpty {
                createNewFolderHUD.isHidden = true
                arrFolders.append(folderName)
                lblNoItem.isHidden = true
                collectionView.isHidden = false
                collectionView.reloadData()
                txtFolderName.text = ""
            }
        }
    }
    
    //MARK: collectionview delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFolders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = "folderCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let lblFolderName = cell.contentView.viewWithTag(102) as! UILabel
        lblFolderName.text = arrFolders[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let folderName = arrFolders[indexPath.item]
        let folderDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "FolderDetailsViewController") as! FolderDetailsViewController
        folderDetailsVC.folder = folderName
        navigationController?.pushViewController(folderDetailsVC, animated: true)
    }

}
