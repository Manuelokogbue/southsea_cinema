# Southsea Cinema

A Flutter cinema-booking app for browsing films, selecting tickets, managing a basket, and saving bookings locally.

## Features

- Browse available films with their title, age rating, description, image, price, and showing time.
- View responsive movie cards on different screen sizes.
- Open a film to view more details.
- Select between one and five tickets.
- Add tickets to a basket.
- View basket contents, ticket quantities, prices, and totals.
- Automatically calculate a £4 service charge.
- Remove films from the basket.
- Complete a booking and save it locally.
- Generate booking numbers automatically.
- View previous bookings and past orders below the current basket.
- Preserve detailed item information for new orders.
- Continue showing summaries for older bookings created before item history was added.
- Save an address, email address, patron number, and newsletter preference.
- Switch between light and dark mode.
- Remember the selected theme between app launches.
- Navigate through the app using the navigation drawer.

## Screens

### Home

The home screen displays the available films using responsive movie cards. Film information is loaded from the app's movie data.

### Movie Details and Booking

Selecting **BOOK NOW** opens the movie booking screen. This screen displays further information about the film and allows the user to select tickets before adding them to the basket.

### Basket

The basket displays selected films, ticket quantities, prices, the service charge, and the total amount due.

Users can remove items from the basket or select **BUY TICKETS** to complete a booking.

### Bookings

Completed bookings are saved locally and displayed on the bookings screen. Each booking includes:

- Booking number
- Film summary
- Total price
- Booking date and time

### My Settings

The settings screen allows users to save their personal information and newsletter preference.

It also includes a **Dark mode** switch. Dark mode is enabled by default, but users can switch to light mode. The selected theme is saved for future launches.

## Technology

This project uses:

- Flutter
- Dart
- Material Design
- SQLite through `sqflite`
- `shared_preferences` for saved settings and theme preferences
- JSON movie data
- Flutter widget and unit tests

## Project Structure

```text
southsea_cinema/
├── assets/
│   ├── data/
│   │   └── movies.json
│   └── images/
├── lib/
│   ├── database/
│   │   └── cinema_db.dart
│   ├── models/
│   ├── repositories/
│   ├── views/
│   ├── widgets/
│   ├── constants.dart
│   └── main.dart
├── test/
├── pubspec.yaml
└── README.md
```

## Getting Started

### Requirements

Install:

- Flutter
- Dart
- Git
- An emulator, physical device, or supported desktop/web platform

Check that Flutter is installed correctly:

```bash
flutter doctor
```

### Install Dependencies

Clone the repository and move into the project directory:

```bash
git clone https://github.com/YOUR-USERNAME/southsea_cinema.git
cd southsea_cinema
```

Install the project dependencies:

```bash
flutter pub get
```

### Run the App

To run the app on Chrome:

```bash
flutter run -d chrome
```

You can also run it on another available Flutter device:

```bash
flutter devices
flutter run -d DEVICE_ID
```

Replace `DEVICE_ID` with the device you want to use.

## Running Tests

Run the complete test suite:

```bash
flutter test
```

Run static analysis:

```bash
flutter analyze
```

## Local Data

Movie information is stored in:

```text
assets/data/movies.json
```

Film images are stored in:

```text
assets/images/
```

Customer settings and theme preferences are saved using `shared_preferences`.

Bookings and purchased item details are saved in a local SQLite database.
The database uses version 2 with foreign-key support. Existing version 1
bookings are preserved during upgrade, and older bookings continue to use their
saved summary when no item-level records are available.

No external payment service or online booking service is currently connected.

## Current Limitations

- There is no online payment integration.
- Bookings are stored only on the local device.
- The **UPDATE ORDER** button is currently a placeholder.
- User accounts and online synchronisation are not included.
- Available films and showings come from the local movie data.
