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
      child: MaterialApp(
        title: 'Stock Quote App',
        debugShowCheckedModeBanner: false,
        darkTheme: DarkTheme.themeData,
        themeMode: ThemeMode.dark,
        home: Consumer<StockProvider>(
          builder: (context, stockProvider, _) {
            return Scaffold(
              body: Selector<StockProvider, bool>(
                selector: (_, provider) => provider.isLoading,
                builder: (_, isLoading, __) {
                  return isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : stockProvider.isConnected
                      ? const MyHomePage() // Show main content
                      : const Center(
                    child: Text('No internet connection'),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
