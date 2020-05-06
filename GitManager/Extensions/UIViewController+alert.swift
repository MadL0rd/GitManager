//
//  UIViewController+alert.swift
//  TaganrogAttractionsMap
//
//  Created by Антон Текутов on 24.03.2020.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, 
                                      message: message, 
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                      style: UIAlertAction.Style.default, 
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithTextField(title: String, message: String, stringReturnHandler: @escaping (_ enteredText: String) -> Void) {
        let alert = UIAlertController(title: title, 
                                      message: message, 
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.returnKeyType = .send
            textField.becomeFirstResponder()
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), 
                                      style: .cancel, 
                                      handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Submit", comment: ""), 
                                      style: UIAlertAction.Style.default, 
                                      handler: { (_) in stringReturnHandler(alert.textFields?[0].text ?? "") }))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithPicker(title: String, message: String, pickerItems: [String], stringReturnHandler: @escaping (_ enteredText: String) -> Void) {
        let alert = UIAlertController(title: title, 
                                      message: message, 
                                      preferredStyle: UIAlertController.Style.alert)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        let pickerManager = PickerViewManager(pickerView: pickerView, itemsCollection: pickerItems)
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250, height: 200)
        vc.view.addSubview(pickerView)
        alert.setValue(vc, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), 
                                      style: .cancel, 
                                      handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Select", comment: ""), 
                                      style: UIAlertAction.Style.default, 
                                      handler: { (_) in stringReturnHandler(pickerManager.selectedValue) }))
        present(alert, animated: true, completion: nil)
    }
}

class PickerViewManager: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let items: [String]
    let picker: UIPickerView
    var selectedValue: String
    
    init(pickerView: UIPickerView, itemsCollection: [String]) {
        items = itemsCollection
        picker = pickerView
        selectedValue = items[0]
        super.init()
        picker.dataSource = self
        picker.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = items[row]
    }
       
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
}
