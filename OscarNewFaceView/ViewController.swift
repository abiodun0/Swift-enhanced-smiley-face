//
//  ViewController.swift
//  OscarNewFaceView
//
//  Created by Abiodun Shuaib on 05/06/2016.
//  Copyright © 2016 Abiodun Shuaib. All rights reserved.
//

import UIKit


class ViewController: UIViewController, FaceViewDataSource {
    
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Relaxed) {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var oscarFace: OscarFace! {
        didSet {
            oscarFace.dataSource = self
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.updateEyes(_:)))
            tapGestureRecognizer.numberOfTapsRequired = 2
            oscarFace.addGestureRecognizer(tapGestureRecognizer)
            
            let increaseswipeGetsture = UISwipeGestureRecognizer(target: self, action: #selector(self.increaseTilt))
            increaseswipeGetsture.direction = .Left
            oscarFace.addGestureRecognizer(increaseswipeGetsture)

            let dereaseswipeGetsture = UISwipeGestureRecognizer(target: self, action: #selector(self.decreaseTilt))
            dereaseswipeGetsture.direction = .Right
            oscarFace.addGestureRecognizer(dereaseswipeGetsture)
            
        }
    }
    
    private var eyeBrowTitle = [FacialExpression.Eyebrows.Furrowed: -0.5, .Relaxed: 0.5, .Normal: 0.0]
    
    func decreaseTilt(){
        print("got to tilt")
        expression.eyeBrows.moreRelaxed()
    }
    
    func increaseTilt(){
        expression.eyeBrows.moreFurrowed()
    }
     func updateEyes(recognizer: UITapGestureRecognizer) {
        print("got here")
        switch recognizer.state {
        case .Ended:
            print("got here too")
            if expression.eyes == .Open {
                expression.eyes = .Closed
            }
            else {
                expression.eyes = .Open
            }
            
        default: break
            
        }
    }
    private func updateUI(){
        switch expression.eyes {
        case .Open :
            oscarFace.eyesOpen = true
        case .Closed:
            oscarFace.eyesOpen = false
        case .Squint:
            break
        }
        oscarFace.eyeBrowTilt = eyeBrowTitle[expression.eyeBrows] ?? 0.0
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


