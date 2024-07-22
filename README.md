# MovieListApp

An iOS application to display a list of movies using Swift, UIKit, Comppositional Layout, DiffableDataSource & Async-Await. The app features movie search, pagination, detailed movie information, and custom error handling.

## Features

- Display a list of movies in a collection view.
- Paginate through the list of movies.
- Search for movies using a search bar.
- Display detailed information about a selected movie.
- Show custom error popup messages.

## Project Structure

- **Model**: Data models for movies, movie details, genres, and cast members.
- **ViewModel**: Logic for fetching and processing movie data.
- **View**: UI components and their configurations.
- **Repository**: Data fetching logic for real and mock data.

## External Dependencies

- Kingfisher

## Installation

1. Clone the repository.
    ```bash
    git clone https://github.com/Mostafa3la2/TheMovieDatabase.git
    cd TheMovieDatabase
    ```
2. Open the project in Xcode.
    ```bash
    open TheMovieDatabase.xcodeproj
    ```

## Usage

1. Run the project in Xcode.
2. Use the search bar to search for movies.
3. Scroll to the bottom of the list to load more movies.
4. Tap on a movie to view its details.
5. If an error occurs, a custom error popup will appear at the top of the screen.

## Clean Architecture

This project follows Clean Architecture principles to ensure a maintainable, testable, and scalable codebase. The architecture is divided into three main layers:

### 1. Presentation Layer

- **Responsibilities**: Display information and handle user interactions.
- **Components**:
  - `View Controllers`: `MovieListViewController`, `MovieDetailsViewController`
  - `Views`: `ErrorPopupView`, `MovieCollectionViewCell`, , `LoadingFooterView`, `CastMemberCollectionViewCell`, `GenresCollectionViewCell`
  - `ViewModels`: `MovieListViewModel`, `MovieDetailsViewModel`

### 2. Domain Layer

- **Responsibilities**: Core business logic.
- **Components**:
  - `Use Cases`: `FetchMoviesUseCase`, `FetchMovieDetailsUseCase`, `SearchMoviesUseCase`, `FetchMovieCastUseCase`
  - `Entities`: `Movie`, `MovieDetails`, `Genre`, `CastMember`

### 3. Data Layer

- **Responsibilities**: Data retrieval from remote or local sources.
- **Components**:
  - `Repositories`: `MovieRepository`, `MockMovieRepository`
    
### Dependency Injection

There is a simple dependency injection solution impelemted that provides mocking each layer of the structure for testing
    
## Error Handling

- **Custom `ErrorPopupView`**: Displays error messages.
- **Behavior**: Appears from the top and dismisses automatically after 5 seconds. Ensures only one popup is displayed at a time.

## Thoughs and further enhancements
- Enhance error handling and visual of popup
- add more unit tests to cover testing pagination and search
- add local caching for offline support
- Add theming support for different grid layouts in list page, also light, dark, high contrast custom colors themes

