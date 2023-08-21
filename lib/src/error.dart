import 'package:flutter/services.dart';

class UnregisteredIdException extends PlatformException {
  UnregisteredIdException({
    super.code = 'BAD_REQUEST',
    super.message = 'requestId is not registered',
  });
}

class ServerError extends PlatformException {
  ServerError({
    super.code = 'ADCIO_SERVER_ERROR',
  });
}
