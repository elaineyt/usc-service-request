//
//  RequestPostedCell.swift
//  SegmentedControlTest
//
//  Created by Michelle Ran on 11/26/19.
//  Copyright © 2019 Michelle Ran. All rights reserved.
//

import Foundation
import UIKit

class RequestPostedCell: UITableViewCell {
    var editHandler: (() -> Void) = { }
    @IBAction func edit() {
        self.editHandler()
    }
}
