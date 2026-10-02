# Ticket Booking App

A Flutter ticket booking application built with clean architecture using:
- **BLoC** for state management
- **GetIt + Injectable** for dependency injection
- **Dio** for HTTP networking
- **GoRouter** for navigation

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── di/                 # Dependency injection setup
│   ├── errors/             # Failure classes and error handling
│   ├── network/            # Dio client, API service
│   ├── routing/            # GoRouter configuration
│   ├── utils/              # Utility functions
│   └── widgets/            # Shared widgets (splash, navigation)
└── features/
    ├── auth/
    │   ├── data/           # Models, datasources, repository impl
    │   ├── domain/         # Entities, repository interface, use cases
    │   └── presentation/   # BLoC, pages, widgets
    ├── events/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── booking/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── profile/
        ├── data/
        ├── domain/
        └── presentation/
```

## Getting Started

### Prerequisites
- Flutter SDK >= 3.2.0
- Dart SDK >= 3.2.0

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Generate code (for freezed, json_serializable, injectable):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run the app:
```bash
flutter run
```

## Architecture Overview

### Clean Architecture Layers

1. **Domain Layer** (Pure Dart)
   - Entities: Core business objects
   - Repository Interfaces: Contracts for data access
   - Use Cases: Business logic

2. **Data Layer**
   - Models: DTOs with JSON serialization
   - Data Sources: Remote (API) and Local (Storage)
   - Repository Implementations: Concrete implementations

3. **Presentation Layer**
   - BLoC: State management
   - Pages: UI screens
   - Widgets: Reusable UI components

### Key Features

- **Authentication**: Login, register, password reset, email verification
- **Events**: Browse, search, filter, view details
- **Booking**: Select tickets, quantity, promo codes, payment flow
- **Profile**: View/edit profile, bookings history, settings

### State Management

All features use BLoC pattern with:
- Events: User actions and system events
- States: UI states (loading, loaded, error)
- Bloc: Business logic and state transitions

### Dependency Injection

Using GetIt + Injectable for compile-time DI:
- All dependencies registered in `core/di/injection.dart`
- Generated code in `core/di/injection.config.dart`

### Networking

Dio client with:
- Interceptors for auth tokens, logging
- Automatic token refresh on 401
- Error handling with typed failures

### Routing

GoRouter with:
- Declarative route definitions
- Route guards for authentication
- Deep linking support

## Code Generation

Run build_runner for:
- Freezed models
- JSON serialization
- Injectable DI registration

```bash
# Development (watch mode)
flutter pub run build_runner watch --delete-conflicting-outputs

# One-time build
flutter pub run build_runner build --delete-conflicting-outputs
```

## Testing

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/
```

## Environment Configuration

Create `.env` file for environment variables:
```
BASE_URL=https://api.yourdomain.com
API_VERSION=v1
```