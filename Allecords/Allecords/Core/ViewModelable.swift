//
//  ViewModelable.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import Foundation

protocol ViewModelable {
	associatedtype Input
	associatedtype State
	associatedtype Output
	
	func transform(_ input: Input) -> Output
}
