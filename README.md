# J2D

json 

## Getting Started

###  add dependencies to `pubspec.yaml`
```yaml
dependencies:
  json_annotation: 

dev_dependencies:
  j2d: 
  build_runner: 
  json_serializable: 

```

or run command
```shell
dart pub add j2d 
```


### write your first `some.json` file 
```json
    {
        "$name": "PersonInfo",
        "prefix": "jack",
        "suffix": "bob",
        "price": 123.00,
        "height": 170,
        "#height": "int",
        "detail": {
            "$name": "PersonInfoDetail",
            "path": "foo.bar",
            "schema":"foo"
        }
    }
```

### start generate
```
flutter pub run build_runner build
dart run build_runner build
```

* result will generate to `some.json.dart`, and auto generate to `some.json.g.dart` by `json_serializable`
```dart
//  **************************************************************************
//  AUTO GENERATED BY J2D
//  DO NOT MODIFY BY HAND 👋
//  more info: https://github.com/laiiihz/j2d
//  **************************************************************************

import 'package:json_annotation/json_annotation.dart';
part 'a.json.g.dart';

@JsonSerializable()
class PersonInfo {
  PersonInfo(
      {required this.prefix,
      required this.suffix,
      required this.price,
      required this.height,
      required this.detail});

  factory PersonInfo.fromJson(Map<String, dynamic> json) =>
      _$PersonInfoFromJson(json);

  final String prefix;

  final String suffix;

  final num price;

  final int height;

  final PersonInfoDetail detail;

  Map<String, dynamic> toJson() => _$PersonInfoToJson(this);
}

@JsonSerializable()
class PersonInfoDetail {
  PersonInfoDetail({required this.path, required this.schema});

  factory PersonInfoDetail.fromJson(Map<String, dynamic> json) =>
      _$PersonInfoDetailFromJson(json);

  final String path;

  final String schema;

  Map<String, dynamic> toJson() => _$PersonInfoDetailToJson(this);
}
```


## Configurations

### json file

* `$name` tag will generate the name of class.
  example:
    ```json
    {
      "$name": "SomeModel",
      "someKey": "someValue"
    }
    ```
  and generate:
    ```dart
    class SomeModel {}
    ```
* `#key` tag to specific type of the key.
  
  example: 
    ```json
      {
        "date": "2022-02-02", 
        "#date": "DateTime"
      }
    ```
  and generate:
    ```dart
      final DateTime date;
    ```