//
//  String+.swift
//  Allecords
//
//  Created by Hoon on 5/28/24.
//

import Foundation

extension String? {
	var orEmpty: String {
		self == nil ? "" : self!
	}
}
