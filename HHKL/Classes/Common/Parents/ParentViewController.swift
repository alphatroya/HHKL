//
// Created by Alexander Maslennikov on 27.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        guard let navigationController = self.navigationController else {
            return
        }

        navigationController.navigationBar.tintColor = UIColor.hhkl_textColor()
        if let gestureRecognizer = navigationController.interactivePopGestureRecognizer {
            gestureRecognizer.delegate = popGestureRecognizerDelegate
            gestureRecognizer.enabled = navigationController.viewControllers.count > 1
        }
    }

    private let popGestureRecognizerDelegate = ParentPopGestureRecognizerDelegate()

    private class ParentPopGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
        @objc func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }

}
