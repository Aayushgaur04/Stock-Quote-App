import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'stock_provider.dart';
import 'theme.dart';

void main() {
  runApp(const StockQuoteApp());
}

class StockQuoteApp extends StatelessWidget {
  const StockQuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StockProvider>(
          create: (context) => StockProvider(),
        ),
      ],
      child: Consumer<StockProvider>(
        builder: (context, stockProvider, _) {
          // Fetch data when connected and loading for the first time
          if (stockProvider.isConnected && stockProvider.isLoading) {
            stockProvider.fetchStockData();
          }

          return MaterialApp(
            title: 'Stock Quote App',
            debugShowCheckedModeBanner: false,
            darkTheme: DarkTheme.themeData,
            themeMode: ThemeMode.dark,
            home: Scaffold(
              body: stockProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : stockProvider.isConnected
                  ? const MyHomePage() // Show your main content
                  : const Center(
                child: Text('No internet connection'),
              ),
            ),
          );
        },
      ),
    );
  }
}
