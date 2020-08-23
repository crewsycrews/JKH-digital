//
//  VoteTopicView.swift
//  Jekheha
//
//  Created by Svyatoshenko "Megal" Misha on 22.08.2020.
//  Copyright © 2020 Svyatoshenko "Megal" Misha. All rights reserved.
//

import SwiftUI

struct VotePeriod {
	var start: Date
	var end: Date
}

protocol VotePeriodFormatterProtocol {
	func text(for period: VotePeriod) -> String
}

struct SimpleVotePeriodFormatter: VotePeriodFormatterProtocol {
	func text(for period: VotePeriod) -> String {
		let formatter = DateFormatter()
		formatter.timeStyle = .none
		formatter.dateStyle = .long
		formatter.locale = Locale(identifier: "ru_RU")

		return "с \(formatter.string(from: period.start)) по \(formatter.string(from: period.end))"
	}
}

struct VoteTopicModel {
	var period: VotePeriod
	var votableTopics: [String]

	var enumeratedTopics: [String] {
		return votableTopics.enumerated().map { (index, text) in
			"\(index + 1). \(text)"
		}
	}
}

struct VoteTopicView: View {
	let model: VoteTopicModel
	let periodFormatter: VotePeriodFormatterProtocol = SimpleVotePeriodFormatter()

	var body: some View {
		VStack(spacing: 8.0) {
			Text("Повестка голосования")
				.font(.headline)
			Text(periodFormatter.text(for: model.period))
				.font(.subheadline)
				.foregroundColor(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/)
			VStack(alignment: .leading) {
				ForEach(model.enumeratedTopics, id: \.self) { topic in
					Text(topic)
				}
			}
		}
    }
}

struct VoteTopicView_Previews: PreviewProvider {
	static let mockModel = VoteTopicModel(
		period: VotePeriod(
			start: Date(timeIntervalSinceNow: -259_200),
			end: Date()
		),
		votableTopics: [
			"Процедурные вопросы",
			"Утверждение сметы доходов и расходов на 2020г.",
			"Распределение дохода от аренды фасада за 2019г.",
			"Распределение сэкономленных в 2019 году средств."
		]
	)

    static var previews: some View {
		Group {
			VoteTopicView(model: mockModel)
				.previewLayout(.fixed(width: 375.0, height: 500.0))
				.environment(\.colorScheme, .light)
//			VoteTopicView(model: mockModel)
//				.previewLayout(.fixed(width: 375.0, height: 500.0))
//				.colorScheme(.dark)
//				.background(Color.black)
//				.environment(\.colorScheme, .dark)
		}
    }
}
