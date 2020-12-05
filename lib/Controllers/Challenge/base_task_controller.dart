import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:mymission_full_version/Models/Challenge/base_task.dart';
import 'package:mymission_full_version/Models/User/user.dart';
import 'package:mymission_full_version/Request/api_provider.dart';
import 'package:mymission_full_version/Resources/string.dart';

class BaseTaskController extends ControllerMVC{



  Future<bool> createBaseTask(User user , BaseTask baseTask) async {
    var body = {
      "api_password" : api_password,
      "title" : baseTask.title,
      "session_id" : baseTask.session_id,
    };

    var response = await ApiProvider().post(createABaseTask , body , true , user.token);

    if(response != null && response['creating'] == true){
      return true;
    }

    return false;
  }

  Future<List<BaseTask>> getTheSessionBaseTasks(User user , int sessionId) async {
    
    var response = await ApiProvider().get('$getABaseTasks?api_password=$api_password&session_id=$sessionId' , true , user.token);

    List<BaseTask> baseTasks = new List();

    for(int index = 0 ; index < response['base_tasks'].length ; index++){
      baseTasks.add(BaseTask.fromJson(response['base_tasks'][index]));
    }

    if(baseTasks.isNotEmpty){
      return baseTasks;
    }
  }

  Future<BaseTask> updateBaseTask(User user, BaseTask baseTask) async {
    var body = {
      "api_password" : api_password,
      "id" : baseTask.id,
      "points" : baseTask.points,
    };

    var response = await ApiProvider().post(updateBaseTaskPoints, body , true ,user.token );

    BaseTask newBaseTask = BaseTask.fromJson(response['baseTask']);

    if(newBaseTask.id == baseTask.id){
      return newBaseTask;
    }
  }

  Future<bool> deleteSessionBaseTasks(User user , int sessionId) async {
    var body = {
      "api_password" : api_password,
      "session_id" : sessionId,
    };

    var response = await ApiProvider().post(deleteBaseTasks, body , true ,user.token );


    if(response['deleting']){
      return true;
    }

    return false;
  }
}