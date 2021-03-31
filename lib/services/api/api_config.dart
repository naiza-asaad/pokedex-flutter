import 'package:dio/dio.dart';

const String baseUrl = 'https://pokeapi.co/api/v2';
const String initialFetchUrl = '$baseUrl/pokemon';
final dio = Dio();
