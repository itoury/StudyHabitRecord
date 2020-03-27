//
//  TabBarController.swift
//  StudyHabitRecord
//
//  Created by 伊藤龍哉 on 2020/03/27.
//  Copyright © 2020 ryuuya.itou. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("OK")

        if Auth.auth().currentUser == nil {
            print("no user")
            Auth.auth().signInAnonymously() { (authResult, error) in
              guard let user = authResult?.user else { return }
              let isAnonymous = user.isAnonymous  // true
              let uid = user.uid
            }
        }
        print("Login")
    }
}
