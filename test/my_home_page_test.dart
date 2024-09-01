import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:stock_quote_app/home_page.dart';
import 'package:provider/provider.dart';
import 'package:stock_quote_app/stock_provider.dart';

class MockStockProvider extends StockProvider {
  @override
  void startAutoRefresh() {
    // Do nothing, prevent the timer from starting during tests
  }
}

void main() {
  testWidgets('HomePage displays stock list', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => StockProvider()),
          // Include any other providers required for the test
        ],
        child: const MaterialApp(
          home: MyHomePage(),
        ),
      ),
    );

    // Now you can proceed with your tests
    expect(find.byType(PageView), findsOneWidget);
    // Add more expectations as needed
  });
}
