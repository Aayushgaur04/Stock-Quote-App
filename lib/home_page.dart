import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_quote_app/colors.dart';
import 'stock_provider.dart';
import 'watchlist.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController(); // Controller for navigation pages
  int _selectedIndex = 0; // Index for bottom navigation

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Switch pages
  }

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          // Home Page (Stock Quote Page)
          Stack(
            children: [
              Container(
                color: DarkColors.secondaryColorLight, // Set background to secondary color
                height: 220, // Adjust the height as needed to cover until the search bar
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hi,',
                      style: Theme.of(context).textTheme.displayLarge, // Text style remains unchanged
                    ),
                    const Text(
                      'Welcome',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 250,
                left: 15,
                right: 15,
                child: TextField(
                  onChanged: (query) => stockProvider.filterStocks(query),
                  decoration: InputDecoration(
                    hintText: 'Search by symbol or name',
                    suffixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 330,
                left: 0,
                right: 0,
                bottom: 0,
                child: stockProvider.isLoading
                    ? const Center(child: CircularProgressIndicator(color: DarkColors.accentColor))
                    : Consumer<StockProvider>( // Use Consumer to rebuild only the part of the widget tree that needs it
                  builder: (context, provider, child) {
                    return ListView.builder(
                      itemCount: provider.filteredStocks.length,
                      itemBuilder: (context, index) {
                        final stock = provider.filteredStocks[index];
                        final symbol = stock['symbol'];
                        final details = provider.stockDetails[symbol];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(details?['image']),
                            radius: 25,
                          ),
                          title: Text(symbol, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          subtitle: Text(
                            details?['name'] ?? '',
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Price: \$${stock['price'].toStringAsFixed(2)}', style: const TextStyle(fontSize: 14)),
                              Text(
                                stock['change'],
                                style: TextStyle(
                                  color: stock['change'].contains('+') ? Colors.green : Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          onTap: () => provider.showStockDetails(context, stock, details!), // Select stock on tap
                          onLongPress: () {
                            provider.addToWatchlist(stock); // Add to watchlist on long press
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$symbol added to watchlist')),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          // Watchlist Page
          const WatchlistPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Watchlist',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}