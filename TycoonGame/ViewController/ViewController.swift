//
//  ViewController.swift
//  TycoonGame
//
//  Created by 신동희 on 2022/02/27.
//

import UIKit
import AVFoundation

class ViewController: MainViewController {
    
    // MARK: - UI연결
    
    // 노래 on/off 버튼
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var musicControlButton: UIButton!
    @IBAction func didTouchedMusicButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            playerOn()
            musicImage.image = UIImage(systemName: "speaker")
        }else {
            playerOff()
            musicImage.image = UIImage(systemName: "speaker.slash")
        }
    }
    
    
    // 게임시작 버튼
    @IBOutlet weak var startUIView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    // how to 버튼
    @IBOutlet weak var howToUIView: UIView!
    @IBOutlet weak var howToButton: UIButton!
    
    
    // 난이도 조절에 필요한 변수
    var customerAngryTime: Int = 15
    var customerLeaveTime: Int = 20
    var breadBurnTime: Int = 5
    
    // 난이도 조절 segment countrol
    @IBOutlet weak var normalLabel: UILabel!
    @IBOutlet weak var hardLabel: UILabel!
    @IBAction func difficultyControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case  0:
            normalLabel.textColor = UIColor.link
            hardLabel.textColor = UIColor.darkGray
            customerAngryTime = 14
            customerLeaveTime = 20
            breadBurnTime = 5
        default:
            normalLabel.textColor = UIColor.darkGray
            hardLabel.textColor = UIColor.link
            customerAngryTime = 12
            customerLeaveTime = 18
            breadBurnTime = 2
        }
    }
    
    
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 시작버튼, 설명버튼 addTarget
        startButton.addTarget(self, action: #selector(didTouchedStartButton), for: .touchUpInside)
        howToButton.addTarget(self, action: #selector(didTouchedHowToButton), for: .touchUpInside)
        
        // 게임시작 버튼 UI 설정
        viewSetting(startUIView)
        viewSetting(howToUIView)
        
    }
    
    
    // MARK: - View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        // 노래 컨트롤 버튼이 selected상태인 경우에만(소리on 상태에서만) 노래를 다시 재생
        if musicControlButton.isSelected {
            // 오디오 설정
            do {
                try player = AVAudioPlayer(contentsOf: url)
            }catch {
                fatalError()
            }
                    
            playerOn()
        }
    }
    
    
    

    // 시작버튼 눌렸을 때 동작할 함수
    @objc func didTouchedStartButton() {
        guard let gameVC = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {
            return
        }
        // 난이도 조절에 필요한 변수와 노래가 재생중인지 여부를 알려주는 변수를 전달
        gameVC.customerAngryTime = self.customerAngryTime
        gameVC.customerLeaveTime = self.customerLeaveTime
        gameVC.breadBurnTime = self.breadBurnTime
        gameVC.isMusicPlay = self.musicControlButton.isSelected
        
        // 메인화면에서 재생중이던 노래 off
        playerOff()
        
        self.present(gameVC, animated: true, completion: nil)
    }
    
    // how to 버튼이 눌렸을 때 동작할 함수
    @objc func didTouchedHowToButton() {
        guard let howToVC = storyboard?.instantiateViewController(withIdentifier: "HowToViewController") as? HowToViewController else {
            return
        }
        howToVC.modalPresentationStyle = .overCurrentContext
        self.present(howToVC, animated: true, completion: nil)
    }
    
    // 게임시작, howto버튼들 UI 설정 (테두리, radius)
    func viewSetting(_ view: UIView) {
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.systemPink.cgColor
        view.layer.cornerRadius = 30
    }
}
