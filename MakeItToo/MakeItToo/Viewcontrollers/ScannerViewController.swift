//
//  ScannerViewController.swift
//  MakeItToo
//
//  Created by Nitin on 27/01/19.
//  Copyright © 2019 Nitin. All rights reserved.
//

import UIKit

protocol ScannerViewDelegate {
    func didAddFile()
}

class ScannerViewController: UIViewController {

    var delegate: ScannerViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    

}
