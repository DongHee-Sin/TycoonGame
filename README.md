# 라이징캠프 4주차 과제
#### 구현한 게임 : 붕어빵 타이쿤 게임
#### 기간: 2022/02/26 ~ 2022/03/05
[실행영상](https://drive.google.com/file/d/1ZVAJojz6EzQz_ZcATr9ypnd0KbYvXJoR/view?usp=sharing)

<br/>

## Thread를 이용한 게임 프로그래밍
### 조건
* Spritekit을 사용 지양, 스레드를 사용하여 구현

<br/>

### 게임설명
* 메인화면에서 START 버튼을 통해 게임을 시작한다.
* 게임이 시작하면 손님이 등장하고, 붕어빵을 n개(랜덤 1~6) 주문한다.
* LIFE는 3개 주어지고, 붕어빵을 제한시간 내에 주지 않으면 손님이 화가나며 일정 시간이 지나면 퇴장하면서 LIFE가 1 줄어든다.
* 반죽 -> 팥 -> 뒤집기 4번을 수행해야 붕어빵을 만들 수 있다.
* 붕어빵을 뒤집으려면 익는시간(2초)을 기다려야 한다.
* 붕어빵을 판매하면 개수에 따라 Score를 얻는다.
* 게임시간이 종료되거나 LIFE가 모두 깎이면 게임이 종료된다.
* 게임이 종료되면 점수를 표시한다.

<br/>

### Thread
* 게임 타이머 (100초) : LIFE가 다 떨어지거나 100초가 지나면 스레드 종료
* 손님 타이머 : 일정 시간동안 붕어빵을 주지 않거나 n초가 지나면 스레드 종료 & 2초 후 다시 등장 -> 게임 종료까지 반복
* 붕어빵 타이머 1~6개 : 각 붕어빵 트레이의 익는시간, 타는시간을 체크

<br/>

### 구현된 화면
* 메인 View
* 게임 View
* HOW TO
* 결과 View
