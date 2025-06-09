//
//  TestModelContextFactory.swift
//  MovieAppTests
//

import SwiftData
@testable import MovieApp

func createInMemoryModelContext() -> ModelContext {
    let schema = Schema([MovieModel.self])
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [configuration])
    return ModelContext(container)
}
