//
//  DataType.swift
//  TycoonGame
//
//  Created by 신동희 on 2022/02/28.
//

import Foundation


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
