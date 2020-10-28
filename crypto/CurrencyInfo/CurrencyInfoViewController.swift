//
//  CurrencyInfoViewController.swift
//  crypto
//
//  Created by Алексей on 28.10.2020.
//

import UIKit

class CurrencyInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let cur = getCurrByName(name: "Bitcoin")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
