//
//  HomeViewController.swift
//  StudyHabitRecord
//
//  Created by 伊藤龍哉 on 2020/03/25.
//  Copyright © 2020 ryuuya.itou. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var contentsArray: [ContentsData] = []
    var listener: ListenerRegistration!
    
    @IBOutlet weak var contentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentsTableView.delegate = self
        contentsTableView.dataSource = self
        let nib = UINib(nibName: "ContentsTableViewCell", bundle: nil)
        contentsTableView.register(nib, forCellReuseIdentifier: "ContentsCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            if listener == nil {
                let contentsRef = Firestore.firestore().collection(Const.ContentPath).order(by: "startTime", descending: false)
                listener = contentsRef.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    self.contentsArray = querySnapshot!.documents.map { document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let contentData = ContentsData(document: document)
                        return contentData
                    }
                    self.contentsTableView.reloadData()
                }
                
            }
            
        } else {
            if listener != nil {
                listener.remove()
                listener = nil
                contentsArray = []
                contentsTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentsTableView.dequeueReusableCell(withIdentifier: "ContentsCell", for: indexPath) as! ContentsTableViewCell
        cell.setData(contentsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timerViewController = self.storyboard?.instantiateViewController(withIdentifier: "Timer") as! TimerViewController
        timerViewController.contentsData = contentsArray[indexPath.row]
        self.present(timerViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
