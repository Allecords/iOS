//
//  AllecordsImageLoaderError.swift
//  Allecords
//
//  Created by Hoon on 5/14/24.
//

import Foundation

enum AllecordsImageLoaderError: LocalizedError {
	case downloadImageError
	case urlError
	case imageTypeError
}

extension AllecordsImageLoaderError {
	var errorDescription: String? {
		switch self {
		case .downloadImageError:
			return "Download Failed"
		case .urlError:
			return "URL Error"
		case .imageTypeError:
			return "Image Converting Error"
		}
	}
}
