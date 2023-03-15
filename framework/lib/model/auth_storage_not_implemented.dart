import 'account.dart';
import 'auth_storage.dart';

class AuthStorageImpl extends AuthStorage {
  AuthStorageImpl() : super.newInstance();

  @override
  Future<Account?> getActiveAccount() {
    throw UnimplementedError();
  }

  @override
  Future<void> setActiveAccount(Account? account) {
    throw UnimplementedError();
  }

  @override
  Future<void> addAccount(Account account) {
    throw UnimplementedError();
  }

  @override
  Future<List<Account>> getAccounts() {
    throw UnimplementedError();
  }
}
