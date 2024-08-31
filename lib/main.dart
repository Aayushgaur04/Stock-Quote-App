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
    return ChangeNotifierProvider(
      create: (context) => StockProvider(),
      child: Builder(
        builder: (context) {
          final stockProvider = Provider.of<StockProvider>(context);

          // Fetch data when connected
          if (stockProvider.isConnected && stockProvider.isLoading) {
            stockProvider.fetchStockData();
          }

          return MaterialApp(
            title: 'Stock Quote App',
            debugShowCheckedModeBanner: false,
            theme: LightTheme.themeData,
            darkTheme: DarkTheme.themeData,
            themeMode: ThemeMode.system,
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
