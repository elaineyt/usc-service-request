//
//  Util.swift
//  ServiceRequest
//
//  Created by Michelle Ran on 11/9/19.
//

import Foundation
import UIKit

class Util {
    static func alert(title: String, message: String, presenter: UIViewController) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        presenter.present(alertController, animated: true, completion: nil)
    }
    
    static func parseTags(tags: String) -> [String] {
        var tagsArray: [String] = tags.components(separatedBy: ",")
        for i in 0..<tagsArray.count {
            tagsArray[i] = tagsArray[i].trimmingCharacters(in: .whitespacesAndNewlines)
        }
        tagsArray = tagsArray.filter { tag in
            return !tag.isEmpty
        }
        return tagsArray
    }
}
