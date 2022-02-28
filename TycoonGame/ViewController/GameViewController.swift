//
//  GameViewController.swift
//  TycoonGame
//
//  Created by 신동희 on 2022/02/28.
//

import Foundation
import UIKit


class GameViewController: UIViewController {
    
    // MARK: - 열거형
    // 재료 종류 열거형
    enum Ingredients {
        case 반죽
        case 팥
        case 손
    }
    
    // 빵틀 상태 열거형
    enum TrayState {
        case 비어있음
        case 반죽
        case 팥
        case 뒤집기1
        case 뒤집기2
        case 뒤집기3
        case 뒤집기4
        case 뒤집기가능
        case 탐
    }
    
    
    
    
    // MARK: - 전역변수
    // 남은 목숨과 스코어
    var heartPoint: Int = 3
    var score: Int = 0
    
    // 고객이 주문한 붕어빵 수량
    var orderCount: Int?
    
    // 빵틀 상태
    var currentTrayState: [TrayState] = [.비어있음, .비어있음, .비어있음, .비어있음, .비어있음, .비어있음]
    
    
    
    
    
    // MARK: - UI 연결
    
    // 손님 View
    @IBOutlet weak var customerUIView: UIView!
    @IBOutlet weak var customerOrder: UILabel!
    
    
    
    
    
    
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 처음 시작할 때 손님 View 히든처리
        customerViewHidden(true)
    }
    
    

    
    // MARK: - View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        // 1초 뒤 게임시작
        sleep(1)
        customerViewHidden(false)
    }
    
    
    
    
    
    
    // MARK: - 함수 정의
    
    // 손님 이미지를 히든처리 / false = 주문수량도 설정
    func customerViewHidden(_ to: Bool) {
        customerUIView.isHidden = to
        if to == false {
            orderCount = getRandomNumber()
            customerOrder.text = "붕어빵 \(orderCount!)개 주세요."
        }
    }
    
    // 랜덤 숫자 반환 (1~6)
    func getRandomNumber() -> Int {
        return Int.random(in: 1...6)
    }
}
