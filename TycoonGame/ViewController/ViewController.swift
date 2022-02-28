//
//  ViewController.swift
//  TycoonGame
//
//  Created by 신동희 on 2022/02/27.
//

import UIKit

class ViewController: UIViewController {
    
    
    // MARK: - UI연결
    
    @IBOutlet weak var startUIView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        startUIView.layer.borderWidth = 3
        startUIView.layer.borderColor = UIColor.systemPink.cgColor
        startUIView.layer.cornerRadius = 30
    }


}

