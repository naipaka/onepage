import 'package:in_app_review/in_app_review.dart';
import 'package:mockito/annotations.dart';
import 'package:prefs_client/prefs_client.dart';

@GenerateNiceMocks([
  MockSpec<PrefsClient>(),
  MockSpec<InAppReview>(),
])
void main() {}
