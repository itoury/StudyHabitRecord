//
//  ContentsTableViewCell.swift
//  StudyHabitRecord
//
//  Created by 伊藤龍哉 on 2020/03/25.
//  Copyright © 2020 ryuuya.itou. All rights reserved.
//

import UIKit

class ContentsTableViewCell: UITableViewCell {
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var targetTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(contentsData: ContentsData) {
        categoryLabel.text = contentsData.category!
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        startTimeLabel.text = "\(formatter.string(from: contentsData.startTime!))"
        targetTimeLabel.text = "\(formatter.string(from: contentsData.targetTime!))"
    }
    
}
