//
//  Errors.swift
//  crypto
//
//  Created by Dmitry on 30/11/2020.
//

import Foundation
import UIKit

func showError(err: String,inputController: UIViewController) {
        let alert = UIAlertController(title: "Error", message: err, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .cancel, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        inputController.present(alert, animated: true, completion: nil)
    
}
