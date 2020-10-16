/*
 * this class for help you to make an http request with some specific details.
 * that is two methods the fist post and the secound get .
 * 
 * when you want to make a request you must add an available cookie to get an http response successfully{
 *    got to (../Resources/string.dart) then add you available cookie in it.
 * 
 * 
 *    after the request test , when you get a response like this : {
 *          <html> <body> <script type="text/javascript" src="/aes.js"></script> <script> function toNumbers(d){var e=[];d.replace(/(..)/g,function(d){e.push(parseInt(d,16))});return e}function toHex(){for(var d=[],d=1==arguments.length&&arguments[0].constructor==Array?arguments[0]:arguments,e="",f=0;f<d.length;f++)e+=(16>d[f]?"0":"")+d[f].toString(16);return e.toLowerCase()}var a=toNumbers("f655ba9d09a112d4968c63579db590b4"),b=toNumbers("98344c2eee86c3994890592585b49f80"),c=toNumbers("cd8380080bc04d28a62c7f5c29b6c342");document.cookie="__test="+toHex(slowAES.decrypt(c,2,a,b))+"; expires=Thu, 31-Dec-37 23:55:55 GMT; path=/"; location.href="http://mymission.epizy.com/api/register?api_password=xuqhBhc8KkajZbhHoViT&display_name=Monsef%20OT&email=abdoumanou5@gmail.com&password=monsef&i=1"; </script><noscript>This site requires Javascript to work, please enable Javascript in your browser or use a browser with Javascript support</noscript> </body> </html>
 *    } , it means your cookie not available and you must to update your cookie in the (string.dart).
 * 
 * 
 *    if you don't know how to get an available cookie from the browser check this link :   https://support.google.com/chrome/answer/95647?co=GENIE.Platform%3DDesktop&hl=en.
 *    befor get the cookie from chrome settings you must go to mymission api link : http://mymission.epizy.com/ after that you can get you cookie with add 'mymission.epizy.com/' in cookies search field
 *    NOTE: the name of the helpful cookie which we use it is '__test' .
 *      
 * }
 */

import 'dart:convert' as convert;

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:mymission_full_version/Resources/string.dart';

class ApiProvider extends ControllerMVC {

  /*
   *this function for make a post request , 
   it take an api name and it's a required with its variables like in the example,
   it take also the bosy of the post it's very important to make a post request {
    var body = {
      "api_password": "xuqhBhc8KkajZbhHoViT",
      "email": "abdoumanou5@gmail.com",
      "password": "monsef",
    };
   }, 


   tow other variables you can push them into the function (authorization as a bool value when you want to authenticate with token ) 
   and (token as string).

   for example (this post statement for login with email and password and retrun a response containe an authenticate token) {
      var response = await ApiProvider().post('login' , body);
   } 
   */
  post(String apiName , Map<String , dynamic> body , [bool authorization = false , String token]) async {
    final response = await http.post(
      apiURL + apiName,
      headers: (authorization) ? <String, String>{
        'Accept': "application/json",
        'Authorization': "Bearer $token",
      } : <String, String>{
        'Accept': "application/json",
      },
      body: body,
    );

    if(response.statusCode == 200){
      Map<String , dynamic> result = convert.jsonDecode(response.body);
      return result;
    }
  }


  /*
   *this function for make a get request , 
   it take an api name and it's a required with its variables like in the example ,
   it take also tow other variables (authorization as a bool value when you want to authenticate with token ) 
   and (token as string), you can transform the json data to an object like this :{

    var response = await ApiProvider().get('searchForUser?api_password=xuqhBhc8KkajZbhHoViT&user_id=1' , true , token);
  
    var json = response['user'];

    User user = new User.fromJson(json);  

   }   
   */
  get(String apiName , [bool authorization = false , String token]) async {
    http.Response response = await http.get(
      apiURL + apiName , 
      headers: (authorization) ? <String, String>{
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      } : <String, String>{
        'Accept': "application/json",
      },
    );
    if(response.statusCode == 200){
      Map<String , dynamic> result = convert.jsonDecode(response.body);
      return result;
    }
    else{
      return "Something error : ${response.statusCode}";
    }
  }
}
