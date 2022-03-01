//
//  GameResultsViewController.swift
//  TycoonGame
//
//  Created by 신동희 on 2022/03/01.
//

import Foundation
import UIKit

class GameResultViewContoller: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score: Int?
    
    
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "\(score!)점"
    }
}
