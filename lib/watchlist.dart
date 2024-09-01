import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'stock_provider.dart'; // Import the provider
import 'colors.dart'; // Ensure your colors.dart is imported

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  WatchlistPageState createState() => WatchlistPageState();
}

class WatchlistPageState extends State<WatchlistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Container with the secondary color background for the top section
          Container(
            color: DarkColors.secondaryColorLight, // Set the background color to secondary color
            padding: const EdgeInsets.only(top: 80, left: 15),
            width: double.infinity,
            child: Text(
              'Your Watchlist',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          Expanded(
            child: Consumer<StockProvider>(
              builder: (context, stockProvider, child) {
                return stockProvider.watchlist.isEmpty
                    ? const Center(
                  child: Text('Your Watchlist is empty.'),
                )
                    : ListView.builder(
                  itemCount: stockProvider.watchlist.length,
                  itemExtent: 80.0,
                  itemBuilder: (context, index) {
                    final stock = stockProvider.watchlist[index];
                    final symbol = stock['symbol'];
                    final details = stockProvider.stockDetails[symbol];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(details?['image']),
                        radius: 25,
                      ),
                      title: Text(
                        symbol,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Text(
                        details?['name'] ?? '', // Company name
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Price: \$${stock['price'].toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            stock['change'],
                            style: TextStyle(
                              color: stock['change'].contains('+') ? Colors.green : Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      onLongPress: () {
                        stockProvider.removeFromWatchlist(stock); // Use provider to remove from watchlist
                        ScaffoldMessenger.of(context).clearSnackBars(); // Clear existing snackbars
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${stock['symbol']} removed from watchlist')),
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
    );
  }
}
