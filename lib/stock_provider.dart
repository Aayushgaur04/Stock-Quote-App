import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'config.dart';

class StockProvider with ChangeNotifier {
  final String apiKey = Config.apiKey;
  final http.Client client;
  List<Map<String, dynamic>> stocks = [];
  List<Map<String, dynamic>> watchlist = [];
  List<Map<String, dynamic>> filteredStocks = [];
  bool isLoading = true;
  Map<String, dynamic>? selectedStock;
  final Map<String, dynamic> _cache = {}; // Cache for stock data
  bool isConnected = true;
  Timer? _timer;
  //final Duration _refreshInterval = const Duration(seconds: 120);

  String formatNumber(double value) {
    if (value >= 1e12) {
      return '${(value / 1e12).toStringAsFixed(1)}T'; // Trillions
    } else if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(1)}B'; // Billions
    } else if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(1)}M'; // Millions
    } else if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(1)}K'; // Thousands
    } else {
      return value.toString(); // No formatting needed
    }
  }


  final Map<String, Map<String, dynamic>> stockDetails = {
    'AAPL': {
      'name': 'Apple Inc.',
      'image': 'assets/apple_logo.png',
    },
    'GOOGL': {
      'name': 'Alphabet Inc.',
      'image': 'assets/google_logo.png',
    },
    'AMZN': {
      'name': 'Amazon.com Inc.',
      'image': 'assets/amazon_logo.png',
    },
    'MSFT': {
      'name': 'Microsoft Corporation',
      'image': 'assets/microsoft_logo.png',
    },
    'TSLA': {
      'name': 'Tesla, Inc.',
      'image': 'assets/tesla_logo.png',
    },
    'META': {
      'name': 'Meta Platforms, Inc.',
      'image': 'assets/meta_logo.png',
    },
    'NFLX': {
      'name': 'Netflix, Inc.',
      'image': 'assets/netflix_logo.png',
    },
    'NVDA': {
      'name': 'NVIDIA Corporation',
      'image': 'assets/nvidia_logo.png',
    },
    'BA': {
      'name': 'The Boeing Company',
      'image': 'assets/boeing_logo.png',
    },
    'JPM': {
      'name': 'JPMorgan Chase & Co.',
      'image': 'assets/jpmorgan_logo.png',
    },
    'V': {
      'name': 'Visa Inc.',
      'image': 'assets/visa_logo.png',
    },
    'DIS': {
      'name': 'The Walt Disney Company',
      'image': 'assets/disney_logo.png',
    },
    'PYPL': {
      'name': 'PayPal Holdings, Inc.',
      'image': 'assets/paypal_logo.png',
    },
    'BABA': {
      'name': 'Alibaba Group Holding Ltd.',
      'image': 'assets/alibaba_logo.png',
    },
    'ORCL': {
      'name': 'Oracle Corporation',
      'image': 'assets/oracle_logo.png',
    },
    'INTC': {
      'name': 'Intel Corporation',
      'image': 'assets/intel_logo.png',
    },
    'CSCO': {
      'name': 'Cisco Systems, Inc.',
      'image': 'assets/cisco_logo.png',
    },
    'ADBE': {
      'name': 'Adobe Inc.',
      'image': 'assets/adobe_logo.png',
    },
    'NKE': {
      'name': 'Nike, Inc.',
      'image': 'assets/nike_logo.png',
    },
    'XOM': {
      'name': 'Exxon Mobil Corporation',
      'image': 'assets/exxon_logo.png',
    },
  };

  StockProvider({http.Client? client}) : client = client ?? http.Client() {
    // Listen to connectivity changes and load saved watchlist
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        isConnected = false;
        notifyListeners();
      } else {
        isConnected = true;
        fetchStockData();
      }
    });

    loadWatchlist(); // Load watchlist from shared preferences when app starts
    startAutoRefresh();
  }

  Future<void> fetchStockData() async {
    if (!isConnected) {
      isLoading = false;
      notifyListeners();
      return;
    }

    final symbols = stockDetails.keys.toList();
    List<Future<void>> requests = [];

    for (String symbol in symbols) {
      final url = 'https://finnhub.io/api/v1/quote?symbol=$symbol&token=$apiKey';
      requests.add(_fetchStock(symbol, url));
    }

    await Future.wait(requests);
    filteredStocks = stocks;
    updateWatchlistWithFetchedData();
    isLoading = false;
    notifyListeners();
  }

  void startAutoRefresh() {
    if (const bool.fromEnvironment('dart.vm.product')) {
      // Only start the timer if not in a test environment
      _timer = Timer.periodic(const Duration(minutes: 2), (timer) {
        if (isConnected) {
          fetchStockData(); // Re-fetch stock data periodically
        }
      });
    }
  }

  // Stop the timer when necessary (for example, when the app is closed)
  void stopAutoRefresh() {
    _timer?.cancel();
  }

  // Ensure this is called when necessary to release the timer
  @override
  void dispose() {
    stopAutoRefresh();
    super.dispose();
  }

  // Method to save the watchlist to shared preferences
  Future<void> saveWatchlist() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final watchlistData = watchlist.map((stock) => jsonEncode(stock)).toList();
      await prefs.setStringList('watchlist', watchlistData);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving watchlist: $e');
      }
    }
  }

  // Method to load the watchlist from shared preferences and update stock data
  Future<void> loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final savedWatchlist = prefs.getStringList('watchlist');

    if (savedWatchlist != null) {
      // Safely decode the stored strings into maps
      try {
        watchlist = savedWatchlist
            .map((stock) => jsonDecode(stock) as Map<String, dynamic>)
            .toList();
        await refreshWatchlistData(); // Fetch latest data for watchlist stocks
      } catch (e) {
        if (kDebugMode) {
          print('Error decoding watchlist: $e');
        }
      }
    }

    notifyListeners(); // Notify UI to update after loading watchlist
  }

  // Fetch latest data for all stocks in the watchlist
  Future<void> refreshWatchlistData() async {
    List<Future<void>> requests = [];
    for (var stock in watchlist) {
      final symbol = stock['symbol'];
      final url = 'https://finnhub.io/api/v1/quote?symbol=$symbol&token=$apiKey';
      requests.add(_fetchStock(symbol, url, isWatchlist: true));
    }

    await Future.wait(requests);
    notifyListeners(); // Notify UI to update after fetching latest data
  }

  Future<void> _fetchStock(String symbol, String url, {bool isWatchlist = false}) async {
    if (_cache.containsKey(symbol)) {
      final cachedStock = _cache[symbol]!;
      if (isWatchlist) {
        int index = watchlist.indexWhere((stock) => stock['symbol'] == symbol);
        if (index != -1) {
          watchlist[index] = cachedStock;
        }
      }
      return;
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['c'] == null) return;

        final double price = (data['c'] as num).toDouble();
        final double change = (data['d'] as num).toDouble();
        final double percentChange = (data['dp'] as num).toDouble();

        // Fetch Market Cap and P/E Ratio
        final metricUrl = 'https://finnhub.io/api/v1/stock/metric?symbol=$symbol&metric=all&token=$apiKey';
        final metricResponse = await http.get(Uri.parse(metricUrl));

        double? marketCap;
        double? epsTTM;
        if (metricResponse.statusCode == 200) {
          final metricData = jsonDecode(metricResponse.body);
          marketCap = metricData['metric']['marketCapitalization']?.toDouble();
          epsTTM = metricData['metric']['epsTTM']?.toDouble();
        }

        double? peRatio;
        if (epsTTM != null && epsTTM > 0) {
          peRatio = price / epsTTM;
        }

        final stockData = {
          'symbol': symbol,
          'price': price,
          'change': change > 0
              ? '+$change (${percentChange.toStringAsFixed(2)}%)'
              : '$change (${percentChange.toStringAsFixed(2)}%)',
          'marketCap': marketCap != null ? formatNumber(marketCap) : 'N/A',
          'peRatio': peRatio != null ? peRatio.toStringAsFixed(2) : 'N/A',
        };

        _cache[symbol] = stockData;

        if (!stocks.any((stock) => stock['symbol'] == symbol)) {
          stocks.add(stockData);
        }

        if (isWatchlist) {
          int index = watchlist.indexWhere((stock) => stock['symbol'] == symbol);
          if (index != -1) {
            watchlist[index] = stockData;
          }
        }
      } else {
        debugPrint('API error (${response.statusCode}) for symbol: $symbol');
      }
    } catch (e) {
      debugPrint('Network error: $e');
    }
  }

  // Ensure this triggers when there are no network changes
  void stopLoadingOnError() {
    isLoading = false;
    notifyListeners();
  }

  void filterStocks(String query) {
    if (query.isEmpty) {
      filteredStocks = stocks;
    } else {
      filteredStocks = stocks.where((stock) {
        final stockSymbol = stock['symbol'].toLowerCase();
        final stockName = stockDetails[stock['symbol']]?['name'].toLowerCase() ?? '';
        return stockSymbol.contains(query.toLowerCase()) || stockName.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void selectStock(Map<String, dynamic> stock) {
    selectedStock = stock;
    notifyListeners();
  }

  void showStockDetails(BuildContext context, Map<String, dynamic> stock, Map<String, dynamic> details) {
    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(details['image']),
                        radius: 25,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(stock['symbol'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          Text(details['name'], style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price: \$${stock['price'].toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Market Cap: ${stock['marketCap']}', style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 20,),
                      Text('P/E Ratio: ${stock['peRatio']}', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Override the addToWatchlist and removeFromWatchlist methods to save watchlist
  void addToWatchlist(Map<String, dynamic> stock) {
    if (!watchlist.contains(stock)) {
      watchlist.add(stock);
      saveWatchlist(); // Save watchlist after adding
      notifyListeners();
    }
  }

  void removeFromWatchlist(Map<String, dynamic> stock) {
    watchlist.remove(stock);
    saveWatchlist(); // Save watchlist after removing
    notifyListeners();
  }

  void updateWatchlistWithFetchedData() {
    // Update the watchlist with the latest stock data after fetching
    watchlist = watchlist.map((item) {
      final symbol = item['symbol'];
      return stocks.firstWhere(
            (stock) => stock['symbol'] == symbol,
        orElse: () => {},
      );
    }).where((stock) => stock.isNotEmpty).toList();
    notifyListeners();
  }
}
