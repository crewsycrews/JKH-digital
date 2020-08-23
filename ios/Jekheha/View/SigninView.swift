//
//  SigninView.swift
//  Jekheha
//
//  Created by Svyatoshenko "Megal" Misha on 22.08.2020.
//  Copyright © 2020 Svyatoshenko "Megal" Misha. All rights reserved.
//

import SwiftUI

struct SigninView: View {
    var body: some View {
		NavigationView {
			VStack {
				Text("голос")
					.font(.largeTitle)
				Spacer()
				NavigationLink(
					destination: ActiveVotesView(
						votes:  [VoteTopicView_Previews.mockModel]
					)
					.navigationBarTitle("Главная", displayMode: .inline)
					.navigationBarBackButtonHidden(true)
				) {
					Text("Войти через Госуслуги")
						.padding(.horizontal, 24.0)
						.frame(height: 48.0)
				}
				.accentColor(.white)
				.background(Color.blue)
				.cornerRadius(4.0)
				Spacer()
			}
		}
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}
