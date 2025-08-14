# Book Finder App 📚

A simple Flutter application that allows users to search for books using the Open Library API.

## Features ✨

- **Book Search**: Search for books by title using the Open Library API
- **Responsive Design**: Built with Sizer for cross-device compatibility
- **Simple Loading**: Basic loading indicators while fetching data
- **Error Handling**: User-friendly error messages with retry functionality
- **Clean Architecture**: Well-structured code following clean architecture principles

## Screens 🖥️

### Search Screen
- Search bar for book title input
- Display book results with title, author, and thumbnail
- Simple loading animation
- Error handling with retry option

## Architecture 🏗️

The app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── data/                    # Data Layer
│   ├── models/             # Data models
│   ├── repositories/        # Repository implementations
│   └── services/           # API services
├── domain/                 # Domain Layer
│   └── usecases/          # Business logic use cases
└── presentation/           # Presentation Layer
    ├── providers/          # State management
    ├── screens/            # UI screens
    └── widgets/            # Reusable UI components
```

### Key Components:

- **Data Layer**: `Book` model, `BookApiService`
- **Domain Layer**: Use case for fetching books
- **Presentation Layer**: Provider state management, responsive UI components

## Technologies Used 🛠️

- **Flutter**: Cross-platform UI framework
- **Provider**: State management solution
- **HTTP**: API communication
- **Sizer**: Responsive design utilities

## API Integration 🌐

The app integrates with the **Open Library API**:
- **Search Endpoint**: `/search.json` for book search
- **Cover Images**: High-quality book cover images
- **Simple Response**: Basic book information (title, author, cover)

## Getting Started 🚀

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd assignment4
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Dependencies

The app uses the following key dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0                    # API communication
  provider: ^6.1.1                # State management
  sizer: ^2.0.15                  # Responsive design
```

## Usage Guide 📖

### Searching for Books
1. Open the app and use the search bar at the top
2. Type a book title and press Enter or tap Search
3. Browse through the search results
4. Each book shows title, author, and cover image

## Features in Detail 🔍

### Responsive Design
- Uses Sizer package for adaptive layouts
- Optimized for different screen sizes and orientations
- Consistent UI across devices

### State Management
- Provider pattern for clean state management
- Efficient UI updates and state synchronization
- Proper error handling and loading states

### Performance
- Simple HTTP requests to Open Library API
- Efficient data parsing and display
- Minimal memory usage

### User Experience
- Clean and intuitive interface
- Clear feedback for user actions
- Simple loading and error states

## Error Handling 🚨

The app includes basic error handling:
- Network connectivity issues
- API errors
- Invalid search queries
- User-friendly error messages with retry options

## Future Enhancements 🚀

Potential improvements for future versions:
- Book details screen
- Local storage for favorites
- Advanced search filters
- Pagination for large results
- Offline capabilities

## Contributing 🤝

This is an assignment project, but contributions are welcome:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License 📄

This project is created for educational purposes as part of a Flutter assignment.

## Contact 📧

For questions or support, please contact the development team.

---

**Happy Reading! 📚✨**
