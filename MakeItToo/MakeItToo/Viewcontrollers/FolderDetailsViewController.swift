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
    var arrFileContents = [FileContent]()
    var folder : Folder!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = folder.folderName
        
        fetchContents(folder.folderId!)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func fetchContents(_ folderId: String) {
        LoadingView.shared.showOverlay(nil)
        ServiceManager.sharedManager.callAPI(APIAction.GET_CONTENTS + folderId, method: "GET", params:[String: String](), success: { (resp) in
            print("resp = \(resp)")
            let arrDicts = resp["data"] as? [[String: String]] ?? [[String: String]]()
            self.arrFileContents = arrDicts.map{FileContent.init($0)}
            DispatchQueue.main.async {
                LoadingView.shared.hideOverlayView()
            if self.arrFileContents.count == 0 {
                self.lblNoItem.isHidden = false
                self.cvFile.isHidden = true
            }else {
                self.lblNoItem.isHidden = true
                self.cvFile.isHidden = false
                self.cvFile.reloadData()
                }
            }
        }) { (reason) in
            LoadingView.shared.hideOverlayView()
            print("failedWith reason = \(reason)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnScanAction(_ sender: Any) {
        let scannerVC = self.storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        scannerVC.delegate = self
        scannerVC.folder = self.folder
        navigationController?.pushViewController(scannerVC, animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK : collection view delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFileContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = "fileCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let imgView = cell.contentView.viewWithTag(101) as! UIImageView
        imgView.layer.cornerRadius = 8.0
        imgView.clipsToBounds = true
//        imgView.image = UIImage(named: arrFiles[indexPath.item])
        
        let fileContent = self.arrFileContents[indexPath.item]
        if fileContent.imgData != nil {
            imgView.image = UIImage(data: fileContent.imgData!)
        }else {
        DispatchQueue.global().async {
            if let url = URL(string: fileContent.imageSmall){
            do {
            let imgData = try Data(contentsOf: url)
                fileContent.imgData = imgData
                DispatchQueue.main.async {
                    imgView.image = UIImage(data: imgData)
                }
            }catch {

            }
            }
        }
        }
//        imgView.image = (UIApplication.shared.delegate as! AppDelegate).currImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fileContentVC = self.storyboard?.instantiateViewController(withIdentifier: "FileContentDetailsViewController") as! FileContentDetailsViewController
        let fileContent = self.arrFileContents[indexPath.item]
        fileContentVC.fileImgUrlStr = fileContent.imageBig
        fileContentVC.imgSmall = UIImage(data: fileContent.imgData!)
        self.navigationController?.pushViewController(fileContentVC, animated: true)
    }
    
    //MARK: scannerView delegate
    func didAddFile() {
        
//        self.arrFiles.append(img)
//        self.lblNoItem.isHidden = true
//        self.cvFile.isHidden = false
//            self.cvFile.reloadData()
        self.fetchContents(folder.folderId!)
        
        
    }
    
}
