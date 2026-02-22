import 'package:astrology_app/views/base/custom_snackBar.dart';
import 'package:get/get.dart';

class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false}) async {

    if (response.statusCode != 200 && response.statusCode != 201) {
      if (response.statusCode == 401) {

        showCustomSnackBar('Unauthorized! Please login again.', getXSnackBar: getXSnackBar);
      } else if (response.statusCode == 400) {

        String errorMessage = 'Validation failed';

        if (response.body != null) {

          if (response.body['error'] != null) {
            errorMessage = response.body['error'];
          }

          if (response.body['details'] != null) {
            var details = response.body['details'];
            if (details is Map && details.isNotEmpty) {
              var firstError = details.values.first;
              if (firstError is List && firstError.isNotEmpty) {
                errorMessage = firstError.first;
              }
            }
          }
        }

        showCustomSnackBar(errorMessage, getXSnackBar: getXSnackBar);
      } else {

        String message = response.statusText ?? 'Something went wrong';

        if (response.body != null && response.body['error'] != null) {
          message = response.body['error'];
        }

        showCustomSnackBar(message, getXSnackBar: getXSnackBar);
      }
    }
  }
}