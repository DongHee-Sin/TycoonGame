//
//  GameViewController.swift
//  TycoonGame
//
//  Created by 신동희 on 2022/02/28.
//

import UIKit
import AVFoundation

class GameViewController: MainViewController {
    
    // 오디오가 재생중인지 확인
    var isMusicPlay: Bool?
        
    
    // 난이도별 시간
    var customerAngryTime: Int?
    var customerLeaveTime: Int?
    var breadBurnTime: Int?
    
    
    // MARK: - 전역변수
    
    // 남은 목숨 : 프로퍼티 감시자로 목숨이 떨어지면 UI에 반영
    var heartPoint: Int = 3 {
        willSet {
            DispatchQueue.main.async { [self] in
                if newValue == 2 {
                    heart3.image = UIImage(systemName: "heart")
                }
                if newValue == 1 {
                    heart2.image = UIImage(systemName: "heart")
                }
                if newValue == 0 {
                    heart1.image = UIImage(systemName: "heart")
                }
            }
        }
    }
    
    // 점수
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
    var selectedIngredients: Ingredients?
    
    
    // global Queue
    let globalQueue = DispatchQueue.global()
    
    
    
    // MARK: - UI 연결
    
    // 목숨(하트) 이미지
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    
    
    
    // 전체시간 타이머 : progress view
    @IBOutlet weak var gameTimerProgressView: UIProgressView!
    
    
    // 게임 START 이미지 (첫 시작할 때 보여지는 이미지)
    @IBOutlet weak var gameStartImage: UIImageView!
    
    
    // 손님 View
    @IBOutlet weak var customerUIView: UIView!
    @IBOutlet weak var customerOrder: UILabel!
    @IBOutlet weak var angryImage: UIImageView!
    @IBOutlet weak var customerImage: UIImageView!
    
    
    
    // 붕어빵 틀 버튼
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    
    // 붕어빵 틀 이미지
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    
    
    // 재료 버튼
    @IBOutlet weak var doughButton: UIButton!
    @IBOutlet weak var redBeansButton: UIButton!
    @IBOutlet weak var handButton: UIButton!
    
    // 재료 이미지
    @IBOutlet weak var doughImage: UIImageView!
    @IBOutlet weak var redBeanImage: UIImageView!
    @IBOutlet weak var handImage: UIImageView!
    
    
    
    // 완성된 붕어빵 개수
    @IBOutlet weak var finishedBreadLabel: UILabel!
    
    
    // 점수 Label
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    // 붕어빵 지급 버튼
    @IBOutlet weak var forRadiusView: UIView!
    @IBAction func giveBreadButton(_ sender: UIButton) {
        if finishedBreadCount >= orderCount! {
            // 보유 붕어빵과 스코어 계산
            finishedBreadCount -= orderCount!
            score += 100 * orderCount!
            updateNumberOfBread()
            updateScore()
            
            // 손님 사라짐 (Hidden true)
            customerViewHidden(true)
            
            // 손님 타이머와 루프 해제
            customerTimer.invalidate()
            customerLoopSwitch = false
            
            // 화난 표시 히든 (빠직 이미지)
            DispatchQueue.main.async {
                self.angryImage.isHidden = true
            }
        }else {
            // 붕어빵이 부족한데 지급버튼 누르면 -100점
            score -= 100
            updateScore()
        }
    }

    
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // burnTimer들 배열로 저장
        burnTimers = [burnTimer1, burnTimer2, burnTimer3, burnTimer4, burnTimer5, burnTimer6]
        
        
        // 전체 게임 타이머 progress view 설정
        gameTimerProgressView.transform = gameTimerProgressView.transform.scaledBy(x: 1, y: 1.5)
        gameTimerProgressView.setProgress(1.0, animated: false)
        
        
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
        
        
        // 재료 이미지에 border color 설정
        doughImage.layer.borderColor = UIColor.systemBlue.cgColor
        redBeanImage.layer.borderColor = UIColor.systemBlue.cgColor
        handImage.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    

    
    // MARK: - View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        // 음악on 상태에서만 오디오 설정
        if isMusicPlay! {
            // 오디오 설정
            do {
                try player = AVAudioPlayer(contentsOf: url2)
            }catch {
                fatalError()
            }
            playerOn()
        }else {
            playerOff()
        }
        
