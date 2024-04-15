//
//  ViewBindable.swift
//  Allecords
//
//  Created by Hoon on 4/13/24.
//

import Foundation

protocol ViewBindable {
	associatedtype State
	associatedtype OutputError: Error
	
	func bind()
	func render(_ state: State)
	func handleError(_ error: OutputError)
}

extension ViewBindable {
	func handleError(_ error: OutputError) { }
}
