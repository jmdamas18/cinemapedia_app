import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia_app/infrastructure/repositories/local_storage_repository_impl.dart';
import 'package:cinemapedia_app/infrastructure/datasources/drift_datasource.dart';

final localStorageRepositoryProvider = Provider((ref) {
  return LocalStorageRepositoryImpl(DriftDatasource());
});
