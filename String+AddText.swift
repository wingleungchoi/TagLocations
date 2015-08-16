//
//  String+AddText.swift
//  MyLocations
//
//  Created by Wing LeungCHOI on 16/8/15.
//  Copyright (c) 2015 WingLeung CHOI. All rights reserved.
//

import UIKit
extension String {
    mutating func addText(text: String?, withSeparator separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}