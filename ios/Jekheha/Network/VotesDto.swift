//
//  VotesDto.swift
//  Jekheha
//
//  Created by Svyatoshenko "Megal" Misha on 23.08.2020.
//  Copyright © 2020 Svyatoshenko "Megal" Misha. All rights reserved.
//

import Foundation

///{
///    "user": {
///        "user_id": 8,
///        "votes": [
///            {
///                "scope_id": 6,
///                "caption": "Покрасить скамейку!!!",
///                "answers": [
///                    {
///                        "name": "yes",
///                        "is_vote": false
///                    },
///                    {
///                        "name": "no",
///                        "is_vote": true
///                    },
///                    {
///                        "name": "against",
///                        "is_vote": false
///                    }
///                ],
///                "state": {
///                    "yes": 1,
///                    "no": 1,
///                    "against": 0
///                },
///                "user_id": 8
///            }
///        ]
///    },
///    "active": {
///        "votes": [
///            {
///                "scope_id": 6,
///                "caption": "Покрасить скамейку!!!",
///                "answers": [
///                    {
///                        "name": "yes",
///                        "is_vote": true
///                    },
///                    {
///                        "name": "no",
///                        "is_vote": false
///                    },
///                    {
///                        "name": "against",
///                        "is_vote": false
///                    }
///                ],
///                "state": {
///                    "yes": 2,
///                    "no": 1,
///                    "against": 0
///                },
///                "user_id": 9
///            }
///        ],
///        "user_id": 9
///    }
///}
struct VotesResponseDto: Codable {
	var user: BlockchainOfVotesDto
	var active: BlockchainOfVotesDto
}

struct BlockchainOfVotesDto: Codable {
	var userId: Int
	var votes: [VoteDto]

	enum CodingKeys: String, CodingKey {
		case userId = "user_id"
		case votes = "votes"
	}
}

struct VoteDto: Codable {
	var userId: Int
	var scopeId: Int
	var caption: String
	var answers: [UnaryAnswer]
	var state: [String: Int]

	enum CodingKeys: String, CodingKey {
		case userId = "user_id"
		case scopeId = "scope_id"
		case caption = "caption"
		case answers = "answers"
		case state = "state"
	}
}

struct UnaryAnswer: Codable {
	var name: String
	var isVote: Bool

	enum CodingKeys: String, CodingKey {
		case name = "name"
		case isVote = "is_note"
	}
}

