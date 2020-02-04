//
//  SampleNoteUITableViewCell.swift
//  SampleNoteApp
//
//  Created by Besta, Balaji (623-Extern) on 04/02/20.
//  Copyright © 2020 Balaji Besta. All rights reserved.
//

import Foundation
import UIKit

class SampleNoteUITableViewCell : UITableViewCell {
    private(set) var noteTitle : String = ""
    private(set) var noteText  : String = ""
    private(set) var noteDate  : String = ""
 
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var noteDateLabel: UILabel!
}
