//
//  ViewController.swift
//  OscarNewFaceView
//
//  Created by Abiodun Shuaib on 05/06/2016.
//  Copyright © 2016 Abiodun Shuaib. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FaceViewDataSource {

    @IBOutlet weak var oscarFace: OscarFace! {
        didSet {
            oscarFace.dataSource = self
        }
    }
    var happiness: Int = 0 {
        didSet {
            happiness = min(max(happiness, 0), 100)
            oscarFace.setNeedsDisplay()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func smileness(smile: OscarFace) -> Double {
        return Double(happiness-50)/50
    }


    @IBAction func UIGestureRecognizer(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began: fallthrough
        case .Changed:
            let translation = sender.translationInView(oscarFace)
            let authenticityOfSmile = Int(translation.y/5)
            if authenticityOfSmile != 0 {
                happiness += authenticityOfSmile
                sender.setTranslation(CGPointZero, inView: oscarFace)
            }
            
        default: break
            
        }
    }
}

