import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD', 'BRL', 'CAD', 'CNY', 'EUR', 'GBP', 'HKD', 'IDR', 'ILS', 'INR', 'JPY',
  'MXN', 'NOK', 'NZD', 'PLN', 'RON', 'RUB', 'SEK', 'SGD', 'USD', 'ZAR'
];

const List<String> cryptoList = ['bitcoin', 'ethereum', 'litecoin'];

class CoinData {
  Future<Map<String, String>> getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    String requestURL = 'https://api.coingecko.com/api/v3/simple/price?ids=${cryptoList.join(',')}&vs_currencies=$selectedCurrency';
    http.Response response = await http.get(Uri.parse(requestURL));

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      print("API Response: $decodedData"); 
      for (String crypto in cryptoList) {
       
        if (decodedData[crypto] != null && decodedData[crypto][selectedCurrency] != null) {
          double lastPrice = (decodedData[crypto][selectedCurrency] as num).toDouble();
          cryptoPrices[crypto] = lastPrice.toStringAsFixed(2);
        } else {
          print('Missing data for $crypto in $selectedCurrency'); 
          cryptoPrices[crypto] = 'Data not available';
        }
      }
    } else {
      print(response.statusCode);
      throw 'Problem with the get request';
    }
    return cryptoPrices;
  }
}