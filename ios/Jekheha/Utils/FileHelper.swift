//
//  FileHelper.swift
//  Jekheha
//
//  Created by Svyatoshenko "Megal" Misha on 23.08.2020.
//  Copyright © 2020 Svyatoshenko "Megal" Misha. All rights reserved.
//

import Foundation

class FileHelper {
	enum FileError: Error {
		case notFound
	}

	static func data(from resourceName: String) throws -> Data {
		let bundle = Bundle(for: FileHelper.self)
		guard let path = bundle.path(forResource: "votes.json", ofType: nil) else {
			throw FileError.notFound
		}

		let url = URL(fileURLWithPath: path)
		return try Data(contentsOf: url)
	}

	static func decode<T: Decodable>(_ type: T.Type, fromJSON json: String) throws -> T {
		try JSONDecoder().decode(type, from: data(from: json+".json"))
	}

}
