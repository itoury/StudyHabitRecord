//
//  ContentsData.swift
//  StudyHabitRecord
//
//  Created by 伊藤龍哉 on 2020/03/28.
//  Copyright © 2020 ryuuya.itou. All rights reserved.
//

import UIKit
import Firebase

class ContentsData: NSObject {
    var id: String
    var category: String?
    var startTime: Date?
    var targetTime: Date?

    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let contentsDic = document.data()

        self.category = contentsDic["category"] as? String
        let targetTimestamp = contentsDic["targetTime"] as? Timestamp
        let startTimestamp = contentsDic["startTime"] as? Timestamp
        
        self.targetTime = targetTimestamp?.dateValue()
        self.startTime = startTimestamp?.dateValue()
        
        print(category!)
        print(targetTime!)
        print(startTime!)
    }
}
