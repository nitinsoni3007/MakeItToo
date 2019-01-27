//
//  FoldersViewController.swift
//  MakeItToo
//
//  Created by Nitin on 27/01/19.
//  Copyright © 2019 Nitin. All rights reserved.
//

import UIKit

class FolderDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ScannerViewDelegate {
    
    @IBOutlet weak var cvFile: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNoItem: UILabel!
    var arrFiles = [String]()
    var folder = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = folder
        if arrFiles.count == 0 {
            lblNoItem.isHidden = false
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnScanAction(_ sender: Any) {
        let scannerVC = self.storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        scannerVC.delegate = self
        navigationController?.pushViewController(scannerVC, animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK : collection view delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = "fileCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let imgView = cell.contentView.viewWithTag(101) as! UIImageView
//        imgView.image = UIImage(named: arrFiles[indexPath.item])
        return cell
    }
    
    //MARK: scannerView delegate
    func didAddFile() {
        
    }
    
}
