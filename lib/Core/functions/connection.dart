import 'package:connectivity/connectivity.dart';

class Connection{
  Future<bool> checkInternetConnection() async{
    ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());

    if(connectivityResult == ConnectivityResult.none){
      return false;
    }
    else{
      return true;
    }
  }
}