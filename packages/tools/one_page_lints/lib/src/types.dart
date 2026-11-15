import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

final _dartUi = Uri.parse('dart:ui');

/// The packages of the Flutter framework. The Material and Cupertino libraries
/// moved out of package:flutter into their own packages.
const _flutterPackages = {'flutter', 'material_ui', 'cupertino_ui'};

/// Whether [element] is the class [name] declared in the Flutter framework.
bool isFlutterClass(Element? element, String name) =>
    element is InterfaceElement &&
    element.name == name &&
    _flutterPackages.contains(packageNameOf(element.library.uri));

/// Whether [type] is the class [name] declared in the Flutter framework.
bool isFlutterType(DartType? type, String name) =>
    isFlutterClass(type?.element, name);

/// Whether [type] is the class [name] of the Flutter framework or one of its
/// subtypes.
bool isFlutterSubtype(DartType? type, String name) =>
    type is InterfaceType &&
    [type, ...type.allSupertypes].any((t) => isFlutterType(t, name));

/// Whether [type] is a widget.
bool isWidgetType(DartType? type) => isFlutterSubtype(type, 'Widget');

/// Whether [type] is a color: `Color` of `dart:ui` or one of its subtypes.
bool isColorType(DartType? type) =>
    type is InterfaceType &&
    [type, ...type.allSupertypes].any(
      (t) => t.element.name == 'Color' && t.element.library.uri == _dartUi,
    );

/// The name of the package of a library at [uri], or null when [uri] is not a
/// `package:` URI.
String? packageNameOf(Uri uri) =>
    uri.isScheme('package') ? uri.pathSegments.first : null;
