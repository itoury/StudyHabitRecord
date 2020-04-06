//
//  StudyRecordData.swift
//  StudyHabitRecord
//
//  Created by 伊藤龍哉 on 2020/03/29.
//  Copyright © 2020 ryuuya.itou. All rights reserved.
//

import UIKit
import Firebase

class StudyRecordData: NSObject {
    var id: String
    var category: String?
    var targetTime: Date?
    var actualTime: Date?

    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let contentsDic = document.data()

        self.category = contentsDic["category"] as? String
        let targetTimestamp = contentsDic["targetTime"] as? Timestamp
        
        self.targetTime = targetTimestamp?.dateValue()
        
    }
}
