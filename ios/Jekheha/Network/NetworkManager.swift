//
//  NetworkManager.swift
//  Jekheha
//
//  Created by Svyatoshenko "Megal" Misha on 23.08.2020.
//  Copyright © 2020 Svyatoshenko "Megal" Misha. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
	func getVotes(completion: @escaping (Result<VotesResponseDto, Error>) -> Void)
}

class NetworkManager {
	static let shared = NetworkManager()

}

extension NetworkManager: NetworkManagerProtocol {

	func getVotes(completion: @escaping (Result<VotesResponseDto, Error>) -> Void) {
		do {
			let votes = try FileHelper.decode(VotesResponseDto.self, fromJSON: "votes")
			completion(.success(votes))
		} catch {
			completion(.failure(error))
		}
	}

}
