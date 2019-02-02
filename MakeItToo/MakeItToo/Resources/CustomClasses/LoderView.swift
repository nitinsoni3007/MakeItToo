//
//  LoderView.swift
//  DialMd
//
//  Created by Rakesh on 12/01/17.
//  Copyright © 2017 lms. All rights reserved.
// hello, hi

import Foundation
import UIKit

open class LoadingView{
    var backGroundView : UIView!
    var overlayView : UIView!
    var activityIndicator : UIActivityIndicatorView!
    
    class var shared: LoadingView {
        struct Static {
            static let instance: LoadingView = LoadingView.init()
        }
        return Static.instance
    }
    
    init(){
        self.backGroundView = UIView()
        self.backGroundView.frame = UIApplication.shared.keyWindow!.bounds
        self.backGroundView.backgroundColor = UIColor.clear
        let tranlucentView = UIView(frame: UIApplication.shared.keyWindow!.bounds)
        tranlucentView.backgroundColor = UIColor.black
        tranlucentView.alpha = 0.5
        self.backGroundView.addSubview(tranlucentView)
        self.overlayView = UIView()
        self.activityIndicator = UIActivityIndicatorView()
       
    
        overlayView.frame = CGRect(x:0, y:0, width:150, height:150)
        overlayView.backgroundColor = UIColor.clear//UIColor(white: 1, alpha: 1.0)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
       // overlayView.layer.borderWidth =  2.0
        overlayView.layer.zPosition = 1
        
        activityIndicator.frame = CGRect(x:0, y:0, width:40, height:40)
        activityIndicator.center = CGPoint(x:overlayView.bounds.width / 2,y: overlayView.bounds.height / 2)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.white
        overlayView.addSubview(activityIndicator)
        backGroundView.addSubview(overlayView)
    }
    
    open func showOverlay(_ view: UIView?) {
       DispatchQueue.main.async {
        let window = UIApplication.shared.keyWindow!

        self.overlayView.center = (window.center)
       // view.addSubview(overlayView)
        window.addSubview(self.backGroundView);
        self.activityIndicator.startAnimating()
        }
    }
    
    open func hideOverlayView() {
        DispatchQueue.main.async {
        self.activityIndicator.stopAnimating()
        self.backGroundView.removeFromSuperview()
    }
    }
}
