//
//  UITextView+Extension.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 06.08.2025.
//

import UIKit

extension UITextView {
    func addDoneButtonToKeyboard() {
            
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
            doneToolbar.barStyle = UIBarStyle.default
            
            let flexSpace = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                target: nil,
                action: nil
            )
            let done: UIBarButtonItem = UIBarButtonItem(
                title: "Done",
                style: UIBarButtonItem.Style.done,
                target: self,
                action: #selector(self.doneButtonAction)
            )
        done.tintColor = .black
            
            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)
            
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            
            self.inputAccessoryView = doneToolbar
        }
        
        @objc func doneButtonAction() {
            self.resignFirstResponder()
        }
}
