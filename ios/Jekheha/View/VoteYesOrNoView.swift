//
//  VoteYesOrNoView.swift
//  Jekheha
//
//  Created by Svyatoshenko "Megal" Misha on 22.08.2020.
//  Copyright © 2020 Svyatoshenko "Megal" Misha. All rights reserved.
//

import SwiftUI

struct VoteYesOrNoModel {
	let title: String
	let details: String
}

enum SimpleVote: String, Identifiable {
	case didntVote
	case abstain
	case yes
	case no

	var id: String { self.rawValue }
}

struct VoteYesOrNoView: View {

	@State private var selectedVote = SimpleVote.didntVote {
		didSet {
			print("\(selectedVote) selected")
		}
	}

	let model: VoteYesOrNoModel

    var body: some View {
		VStack(alignment: .center, spacing: 16.0) {
			Text(model.title)
				.font(.title)
			Text(model.details)
				.font(.body)
				.multilineTextAlignment(.leading)
			Picker(selection: $selectedVote, label: Text("")) {
				ForEach([SimpleVote.yes, SimpleVote.no, SimpleVote.abstain]) { vote in
					Text(vote.rawValue)
				}
			}
		}
		.padding(16.0)
    }
}

struct VoteYesOrNoView_Previews: PreviewProvider {
	static let mockModel = VoteYesOrNoModel(
		title: "Голосование по вопросу покраски подъезда",
		details: "Просим произвести покраску подъезда в мерзко-зеленый цвет с линиями в мелкую сеточку коричневого цвета с рисунками бабочек и многоножек. Покрасить ступеньки в черный, кроме третьей сверху. Нанести изображение чёрного властелина на дверь квартиры номер 371."
	)

    static var previews: some View {
		VoteYesOrNoView(model: mockModel)
    }
}
