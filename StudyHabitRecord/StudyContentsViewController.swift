//
//  StudyContentsViewController.swift
//  StudyHabitRecord
//
//  Created by 伊藤龍哉 on 2020/03/25.
//  Copyright © 2020 ryuuya.itou. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class StudyContentsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var categoryArray: [String] = []
    var pickerView: UIPickerView = UIPickerView()
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var targetTimeTextField: UITextField!
    
    let targetTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.time
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.init(identifier: "Japanese")
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        datePicker.minuteInterval = 5
        return datePicker
    }()
    
    let timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.time
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.init(identifier: "Japanese")
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        datePicker.minuteInterval = 1
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryTextField.inputView = pickerView
        
        targetTimeTextField.delegate = self
        targetTimeTextField.inputView = targetTimePicker
        
        timeTextField.delegate = self
        timeTextField.inputView = timePicker
        
        let categoryRef = Firestore.firestore().collection(Const.CategoryPath)
        
        categoryRef.addSnapshotListener() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
            }
            self.categoryArray = querySnapshot!.documents.map { document in
                print("DEBUG_PRINT: document取得 \(document.documentID)")
                let category = document.data()["category"] as! String
                return category
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryTextField.text = categoryArray[row]
    }
        
    @objc func dateChange(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeTextField.text = "\(formatter.string(from: timePicker.date))"
        targetTimeTextField.text = "\(formatter.string(from: targetTimePicker.date))"
    }
    
    
    @IBAction func handleAddCategoryButton(_ sender: Any) {
        print("DEBUG_PRINT: add categoryボタンがタップされました。")
            
        var alertTextField: UITextField?

        let alert = UIAlertController(
            title: "追加するカテゴリ名を入力",
            message: "作業カテゴリを入力",
            preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
            configurationHandler: {(textField: UITextField!) in
                alertTextField = textField
        })
        
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        alert.addAction(
            UIAlertAction(
                title: "追加する",
                style: UIAlertAction.Style.default) { _ in
                if let text = alertTextField?.text {
                    let categoryRef = Firestore.firestore().collection(Const.CategoryPath)
                    let categoryDic = ["category" : text]
                    categoryRef.document().setData(categoryDic)
                }
            }
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func handleAddContents(_ sender: Any) {
        let contentRef = Firestore.firestore().collection(Const.ContentPath)
        let contentDic = [
            "category" : categoryTextField.text!,
            "targetTime" : targetTimePicker.date,
            "startTime" : timePicker.date,
            ] as [String : Any]
        contentRef.document().setData(contentDic)
        self.navigationController?.popViewController(animated: true)
    }
    
}
