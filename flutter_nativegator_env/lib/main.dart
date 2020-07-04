import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutternativegatorenv/debug/debug_print.dart';
import 'package:flutternativegatorenv/views/root_widget_page.dart';
import 'package:flutternativegatorenv/routes/application.dart';
import 'package:flutternativegatorenv/routes/routes.dart';

void main() {
  debugErrorWidget();
  var router = Router();
  Routes.configureRoutes(router);
  Application.router = router;
  runApp(RootWidgetPage());
}

