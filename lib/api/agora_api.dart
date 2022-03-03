import 'package:dio/dio.dart';
import 'package:omegle_clone/utils/custom_exception.dart';

class AgoraApi {
  final Dio _dio = Dio();

  Future<String> getRtcRoomToken({
    required String uid,
    required String channelName,
  }) async {
    String _cloudFunctionUrl =
        'https://us-central1-avian-display-193502.cloudfunctions.net/getRTCToken?account=$uid&channelName=$channelName';

    try {
      Map<String, dynamic> _dataMap = {
        "context": {"auth": uid},
      };

      Response<Map> _response = await _dio.post<Map>(
        _cloudFunctionUrl,
        data: _dataMap,
      );

      if (_response.data == null) throw CustomException("Data was null");

      if (_response.statusCode == 200) {
        return _response.data!['key'];
      }

      String _message = _response.data!.containsKey('message')
          ? _response.data!['message']
          : 'An unknown error occurred';

      throw CustomException(_message);
    } catch (e) {
      throw CustomException(e.toString());
    }
  }
}
