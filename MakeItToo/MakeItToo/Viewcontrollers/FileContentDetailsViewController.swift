//
//  FileContentDetailsViewController.swift
//  MakeItToo
//
//  Created by Nitin on 01/02/19.
//  Copyright © 2019 Nitin. All rights reserved.
//

import UIKit

class FileContentDetailsViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblSKU: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    var sku = ""
    var fileImg : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        lblSKU.text = (UIApplication.shared.delegate as! AppDelegate).currSKU
//        imgView.image = (UIApplication.shared.delegate as! AppDelegate).currImage
//        lblDateTime.text = (UIApplication.shared.delegate as! AppDelegate).currTime
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
