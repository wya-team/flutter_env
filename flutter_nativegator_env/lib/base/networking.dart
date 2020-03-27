import 'dart:io';

import 'package:cache/sharepreferences_until.dart';
import 'package:dio/dio.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

typedef SuccessCallBack = Function(Object data);
typedef FailCallBack = Function(String errorDescription);
typedef ProgressCallback = Function(double progress);

class HttpQuerery {
  static void get(String url,
      {Map<String, dynamic> data,
      Map<String, dynamic> headers,
      SuccessCallBack success,
      FailCallBack error}) async {
    // 数据拼接
    if (data != null && data.isNotEmpty) {
      StringBuffer options = new StringBuffer('?');
      data.forEach((key, value) {
        options.write('${key}=${value}&');
      });
      String optionsStr = options.toString();
      optionsStr = optionsStr.substring(0, optionsStr.length - 1);
      url += optionsStr;
    }

    // 发送get请求
    await _sendRequest(url, 'get', success, headers: headers, error: error);
  }

  static void post(String url,
      {Map<String, dynamic> data,
      Map<String, dynamic> headers,
      SuccessCallBack success,
      FailCallBack error}) async {
    // 发送post请求
    _sendRequest(url, 'post', success,
        data: data, headers: headers, error: error);
  }

  // 请求处理
  static Future _sendRequest(String url, String method, SuccessCallBack success,
      {Map<String, dynamic> data,
      Map<String, dynamic> headers,
      FailCallBack error}) async {
    int _code;
    String _msg;
    var _backData;

    var deviceInfo = DeviceInfoPlugin();
    var platformName = '';
    var platformVersion = '';
    if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      platformName = iosInfo.systemName;
      platformVersion = iosInfo.systemVersion;
      print('iosInfo=====${iosInfo.utsname.machine}===');
    } else if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      platformName = 'android';
      platformVersion = androidInfo.version.release;
      print('androidInfo===$androidInfo====');
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var token = await ShardPreferences.localGet('access_token');

    print('token==$token===');
    try {
      Map<String, dynamic> params = {
        'device_token': '',
        'device_type': 1,
        'timestamp':
            '${((DateTime.now().millisecondsSinceEpoch) / 1000).toInt()}',
      };

      Map<String, dynamic> httpHeader = {
        'version': packageInfo.version,
        'platform': platformName + platformVersion,
      };

      if (token != null) {
        httpHeader['token'] = token;
      }

      if (headers != null) {
        httpHeader.addAll(headers);
      }

      if (data != null) {
        params.addAll(data);
      }
      print('requestHeader===$httpHeader====');
      print('requesParams===$params====');

      // 配置dio请求信息
      Response response;
      BaseOptions option = BaseOptions(
        connectTimeout: 10000, // 服务器链接超时，毫秒
        receiveTimeout: 3000, // 响应流上前后两次接受到数据的间隔，毫秒
        headers: httpHeader, // 添加headers,如需设置统一的headers信息也可在此添加
        contentType: "application/json",
        responseType: ResponseType.plain,
      );
      Dio dio = Dio(option);
      if (method == 'get') {
        response = await dio.get(url);
      } else {
        response = await dio.post(url, data: params);
      }
      print('response===$response====');
      if (response.statusCode != 200) {
        _msg = '网络请求错误,状态码:' + response.statusCode.toString();
        error(_msg);
        return;
      }

      // 返回结果处理
//      Map<String, dynamic> resCallbackMap = response.data;
//      _code = resCallbackMap['code'];
//      _msg = resCallbackMap['msg'];
//      _backData = resCallbackMap['data'];

      success(response.data);
    } catch (exception) {
      error('数据请求错误：' + exception.toString());
    }
  }

  static void download(String url, String path,
      {Map<String, dynamic> params,
      ProgressCallback progress,
      SuccessCallBack success,
      FailCallBack error}) async {
    try {
      Dio dio = Dio();
      Response response = await dio.download(url, path,
          onReceiveProgress: (int count, int total) {
        if (progress != null) {
          progress(count / total);
        }
      }, queryParameters: params);

      print('response.statusCode===${response.statusCode}====');
      print('response.statusMessage===${response.statusMessage}====');
      if (response.statusCode != 200) {
        error('网络请求错误,状态码:' + response.statusCode.toString());
        return;
      } else {
        success(response.data);
      }
    } catch (exception) {
      error('下载失败：' + exception.toString());
    }
  }

  static void upload(String url, List<String> paths,
      {ProgressCallback progress,
      SuccessCallBack success,
      FailCallBack error}) async {
    try {
      Dio dio = Dio();
      List<MultipartFile> files = [];
      for (int i = 0; i < paths.length; i++) {
        String str = paths[i];
        MultipartFile.fromFileSync(str);
      }
      FormData formData = new FormData.fromMap({
        'files': files,
      });
      Response response = await dio.post(url, data: formData,
          onSendProgress: (int count, int total) {
        if (progress != null) {
          progress(count / total);
        }
      });
      print('response.statusCode===${response.statusCode}====');
      print('response.statusMessage===${response.statusMessage}====');
      if (response.statusCode != 200) {
        error('网络请求错误,状态码:' + response.statusCode.toString());
        return;
      } else {
        success(response.data);
      }
    } catch (exception) {
      error('上传失败：' + exception.toString());
    }
  }
}
