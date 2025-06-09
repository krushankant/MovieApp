//
//  MovieListViewModel.swift
//  MovieApp
//

import Foundation
import SwiftData

@MainActor
final class MovieListViewModel: ObservableObject {
    @Published var movies: [MovieModel] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var hasMorePages: Bool = true
    
    private let movieService: MovieServiceProtocol
    private let context: ModelContext
    
    init(service: MovieServiceProtocol, context: ModelContext) {
        self.movieService = service
        self.context = context
    }
    
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    
    func loadMoviesIfNeeded(currentItem: MovieModel?) async {
        guard let currentItem = currentItem else {
            await loadMovies()
            return
        }
        
        let thresholdIndex = movies.index(movies.endIndex, offsetBy: -5)
        if movies.firstIndex(where: { $0.id == currentItem.id }) == thresholdIndex {
            await loadMovies()
        }
    }
    
    /// This function loads a page of popular movies asynchronously from the movie service and stores them in persistent storage.
    func loadMovies() async {
        guard !isLoading, hasMorePages else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response: MovieResponse = try await movieService.fetchPopularMovies(page: currentPage)
            
            totalPages = response.totalPages
            currentPage += 1
            hasMorePages = currentPage <= totalPages
            
            for dto in response.results {
                let dtoID = dto.id
                let predicate = #Predicate<MovieModel> { $0.id == dtoID }
                
                if try context.fetch(FetchDescriptor<MovieModel>(predicate: predicate)).isEmpty {
                    let model = MovieModel.from(dto: dto)
                    context.insert(model)
                }
            }
            
            // Reload from persistent storage (to reflect insertions)
            let sort = SortDescriptor(\MovieModel.id, order: .forward) // or .reverse
            let allMovies = try context.fetch(FetchDescriptor<MovieModel>(sortBy: [sort]))
            movies = allMovies
            
        } catch {
            // Load local data as fallback
            loadFromCache()
            if let serviceError = error as? MovieServiceError {
                self.errorMessage = serviceError.localizedDescription
            } else {
                self.errorMessage = "Failed to load movies: \(error.localizedDescription)"
            }
        }
    }
    
    /// This function loads movies from the local persistent storage and updates the `movies`
    private func loadFromCache() {
        if let cachedMoviews = try? context.fetch(FetchDescriptor<MovieModel>()) {
            self.movies = cachedMoviews
        }
    }
}
