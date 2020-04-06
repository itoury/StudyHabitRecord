//
//  StudyAchivementViewController.swift
//  StudyHabitRecord
//
//  Created by 伊藤龍哉 on 2020/04/02.
//  Copyright © 2020 ryuuya.itou. All rights reserved.
//

import UIKit

class StudyAchivementViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var containerView: UIView!
    var currentViewController: UIViewController?
    
    
    
    override func viewDidLoad() {
        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Container1")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.containerView)
        super.viewDidLoad()
    }
    
    @IBAction func handleSegmentControl(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Container1")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        } else {
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Container2")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        }
    }
    
    func addSubview(_ subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)

        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
    parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
        options: [], metrics: nil, views: viewBindingsDict))
    parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
        options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func cycleFromViewController(_ oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParent: nil)
        self.addChild(newViewController)
        self.addSubview(newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
                newViewController.view.alpha = 1
                oldViewController.view.alpha = 0
            },
            completion: { finished in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParent()
                newViewController.didMove(toParent: self)
        })
    }
    

}
