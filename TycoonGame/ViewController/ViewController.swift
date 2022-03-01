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
    
    @IBOutlet weak var howToUIView: UIView!
    @IBOutlet weak var howToButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 게임시작 버튼 addTarget
        startButton.addTarget(self, action: #selector(didTouchedStartButton), for: .touchUpInside)
        howToButton.addTarget(self, action: #selector(didTouchedHowToButton), for: .touchUpInside)
        
        // 게임시작 버튼 UI 설정
        viewSetting(startUIView)
        viewSetting(howToUIView)
    }


    @objc func didTouchedStartButton() {
        guard let gameVC = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {
            return
        }
        self.present(gameVC, animated: true, completion: nil)
    }
    
    @objc func didTouchedHowToButton() {
        guard let howToVC = storyboard?.instantiateViewController(withIdentifier: "HowToViewController") as? HowToViewController else {
            return
        }
        howToVC.modalPresentationStyle = .overCurrentContext
        self.present(howToVC, animated: true, completion: nil)
    }
    
    
    func viewSetting(_ view: UIView) {
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.systemPink.cgColor
        view.layer.cornerRadius = 30
    }
}

