import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'stock_provider.dart'; // Import the provider

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  WatchlistPageState createState() => WatchlistPageState();
}

class WatchlistPageState extends State<WatchlistPage> {
  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context); // Access the provider

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80, left: 15),
            child: Text(
              'Your Watchlist',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          Expanded(
            child: stockProvider.watchlist.isEmpty
                ? const Center(
              child: Text('Your Watchlist is empty.'),
            )
                : ListView.builder(
              itemCount: stockProvider.watchlist.length,
              itemBuilder: (context, index) {
                final stock = stockProvider.watchlist[index];
                final symbol = stock['symbol'];
                final details = stockProvider.stockDetails[symbol]; // Get name and image based on symbol

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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${stock['symbol']} removed from watchlist')),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