        // 1초 뒤 게임시작
        sleep(1)
        customerViewHidden(false)
        gameStartImage.isHidden = true
        mainLoop()
    }
    
    
    
    
    
    // MARK: - View Did Disappear
    // 게임이 종료되면 게임화면 음악을 off함
    override func viewWillDisappear(_ animated: Bool) {
        playerOff()
    }
    
    
    
    
    
    // MARK: - 함수
    
    // 게임 종료하는 함수
    func gameOver() {
        // 메인 타이머 해제
        mainTimer.invalidate()
        mainTimerSwitch = false
        
        // 고객 타이머 해제
        customerTimer.invalidate()
        customerLoopSwitch = false
        
        print("게임 종료 🤪")
        
        // gameOver함수가 글로벌 큐 쓰레드에서 호출되기 때문에 뷰 전환 내용은 메인큐로 보내서 실행해줌
        DispatchQueue.main.async {
            guard let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "GameResultViewContoller") as? GameResultViewContoller else {
                return
            }
            resultVC.score = self.score
            resultVC.modalPresentationStyle = .overCurrentContext
            self.present(resultVC, animated: true, completion: nil)
        }
    }
    
    
    
    //메인 루프
    func mainLoop() {
        globalQueue.async { [self] in
            mainTimerSwitch = true
            let runLoop = RunLoop.current
            mainTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(mainTimerCounter), userInfo: nil,repeats: true)
            
            
            while mainTimerSwitch {
                runLoop.run(until: Date().addingTimeInterval(0.1))
            }
        }
    }
    
    // 메인(게임) 타이머
    var mainTimer: Timer = Timer()
    var mainCount: Int = 0
    var mainTimerSwitch: Bool = false
    
    @objc func mainTimerCounter() {
        mainCount = mainCount + 1
                
        if(mainCount<=100){
            DispatchQueue.main.async { [self] in
                gameTimerProgressView.setProgress(gameTimerProgressView.progress - 0.01, animated: true)
            }
        } else {
            gameOver()
        }
    }
    
    
    
    // 손님 루프
    var customerTimer: Timer = Timer()
    var customerCount: Int = 0
    var customerLoopSwitch: Bool = false
    
    func customerLoop() {
        globalQueue.async { [self] in
            customerLoopSwitch = heartPoint >= 1 ? true : false
            let runLoop = RunLoop.current
            customerTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(customerTimerCounter), userInfo: nil, repeats: true)
            
            while customerLoopSwitch {
                runLoop.run(until: Date().addingTimeInterval(0.1))
            }
        }
    }
    
    // 손님 루프 함수
    @objc func customerTimerCounter() {
        // 여기서는 타이머를 체크하고 시간이 지나면 손님 루프를 종료함
        customerCount += 1
//        print("고객 타이머 : \(customerCount)")
        if customerCount == customerAngryTime {
            DispatchQueue.main.async {
                self.angryImage.isHidden = false
                self.customerImage.image = UIImage(named: "화난남자.png")
            }
        }
        if customerCount == customerLeaveTime {
            DispatchQueue.main.async {
                self.angryImage.isHidden = true
                self.customerViewHidden(true)
            }
            customerTimer.invalidate()
            customerLoopSwitch = false
            
            // 목숨 1 깎기
            heartPoint -= 1
            if heartPoint == 0 {
                gameOver()
            }
        }
    }
    
    
    
    // 손님 이미지를 히든처리 / false = 주문수량도 설정
    func customerViewHidden(_ to: Bool) {
        customerUIView.isHidden = to
        // 손님이 등장할 때
        if to == false {
            self.customerImage.image = UIImage(named: "남자.png")
            customerCount = 0
            orderCount = getRandomNumber()
            customerOrder.text = "붕어빵 \(orderCount!)개 주세요."
            customerLoop()
        }
        // 손님이 사라질 때
        if to == true {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                // 사라지고 2초 뒤 다시 등장
                self.customerViewHidden(false)
            })
        }
    }
    
    // 랜덤 숫자 반환 (1~6)
    func getRandomNumber() -> Int {
        return Int.random(in: 1...6)
    }
    
    
    // 붕어빵 태우는지 여부 확인하는 타이머
    var burnTimer1 = Timer()
    var burnTimer2 = Timer()
    var burnTimer3 = Timer()
    var burnTimer4 = Timer()
    var burnTimer5 = Timer()
    var burnTimer6 = Timer()
    var burnTimers: [Timer] = []
    var burnTimersCount: [Int] = [0, 0, 0, 0, 0, 0]
    var burnLoopSwitch: [Bool] = [false, false, false, false, false, false]
    
    // 붕어빵이 다 익으면 작동할 타이머
    // 1번째 붕어빵 트레이면 매개변수로 0을 받도록 할것
    func burnLoop(_ index: Int) {
        burnTimersCount[index] = 0
        
        globalQueue.async { [self] in
            burnLoopSwitch[index] = true
            let runLoop = RunLoop.current
            
            burnTimers[index] = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(burnTimerCounter(_:)), userInfo: ["index": index], repeats: true)
            
            while burnLoopSwitch[index] {
                runLoop.run(until: Date().addingTimeInterval(0.1))
            }
        }
    }
    
    // 타는지 여부 확인할 타이머 카운터
    @objc func burnTimerCounter(_ timer: Timer) {
        guard let receivedData = timer.userInfo as? Dictionary<String, Int> else {
            return
        }
        let index: Int = receivedData["index"]!
        
        burnTimersCount[index] += 1
        if burnTimersCount[index] == breadBurnTime {
            burnLoopSwitch[index] = false
            burnTimers[index].invalidate()
            currentTrayState[String(index+1)] = .탐
            print("\(index+1)번 붕어빵 탔어요.")
        }
    }
    
    // 시간 맞춰서 뒤집으면 burn timer 멈추는 함수
    func stopBurnTimer(_ index: Int) {
        burnLoopSwitch[index] = false
        burnTimers[index].invalidate()
    }
    
    
    
    // 붕어빵 틀 눌리면 동작할 함수
    @objc func didTouchedTrayButton(_ sender: UIButton) {
        // 눌린 버튼(sender)의 titleLabel을 가져와서 눌린 붕어빵 틀 정보 저장
        let buttonKey: String = (sender.titleLabel?.text)!
        let trayIndex: Int = Int(buttonKey)! - 1
        
        // 현재 붕어빵 틀의 상태를 가져옴
        let trayState: TrayState = currentTrayState[buttonKey]!
        
        // 현재 붕어빵 틀 상태로 조건문 돌리기
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
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                        // 뒤집고 2초 후 붕어빵 틀 상태 변경
                        self.currentTrayState[buttonKey] = .뒤집기2가능
                        // 다 익으면 동시에 burn timer 시작
                        self.burnLoop(trayIndex)
                    })
                    runLoop.run(until: Date().addingTimeInterval(8))
                }
                
            }
        case .뒤집기2가능:
            if selectedIngredients == .손 {
                // 전단계에서 진행되던 burn timer 멈춤
                stopBurnTimer(trayIndex)
                
                currentTrayState[buttonKey] = .뒤집기2
                updateTrayImgae(state: .뒤집기2, trayNumber: buttonKey)
                globalQueue.async {
                    let runLoop = RunLoop.current
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                        self.currentTrayState[buttonKey] = .뒤집기3가능
                        self.burnLoop(trayIndex)
                    })
                    runLoop.run(until: Date().addingTimeInterval(8))
                }
            }
        case .뒤집기3가능:
            if selectedIngredients == .손 {
                stopBurnTimer(trayIndex)
                currentTrayState[buttonKey] = .뒤집기3
                updateTrayImgae(state: .뒤집기3, trayNumber: buttonKey)
                globalQueue.async {
                    let runLoop = RunLoop.current
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                        self.currentTrayState[buttonKey] = .뒤집기4가능
                        self.burnLoop(trayIndex)
                    })
                    runLoop.run(until: Date().addingTimeInterval(8))
                }
            }
        case .뒤집기4가능:
            if selectedIngredients == .손 {
                stopBurnTimer(trayIndex)
                currentTrayState[buttonKey] = .뒤집기4
                updateTrayImgae(state: .뒤집기4, trayNumber: buttonKey)
                burnLoop(trayIndex)
            }
        case .뒤집기4:
            if selectedIngredients == .손 {
                stopBurnTimer(trayIndex)
                currentTrayState[buttonKey] = .비어있음
                updateTrayImgae(state: .비어있음, trayNumber: buttonKey)
                finishedBreadCount += 1
                updateNumberOfBread()
            }
        case .탐:
            if selectedIngredients == .손 {
                currentTrayState[buttonKey] = .탄거확인
                updateTrayImgae(state: .탄거확인, trayNumber: buttonKey)
            }
        case .탄거확인:
            if selectedIngredients == .손 {
                currentTrayState[buttonKey] = .비어있음
                updateTrayImgae(state: .비어있음, trayNumber: buttonKey)
            }
        default:
            return
        }
    }
    
    
    
    // 붕어빵 틀 이미지 업데이트하는 함수
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
        imageBorderCancel()
        switch sender {
        case doughButton:
            selectedIngredients = .반죽
            addBorderToImage(doughImage)
        case redBeansButton:
            selectedIngredients = .팥
            addBorderToImage(redBeanImage)
        default:
            selectedIngredients = .손
            addBorderToImage(handImage)
        }
    }
    // borderWidth 초기화
    func imageBorderCancel() {
        doughImage.layer.borderWidth = 0
        redBeanImage.layer.borderWidth = 0
        handImage.layer.borderWidth = 0
    }
    // 이미지뷰에 borderWidth 2 설정하는 함수
    func addBorderToImage(_ to: UIImageView) {
        to.layer.borderWidth = 2
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
