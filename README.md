# Stock Quote App 📈

The **Stock Quote App** provides real-time updates on stock prices and essential details such as percentage changes, market cap, and P/E ratio. Users can search for stocks, add them to a watchlist, and track their favorite stocks in real-time with an auto-refresh feature.

## Features 🌟

- **Real-Time Stock Data**: Get up-to-date stock information like price, percentage change, and market capitalization.
- **Search Stocks**: Search for your preferred stocks by name or symbol using the intuitive search bar.
- **Manage Watchlist**: Add or remove stocks from your personal watchlist. The watchlist data persists even after app closure.
- **Auto-Refresh**: Stock data refreshes at regular intervals to ensure real-time accuracy.
- **Offline Detection**: If the app detects a loss of internet connection, it notifies the user and pauses data updates until the connection is restored.

## Screenshots 📸

1. **Home Page**
   
   <img src="https://github.com/user-attachments/assets/27c79b4d-5312-4689-a3e6-e0667dfb84a4" alt="Home Screen" height="400"/>

2. **Search Functionality**

   <img src="https://github.com/user-attachments/assets/ee565ec1-23d8-46d0-9da0-6568d806c7b1" alt="Search Functionality" height="400"/>

3. **Watchlist Management**

   <img src="https://github.com/user-attachments/assets/925502a3-388f-44e0-b404-074e314137d7" alt="Watchlist Management" height="400"/>

4. **Stock Details**

   <img src="https://github.com/user-attachments/assets/f1fe8c49-7c98-49d4-8d7f-062420ec5486" alt="Stock Details" height="400"/>

## Getting Started 🚀

### Prerequisites

- Flutter SDK
- Android Studio / VS Code
- Finnhub API Key

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/stock-quote-app.git
   cd stock-quote-app
2. Install dependencies:
   ```bash
   flutter pub get
3. Add your API key:
   - Create a `config.dart` file inside the lib folder.
   - Add the following code:
     ```dart
     class Config {
      static const String apiKey = 'YOUR_FINNHUB_API_KEY';
     }
4. Run the app:
   ```bash
   flutter run

## App Architecture 🏗️
The app follows the Provider state management pattern with clean separation of concerns:

- **StockProvider:** Handles API requests, caching, and managing stock data.
- **UI:** Designed using `ListView`, `PageView`, and `BottomNavigationBar` for a smooth and responsive interface.
- **Local Storage:** Watchlist data is saved using `SharedPreferences` for persistence across sessions.

## Performance Considerations 🏎️
- Cached stock data to minimize repeated API calls.
- Asynchronous data fetching to avoid blocking the UI thread.
- Auto-refresh mechanism ensures real-time updates without excessive network calls.

## Testing 🧪
- Unit tests for data fetching.
- Widget tests for UI interaction using `flutter_test`.

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
