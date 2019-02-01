//
//  ImageCaptureViewController.swift
//  MakeItToo
//
//  Created by Nitin on 31/01/19.
//  Copyright © 2019 Nitin. All rights reserved.
//

import UIKit

class ImageCaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgCaptContainerView: UIView!
    var sku = ""
    var folder: Folder!
    
    @IBOutlet weak var imgScanned: UIImageView!
    var imgPickerController: UIImagePickerController!
    var isImgScanned = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isImgScanned == false {
        showImagePicker()
        }
    }
    
    func showImagePicker() {
        self.imgPickerController = UIImagePickerController()
        self.imgPickerController.sourceType = .camera
        self.imgPickerController.delegate = self
        self.present(self.imgPickerController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        let vc = navigationController?.viewControllers.filter{$0 is FolderDetailsViewController}.first
        self.navigationController?.popToViewController(vc!, animated: false)
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        let imgData = UIImagePNGRepresentation(self.imgScanned.image!)
//        ServiceManager.sharedManager.uploadImage(imgData!, folderId: folder.folderId!) { (resp) in
//            print("resp = \(resp)")
//        }
    }
    
    @IBAction func btnRetakeAction(_ sender: Any) {
//        showImagePicker()
    }
    
    //MARK : Image picker delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imgScanned.image = img
        self.dismiss(animated: true, completion: nil)
    }
    
}
