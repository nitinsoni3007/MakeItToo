//
//  ScannerViewController.swift
//  MakeItToo
//
//  Created by Nitin on 27/01/19.
//  Copyright © 2019 Nitin. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScannerViewDelegate {
    func didAddFile()
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var delegate: ScannerViewDelegate?
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet var scennerView:UIView!
    var imgPickerController: UIImagePickerController!
    var folder: Folder!
    var imgScanned = false
    
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = folder.folderName!
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if imgScanned == false {
        openbarCodeScanner()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func openbarCodeScanner()
    {
        //Camera
        
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            // metadataOutput.setMetadataObjectsDelegate(self as? AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.upce,
                                                  AVMetadataObject.ObjectType.code39,
                                                  AVMetadataObject.ObjectType.code39Mod43,
                                                  AVMetadataObject.ObjectType.code93,
                                                  AVMetadataObject.ObjectType.code128,
                                                  AVMetadataObject.ObjectType.ean8,
                                                  AVMetadataObject.ObjectType.ean13,
                                                  AVMetadataObject.ObjectType.aztec,
                                                  AVMetadataObject.ObjectType.pdf417,
                                                  AVMetadataObject.ObjectType.itf14,
                                                  AVMetadataObject.ObjectType.dataMatrix,
                                                  AVMetadataObject.ObjectType.interleaved2of5,
                                                  AVMetadataObject.ObjectType.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //previewLayer.frame = self.scennerViewShipment.layer.bounds
        print(self.scennerView.frame.origin.y)
        previewLayer.frame = CGRect(x: 0, y: 0, width:  self.scennerView.frame.size.width, height: self.scennerView.frame.size.height)
        previewLayer.videoGravity = .resizeAspectFill
        self.scennerView.layer.addSublayer(previewLayer)
        self.scennerView.clipsToBounds = true
        
        self.startScanning()
        
        
    }
    
    func startScanning() {
        
        captureSession.startRunning()
    }
    func failed() {
        //self.showPopup(ForSuccess: false)
        captureSession.stopRunning()
        captureSession = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //  if (captureSession?.isRunning == true) {
        captureSession.stopRunning()
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
        
        // }
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
//        dismiss(animated: true)
        connection.isEnabled =  false
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            if self.isValidBarcode(stringValue) {
                if stringValue.hasPrefix("sku:") {
                    self.showImagePicker()
                }
            }else {
                captureSession.startRunning()
            }
            
        }
        
        
    }
    
    
    
    func showImagePicker() {
        self.imgPickerController = UIImagePickerController()
        self.imgPickerController.sourceType = .camera
        self.imgPickerController.delegate = self
//        self.present(self.imgPickerController, animated: true, completion: nil)
        self.addChildViewController(self.imgPickerController)
        self.view.addSubview(self.imgPickerController.view)
        self.imgPickerController.didMove(toParentViewController: self)
    }
    
    func hideImagePicker() {
        self.imgPickerController.view.removeFromSuperview()
        self.imgPickerController.removeFromParentViewController()
    }

    
    //MARK : Image picker delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.navigationController?.popViewController(animated: true)
//        self.imgPickerController.dismiss(animated: true, completion: nil)
        self.hideImagePicker()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imgData = UIImagePNGRepresentation(img)//UIImageJPEGRepresentation(img, 0.5)//
        self.imgScanned = true
//        self.imgPickerController.dismiss(animated: false, completion: nil)
        
        uploadImage(imgData!, img: img)
        
    }
    
    func uploadImage(_ imgData: Data, img: UIImage) {
        
        LoadingView.shared.showOverlay(nil)
        ServiceManager.sharedManager.uploadImageNew(imgData, folderId: folder.folderId!) { (response) in
            print("resp = \(response)")
            self.hideImagePicker()
            self.delegate?.didAddFile()
            self.navigationController?.popViewController(animated: true)
            LoadingView.shared.hideOverlayView()
        }
    }
    
    func isValidBarcode(_ str: String) -> Bool {
        /*  if str.contains("palletid") {
         return true
         }else {
         return false
         }*/
        
        if str.count != 0
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    

}
