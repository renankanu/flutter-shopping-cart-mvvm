import 'dart:io';

import 'package:dio/dio.dart';

class NetworkException implements Exception {
  NetworkException.fromDioError(DioException dioException) {
    statusCode = dioException.response?.statusCode;

    switch (dioException.type) {
      case DioExceptionType.cancel:
        message = 'A requisição foi cancelada';
        break;
      case DioExceptionType.connectionTimeout:
        message =
            'Tempo limite de conexão esgotado. Verifique sua internet e tente novamente';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'O servidor está demorando para responder. Tente novamente';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Tempo limite para envio de dados esgotado. Tente novamente';
        break;
      case DioExceptionType.connectionError:
        if (dioException.error.runtimeType == SocketException) {
          message = 'Verifique sua conexão com a internet';
          break;
        } else {
          message =
              'Não foi possível conectar ao servidor. Tente novamente em alguns instantes';
          break;
        }
      case DioExceptionType.badCertificate:
        message = 'Problema de certificado de segurança';
        break;
      case DioExceptionType.badResponse:
        message = 'Erro na resposta do servidor';
        break;
      case DioExceptionType.unknown:
        message = 'Ocorreu um erro inesperado. Tente novamente';
        break;
    }
  }

  late final String message;
  late final int? statusCode;
}
