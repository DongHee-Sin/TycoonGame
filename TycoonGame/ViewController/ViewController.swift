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
        
        // 게임시작 버튼 addTarget
        startButton.addTarget(self, action: #selector(didTouchedStartButton), for: .touchUpInside)
        
        // 게임시작 버튼 UI 설정
        startUIView.layer.borderWidth = 3
        startUIView.layer.borderColor = UIColor.systemPink.cgColor
        startUIView.layer.cornerRadius = 30
    }


    @objc func didTouchedStartButton() {
        guard let gameVC = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {
            return
        }
        self.present(gameVC, animated: true, completion: nil)
    }
}

