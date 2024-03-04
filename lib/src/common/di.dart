import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_dictionary/src/data/data_source/local_data_source.dart';
import 'package:your_dictionary/src/data/data_source/remote_data_source.dart';
import 'package:your_dictionary/src/data/network/app_api.dart';
import 'package:your_dictionary/src/data/repository/repository_impl.dart';
import 'package:your_dictionary/src/domain/repository/repository.dart';

import '../data/network/network_info.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  // shared prefs instance
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  instance
      .registerLazySingleton<AppServiceClient>(() => AppServiceClientImpl());

  // local data source
  instance.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(instance()),
  );
  instance.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(instance()),
  );
  // network info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(), instance()));
}
