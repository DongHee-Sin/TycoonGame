//
//  GameViewController.swift
//  TycoonGame
//
//  Created by 신동희 on 2022/02/28.
//

import Foundation
import UIKit


class GameViewController: UIViewController {
    
    // MARK: - 전역변수
    // 남은 목숨과 스코어
    var heartPoint: Int = 3
    var score: Int = 0
    
    // 고객이 주문한 붕어빵 수량
    var orderCount: Int?
    
    
    // 완성된 붕어빵 수량
    var finishedBreadCount: Int = 0
    
    
    // 빵틀 상태
    var currentTrayState: [String: TrayState] = [
        "1": .비어있음,
        "2": .비어있음,
        "3": .비어있음,
        "4": .비어있음,
        "5": .비어있음,
        "6": .비어있음
    ]
    
    // 선택된 재료
    var selectedIngredients: Ingredients? {
        willSet {
            if let selected = newValue {
                print("현재 선택된 재료는 \(selected)입니다.")
            }
        }
    }
    
    
    // Dispatch Queue
    let globalQueue = DispatchQueue.global()
    
    
    
    // MARK: - UI 연결
    // 손님 View
    @IBOutlet weak var customerUIView: UIView!
    @IBOutlet weak var customerOrder: UILabel!
    
    
    // 붕어빵 틀 버튼
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    
    
    // 재료 버튼
    @IBOutlet weak var doughButton: UIButton!
    @IBOutlet weak var redBeansButton: UIButton!
    @IBOutlet weak var handButton: UIButton!
    
    
    
    // 붕어빵 틀 이미지
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    
    
    // 완성된 붕어빵 개수
    @IBOutlet weak var finishedBreadLabel: UILabel!
    
    
    // 점수 Label
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    // 붕어빵 지급 버튼
    @IBOutlet weak var forRadiusView: UIView!
    @IBAction func giveBreadButton(_ sender: UIButton) {
        if finishedBreadCount >= orderCount! {
            finishedBreadCount -= orderCount!
            score = 100 * orderCount!
            updateNumberOfBread()
            updateScore()
        }
    }
    
    
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 처음 시작할 때 손님 View 히든처리
        customerViewHidden(true)
        
        
        // 붕어빵 버튼들에 함수 연결
        button1.addTarget(self, action: #selector(didTouchedTrayButton(_:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(didTouchedTrayButton(_:)), for: .touchUpInside)
        button3.addTarget(self, action: #selector(didTouchedTrayButton(_:)), for: .touchUpInside)
        button4.addTarget(self, action: #selector(didTouchedTrayButton(_:)), for: .touchUpInside)
        button5.addTarget(self, action: #selector(didTouchedTrayButton(_:)), for: .touchUpInside)
        button6.addTarget(self, action: #selector(didTouchedTrayButton(_:)), for: .touchUpInside)
        
        
        // 재료 선택 버튼들 함수 연결
        doughButton.addTarget(self, action: #selector(didTouchedIngredientsButton(_:)), for: .touchUpInside)
        redBeansButton.addTarget(self, action: #selector(didTouchedIngredientsButton(_:)), for: .touchUpInside)
        handButton.addTarget(self, action: #selector(didTouchedIngredientsButton(_:)), for: .touchUpInside)
        
        
        // Radius처리
        forRadiusView.layer.cornerRadius = 10
        forRadiusView.layer.borderColor = UIColor.systemPink.cgColor
        forRadiusView.layer.borderWidth = 1
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
    
    
    // 붕어빵 틀 눌리는 버튼
    @objc func didTouchedTrayButton(_ sender: UIButton) {
        let buttonKey: String = (sender.titleLabel?.text)!
        // 현재 붕어빵 틀의 상태를 가져옴
        let trayState: TrayState = currentTrayState[buttonKey]!
        
        switch trayState {
        case .비어있음:
            if selectedIngredients == .반죽 {
                currentTrayState[buttonKey] = .반죽
                updateTrayImgae(state: .반죽, trayNumber: buttonKey)
            }
        case .반죽:
            if selectedIngredients == .팥 {
                currentTrayState[buttonKey] = .팥
                updateTrayImgae(state: .팥, trayNumber: buttonKey)
            }
        case .팥:
            if selectedIngredients == .손 {
                currentTrayState[buttonKey] = .뒤집기1
                updateTrayImgae(state: .뒤집기1, trayNumber: buttonKey)
                globalQueue.async {
                    let runLoop = RunLoop.current
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
                        print("준비완료")
                        self.currentTrayState[buttonKey] = .뒤집기2가능
                    })
                    runLoop.run(until: Date().addingTimeInterval(10))
                }
                
            }
        case .뒤집기2가능:
            if selectedIngredients == .손 {
                currentTrayState[buttonKey] = .뒤집기2
                updateTrayImgae(state: .뒤집기2, trayNumber: buttonKey)
                globalQueue.async {
                    let runLoop = RunLoop.current
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
                        print("준비완료")
                        self.currentTrayState[buttonKey] = .뒤집기3가능
                    })
                    runLoop.run(until: Date().addingTimeInterval(10))
                }
            }
        case .뒤집기3가능:
            if selectedIngredients == .손 {
                currentTrayState[buttonKey] = .뒤집기3
                updateTrayImgae(state: .뒤집기3, trayNumber: buttonKey)
                globalQueue.async {
                    let runLoop = RunLoop.current
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
                        print("준비완료")
                        self.currentTrayState[buttonKey] = .뒤집기4가능
                    })
                    runLoop.run(until: Date().addingTimeInterval(10))
                }
            }
        case .뒤집기4가능:
            if selectedIngredients == .손 {
                currentTrayState[buttonKey] = .뒤집기4
                updateTrayImgae(state: .뒤집기4, trayNumber: buttonKey)
            }
        case .뒤집기4:
            if selectedIngredients == .손 {
                currentTrayState[buttonKey] = .비어있음
                updateTrayImgae(state: .비어있음, trayNumber: buttonKey)
                finishedBreadCount += 1
                updateNumberOfBread()
            }
        case .탐:
            if selectedIngredients == .손 {
                currentTrayState[buttonKey] = .비어있음
                updateTrayImgae(state: .비어있음, trayNumber: buttonKey)
            }
        default:
            return
        }
    }
    
    
    // 붕어빵 틀 이미지 변경하는 함수
    func updateTrayImgae(state: TrayState, trayNumber: String) {
        switch trayNumber {
        case "1":
            image1.image = UIImage(named: state.rawValue)
        case "2":
            image2.image = UIImage(named: state.rawValue)
        case "3":
            image3.image = UIImage(named: state.rawValue)
        case "4":
            image4.image = UIImage(named: state.rawValue)
        case "5":
            image5.image = UIImage(named: state.rawValue)
        case "6":
            image6.image = UIImage(named: state.rawValue)
        default:
            return
        }
    }
    
    
    
    
    // 재료 선택 버튼
    @objc func didTouchedIngredientsButton(_ sender: UIButton) {
        switch sender {
        case doughButton:
            selectedIngredients = .반죽
        case redBeansButton:
            selectedIngredients = .팥
        default:
            selectedIngredients = .손
        }
    }
    
    
    
    // 완성된 붕어빵 개수 Label 업데이트 함수
    func updateNumberOfBread() {
        finishedBreadLabel.text = "X \(finishedBreadCount)"
    }
    
    
    // 점수 업데이트 함수
    func updateScore() {
        scoreLabel.text = String(score)
    }
}
