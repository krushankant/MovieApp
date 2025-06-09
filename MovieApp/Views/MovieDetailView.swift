//
//  MovieDetailView.swift
//  MovieApp
//

import SwiftUI

struct MovieDetailView: View {
    let movie: MovieModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let url = movie.posterURL {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .accessibilityLabel("\(movie.title) poster")
                    } placeholder: {
                        ProgressView()
                            .accessibilityLabel("Loading image for \(movie.title)")
                    }
                }
                Text(movie.title)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                    .accessibilityAddTraits(.isHeader)
                
                Text(movie.overview)
                    .font(.body)
                    .padding(.top)
                    .accessibilityLabel("Movie overview")
                    .accessibilityValue(movie.overview)
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    MovieDetailView(movie: MovieModel(
        id: 552524,
        title: "Lilo & Stitch",
        overview: "The wildly funny and touching story of a lonely Hawaiian girl and the fugitive alien who helps to mend her broken family.",
        posterPath: "/tUae3mefrDVTgm5mRzqWnZK6fOP.jpg"))
}
