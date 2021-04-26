import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:traind_flutter/ws/WSResponse.dart';

class MyHttpClient {
  BuildContext context;
  ProgressDialog pr;

  MyHttpClient({this.context});

  Future<WSResponse> get(String url,
      {dynamic queryParameter = null, bool showProgress = true}) async {
    if (context != null && showProgress) {
      pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr.setMessage('Please wait...');
      pr.show();
    }
    try {
      Response res = await getDio().get(url, queryParameters: queryParameter);
      if (context != null && showProgress && pr != null) {
        pr.hide();
      }
      return WSResponse(true, res.data, "");
    } on DioError catch (e) {
      if (context != null && showProgress && pr != null) {
        pr.hide();
      }
      return WSResponse(false, "", e.message);
    }
  }

  Future<WSResponse> post(String url, dynamic data,
      {bool showProgress = true}) async {
    if (context != null && showProgress) {
      pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr.setMessage('Please wait...');
      pr.show();
    }
    try {
      Response res = await getDio().post(url, data: data);
      if (context != null && showProgress && pr != null) {
        pr.hide();
      }
      return WSResponse(true, res.data, "");
    } on DioError catch (e) {
      if (context != null && showProgress && pr != null) {
        pr.hide();
      }
      return WSResponse(false, "", e.message);
    }
  }

  Future<WSResponse> postFormData(String url, FormData data,
      {bool showProgress = true}) async {
    if (context != null && showProgress) {
      pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr.setMessage('Please wait...');
      pr.show();
    }
    try {
      Response res = await getDio().post(url, data: data);
      if (context != null && showProgress && pr != null) {
        pr.hide();
      }
      return WSResponse(true, res.data, "");
    } on DioError catch (e) {
      if (context != null && showProgress && pr != null) {
        pr.hide();
      }
      return WSResponse(false, "", e.message);
    }
  }

  Future<WSResponse> delete(String url, dynamic data,
      {bool showProgress = true}) async {
    if (context != null && showProgress) {
      pr = new ProgressDialog(context, ProgressDialogType.Normal);
      pr.setMessage('Please wait...');
      pr.show();
    }
    try {
      Response res = await getDio().delete(url, data: data);
      if (context != null && showProgress && pr != null) {
        pr.hide();
      }
      return WSResponse(true, res.data, "");
    } on DioError catch (e) {
      if (context != null && showProgress && pr != null) {
        pr.hide();
      }
      return WSResponse(false, "", e.message);
    }
  }

  Dio getDio() {
    Dio dio = new Dio();
    dio.options.connectTimeout = 30000;
    dio.options.receiveTimeout = 30000;
    return dio;
  }
}
