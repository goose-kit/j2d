import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:j2d/src/j2d_json_config.dart';

final emitter = DartEmitter();
final formatter = DartFormatter();

class J2DCodeGen {
  J2DCodeGen(this.fileName) {
    buffer = StringBuffer();
  }

  final String fileName;
  late final StringBuffer buffer;
  List<String> classes = [];
  static const header = '''
//  **************************************************************************
//  AUTO GENERATED BY J2D 
//  DO NOT MODIFY BY HAND 👋
//  more info: https://github.com/laiiihz/j2d
//  **************************************************************************
''';

  static String directives(String fileName) {
    final buffer = StringBuffer();
    final dImport =
        Directive.import('package:json_annotation/json_annotation.dart');
    buffer.writeln(dImport.accept(emitter).toString());

    final dPart = Directive.part('$fileName.g.dart');
    buffer.writeln(dPart.accept(emitter).toString());

    return buffer.toString();
  }

  String gen(Map<String, dynamic> data) {
    buffer.writeln(header);
    buffer.writeln(directives(fileName));
    travelMap(data);
    return formatter.format(buffer.toString());
  }

  travelMap(Map<String, dynamic> data) {
    genMap(data);
    for (var entry in data.entries) {
      if (entry.value is Map) {
        travelMap(entry.value);
      } else if (entry.value is List) {
        final item = entry.value as List;
        if (item.isEmpty) continue;
        if (item.first is Map) {
          travelMap(item.first);
        }
      }
    }
  }

  void genMap(Map<String, dynamic> map) {
    final config = JsonConfig.fromMap(map);
    final parseMap = filterMapKeys(map);
    if (classes.contains(config.name)) return;
    classes.add(config.name);
    final result = Class((c) {
      c.name = config.name;
      c.annotations.add(CodeExpression(Code('JsonSerializable()')));
      c.constructors.addAll([
        Constructor((con) {
          con.optionalParameters.addAll(parseMap.entries.map((e) {
            return Parameter((p) {
              p.name = e.key;
              p.toThis = true;
              p.named = true;
              p.required = true;
            });
          }).toList());
        }),
        Constructor((con) {
          con.factory = true;
          con.name = 'fromJson';
          con.requiredParameters.add(Parameter(
            (p) => p
              ..name = 'json'
              ..type = Reference('Map<String,dynamic>'),
          ));
          con.body = Reference('_\$${config.name}FromJson(json)').code;
          con.lambda = true;
        }),
      ]);
      c.methods.add(Method((m) {
        m.name = 'toJson';
        m.returns = refer('Map<String,dynamic>');
        m.body = Reference('_\$${config.name}ToJson(this)').code;
      }));

      c.fields.addAll(parseMap.entries.map((e) {
        return Field((f) {
          f.name = e.key;
          f.modifier = FieldModifier.final$;
          f.type = refer(typeOfEntry(e.value, map['#${e.key}']));
        });
      }).toList());
    });

    buffer.writeln(result.accept(emitter).toString());
  }
}