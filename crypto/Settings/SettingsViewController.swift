//
//  SettingsViewController.swift
//  crypto
//
//  Created by Алексей on 26.12.2020.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var currency: UIPickerView!
    
    let fiatKey = "fiat"
    let themeKey = "theme"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        
        currency.dataSource = self
        currency.delegate = self
        let fiat =  UserDefaults.standard.integer(forKey: fiatKey)
        let theme = UserDefaults.standard.integer(forKey: themeKey)
        currency.selectRow(abs(fiat-5), inComponent: 0, animated: true)
        currency.selectRow(theme, inComponent: 1, animated: true)
    }
}

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return fiats.count
        } else {
            return themes.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return fiats[abs(row - 5)]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 1{
            return NSAttributedString(string: themes[row]!, attributes: [NSAttributedString.Key.foregroundColor: themeColor[row]!])
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            UserDefaults.standard.set(abs(row-5), forKey: fiatKey)
        } else {
            navigationController?.navigationBar.tintColor = themeColor[row]
            tabBarController?.tabBar.tintColor = themeColor[row]
            UserDefaults.standard.set(row, forKey: themeKey)
        }
    }
    
}

