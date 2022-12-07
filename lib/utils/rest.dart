import 'package:demo_todos_flutter/models/add_todo.dart';
import 'package:demo_todos_flutter/models/todo.dart';
import 'package:demo_todos_flutter/models/update_todo.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'rest.g.dart';

@RestApi(baseUrl: "https://todos.st.zeent.tech/api")
abstract class Rest {

  static Rest instance = Rest(
    Dio()
    ..options.headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    }
    ..options.connectTimeout = 1000
  );

  factory Rest(Dio dio, {String baseUrl}) = _Rest;

  @GET("/todos")
  Future<List<Todo>> all();

  @GET("/todos/{id}")
  Future<Todo> byId(@Path("id") int id);

  @POST("/todos")
  Future<void> create(@Body() AddTodo todo);

  @PATCH("/todos/{id}")
  Future<void> update(@Path("id") int id, @Body() UpdateTodo todo);

  @DELETE("/todos/{id}")
  Future<void> delete(@Path("id") int id);
}