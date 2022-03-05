//
//  MainViewController.swift
//  TycoonGame
//
//  Created by 신동희 on 2022/03/04.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - 노래 재생 코드
    
    // 플레이어 등록
    var player = AVAudioPlayer()
    
    // 음원 파일 url 가져오기
    let url = Bundle.main.url(forResource: "메인화면", withExtension: "mp3")!
    let url2 = Bundle.main.url(forResource: "게임화면", withExtension: "mp3")!
    
    
    // 음악 반복재생 on
    func playerOn() {
        player.numberOfLoops = -1
        player.prepareToPlay()
        player.play()
    }
    
    // 음악 off
    func playerOff() {
        player.pause()
    }
}
