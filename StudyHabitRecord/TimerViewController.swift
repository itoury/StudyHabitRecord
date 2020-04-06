//
//  TimerViewController.swift
//  StudyHabitRecord
//
//  Created by 伊藤龍哉 on 2020/03/29.
//  Copyright © 2020 ryuuya.itou. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import SwiftDate

class TimerViewController: UIViewController {
    
    var contentsData: ContentsData?
    var timer: Timer!
    var isStarted: Bool!
    var startDate: Date!
    var pauseDate: Date!
    var pauseTime = 0.0
    var count: Double!
    
    let componentFormatter = DateComponentsFormatter()
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var targetTimeLabel: UILabel!
    @IBOutlet weak var actualTimeLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var timerStartPauseButton: UIButton!
    @IBOutlet weak var timerStopButton: UIButton!
    
    @IBOutlet weak var cp: MBCircularProgressBarView! {
        didSet {
            cp.progressAngle = 100
            let hour = contentsData?.targetTime!.hour
            let min = contentsData?.targetTime!.minute
            cp.maxValue = CGFloat(hour!*3600 + min!*60)
            cp.progressRotationAngle = 50
            cp.progressLineWidth = 20
            cp.emptyLineWidth = 20
            cp.progressColor =  #colorLiteral(red: 0.0964154017, green: 0.7139379537, blue: 1, alpha: 1)
            cp.emptyLineColor = #colorLiteral(red: 0.891437772, green: 0.891437772, blue: 0.891437772, alpha: 1)
            cp.showValueString = false
            cp.progressStrokeColor = .clear
            cp.emptyLineStrokeColor = .clear
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentFormatter.unitsStyle = .positional
        componentFormatter.allowedUnits = [.hour, .minute, .second]
        componentFormatter.zeroFormattingBehavior = .pad
        dateFormatter.dateFormat = "HH:mm:00"
        
        targetTimeLabel.text = "\(dateFormatter.string(from: (contentsData?.targetTime)!))"
        self.count = Double(cp.maxValue)
        self.pauseTime = 0
        self.isStarted = false
    }
    
    @IBAction func handleTimerStartPauseButton(_ sender: Any) {
        if isStarted {
            self.isStarted = false
            self.pauseDate = Date()
            self.timer.invalidate()
        } else {
            self.isStarted = true
            if startDate == nil {
                self.startDate = Date()
            }
            if pauseDate != nil {
                pauseTime += Date().timeIntervalSince(pauseDate)
            }
            self.timer = Timer.scheduledTimer(timeInterval:1, target: self, selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func handleStopButton(_ sender: Any) {
        if isStarted {
            self.isStarted = false
            self.timer.invalidate()
        }
        self.handleFinishAlert()
    }
        
    
    @objc func updateTimer(_ timer: Timer) {
        let actualTime = Date().timeIntervalSince(startDate) - pauseTime
        actualTimeLabel.text = componentFormatter.string(from: actualTime)
        
        let percent = CGFloat(100 * actualTime/count)
        if percent < 100 {
            cp.value = CGFloat(actualTime)
        }
        
        /*
        if 0 ..< 50.0 ~= percent {
            label.text = "まだまだ！"
        } else if 50.0 ..< 100 ~= percent {
            label.text = "もういっちょ！"
        } else {
            label.text = "目標達成！"
        }
         */
        
        progressLabel.text = "\(String(format: "%.0f", percent))%"
    }
    
    func handleFinishAlert() {
        let finishAlert = UIAlertController(
            title: "",
            message: "学習を終了しますか？",
            preferredStyle: UIAlertController.Style.alert)
        
        finishAlert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        finishAlert.addAction(
            UIAlertAction(
                title: "終了する",
                style: UIAlertAction.Style.default) { _ in
                    let studyRecordViewController = self.storyboard?.instantiateViewController(withIdentifier: "StudyRecord") as! StudyRecordViewController
                    self.present(studyRecordViewController, animated: true, completion: nil)
            }
        )
        self.present(finishAlert, animated: true, completion: nil)
    }
}
