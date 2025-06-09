//
//  MovieListView.swift
//  MovieApp
//

import SwiftUI
import SwiftData

struct MovieListView: View {
    @Environment(\.modelContext) private var context
    @Query private var items: [Item]
    @StateObject private var viewModel: MovieListViewModel
    
    init() {
        let container = try! ModelContainer(for: MovieModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = ModelContext(container)
        _viewModel = StateObject(wrappedValue: MovieListViewModel(service: MovieService(), context: context))
    }
    
    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .phone {
                NavigationView {
                    ZStack {
                        movieListView
                            .blur(radius: viewModel.isLoading ? 2 : 0)
                            .disabled(viewModel.isLoading)
                        
                        if viewModel.isLoading {
                            loadingOverlay
                                .accessibilityElement()
                                .accessibilityLabel("Loading movies")
                                .accessibilityAddTraits(.isStaticText)
                        }
                    }
                    .navigationTitle("Popular Movies")
                }
            } else {
                NavigationSplitView {
                    movieListView
                        .navigationTitle("Popular Movies")
                        .frame(maxWidth: 600)
                        .padding(.horizontal)
                } detail: {
                    Text("Select a movie")
                }
            }
        }
        .onAppear {
            if viewModel.movies.isEmpty {
                Task {
                    await viewModel.loadMovies()
                }
            }
        }
        .alert(item: Binding(
            get: { viewModel.errorMessage.map { ErrorWrapper(message: $0) } },
            set: { _ in viewModel.errorMessage = nil }
        )) { wrapper in
            Alert(
                title: Text("Error"),
                message: Text(wrapper.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var movieListView: some View {
        List {
            ForEach(viewModel.movies) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    movieRowView(for: movie)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(movie.title), \(shortenedOverview(movie.overview))")
                .accessibilityHint("Tap to view more details about \(movie.title)")
                .onAppear {
                    if movie == viewModel.movies.last, !viewModel.isLoading {
                        Task { await viewModel.loadMovies() }
                    }
                }
            }
            
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding()
                        .accessibilityLabel("Loading more movies")
                    Spacer()
                }
            }
        }
        .listStyle(.plain)
    }
    
    /// This function returns a view representing a single movie row with poster, title, and overview.
    ///
    /// - Parameter movie: The MovieModel object containing the movie's data.
    /// - Returns: A View displaying a summary of the movie for use in a list.
    private func movieRowView(for movie: MovieModel) -> some View {
        HStack(alignment: .top, spacing: 12) {
            moviePosterView(for: movie)
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(movie.overview)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
        }
        .padding(.vertical, 8)
    }
    
    /// This function displaying the movie poster image or a placeholder.
    ///
    /// - Parameter movie: The `MovieModel` containing the poster URL.
    /// - Returns: A `View` showing the movie poster or a placeholder.
    ///
    /// The view is wrapped in `@ViewBuilder` to support conditional view building.
    @ViewBuilder
    private func moviePosterView(for movie: MovieModel) -> some View {
        if let url = movie.posterURL {
            AsyncImage(url: url) { image in
                image.resizable()
                    .scaledToFill()
                    .accessibilityHidden(true) // Already covered in the label
            } placeholder: {
                Color.gray.opacity(0.3)
                    .accessibilityHidden(true)
            }
            .frame(width: 60, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 90)
                .accessibilityHidden(true)
        }
    }
    
    /// This function displaying  a loading indicator.
    ///
    /// - Returns: A `View` representing a loading spinner overlay with accessibility support.
    private var loadingOverlay: some View {
        ProgressView("Loading...")
            .scaleEffect(1.5)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .transition(.opacity)
    }
    
    /// This function returns a shortened version of the movie overview text.
    ///
    /// - Parameter overview: The full overview text of the movie.
    /// - Returns: A shortened summary string, or a default message if the overview is empty.
    private func shortenedOverview(_ overview: String) -> String {
        let trimmed = overview.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "No description available" : String(trimmed.prefix(100)) + "..."
    }
    
    struct ErrorWrapper: Identifiable {
        let id = UUID()
        let message: String
    }
}

#Preview {
    MovieListView()
        .modelContainer(for: Item.self, inMemory: true)
}
