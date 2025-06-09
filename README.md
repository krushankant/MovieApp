# MovieApp
MovieApp is an iOS application built using the TMDB (The Movie Database) API to display popular movies. The app is developed using the MVVM architecture to promote separation of concerns, testability, and scalability. It serves as a learning project to strengthen and showcase best practices in iOS development.

**Project Goals:**
This project was created to:

- Practice and apply clean MVVM architecture
- Improve understanding of iOS patterns and principles
- Implement real-world API integration using The Movie Database API
- Learn and apply SwiftUI, async-await, and other modern iOS tools

**Architecture & Design Patterns:**
The app is implemented with a clean architectural approach and best practices, including:

 - MVVM (Model-View-ViewModel): Separation between UI logic and business logic
 - Naming Conventions: Consistent and descriptive names for clarity and maintainability
 - Dependency Injection: Flexible and testable structure using injected services
 - Protocols: Interfaces for abstraction, testability, and loose coupling
 - Extensions: Code modularization by separating utility functions and view modifiers

**API Integration:**
This app uses the TMDB Open API to fetch real-time movie data such as:

- Popular Movies
- Posters and Overviews

**To use the TMDB API:**

- Register an account at TMDB
- Create an API key from your TMDB dashboard
- Add your API key to the app's configuration (e.g., APIKeys.swift or Info.plist)

let apiKey = "YOUR_TMDB_API_KEY"

**Features:**

- Fetch and display a list of popular movies
- Navigation to detailed view with full movie info
- Async image loading with placeholder
- Error handling and user-friendly alerts
- Dynamic layout support (iPad & iPhone)
- Accessibility support and Dynamic Type

**Demo Video:**

https://github.com/user-attachments/assets/54b47629-1a8f-48d0-a8b0-154e2324adfc

**Requirements:**
iOS 17+
Swift 5.7+
Xcode 16
