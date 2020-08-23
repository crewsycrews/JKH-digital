//
//  ActiveVotesView.swift
//  Jekheha
//
//  Created by Svyatoshenko "Megal" Misha on 22.08.2020.
//  Copyright © 2020 Svyatoshenko "Megal" Misha. All rights reserved.
//

import SwiftUI

struct ActiveVotesView: View {
	let votes: [VoteTopicModel]

    var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 24.0) {
				Text("Активные голосования")
					.font(.title)
				VStack {
					ForEach(votes.indices) { index in
						VStack(spacing: 8.0) {
							VoteTopicView(model: self.votes[index])
							NavigationLink(destination:
								VoteYesOrNoView(model: VoteYesOrNoModel(
									title: self.votes[index].votableTopics.first!,
									details: self.votes[index].votableTopics.first!)
								)
							) {
								Text("Проголосовать")
							}
							.padding(.horizontal, 40.0)
							.frame(height: 48.0)
							.buttonStyle(DefaultButtonStyle())
							.background(Color.blue)
							.foregroundColor(.white)
							.scaledToFill()
							.cornerRadius(4.0)
						}
						.padding(24.0)
						.background(Color("secondaryFill"))
					}
				}
			}
			.padding(.horizontal)
		}
	}
}

struct ActiveVotesView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			ActiveVotesView(votes: [VoteTopicView_Previews.mockModel])
			.navigationBarTitle("Главная", displayMode: .inline)
			.navigationBarBackButtonHidden(true)
		}
	}
}
