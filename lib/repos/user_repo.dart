
import 'package:hive/hive.dart';
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/services/db_service.dart';

class UserRepo implements IHiveService<User> {
  late Box<User> _box;

  @override
  Future<void> init() async {
    Hive.registerAdapter(UserAdapter());
    _box = await Hive.openBox<User>("users");
  }

   @override
  Future<List<User>> getAllWithPredicate(bool Function(User) predicate) async {
    return _box.values.where(predicate).toList();
  }
 
  @override
  Future<List<User>> search(String searchValue) async {
    return _box.values.where((item) => item.email == searchValue).toList();
  } 

  @override
  Future<List<User>> searchAndPaginate(String searchValue, int pageNo, int pageSize) async {
    return _box.values.where((item) => item.email == searchValue).skip(pageNo * pageSize).take(pageSize).toList();
  } 

  @override
  Future<void> add(User item) async {
    await _box.add(item);
  }

  @override
  Future<void> addOrUpdate(User item) async {
    if (_box.values.any((element) => item.userId == element.userId)) {
      var bar = await getFirst(item.userId.toString());
      update(bar?.key, item);
    } else {
      await add(item);
    }
  }

  @override
  Future<void> addOrUpdateRange(List<User> items) async {
    for (var item in items) {
      if (_box.values.any((element) => item.userId == element.userId)) {
        var bar = await getFirst(item.userId.toString());
        update(bar?.key, item);
      } else {
        await add(item);
      }
    }
  }

  @override
  Future<void> deleteAllAndAdd(User item) async {
    await _box.clear();
    await _box.add(item);
  }

  @override
  Future<void> deleteAllAndAddRange(List<User> items) async {
    await _box.clear();
    await _box.addAll(items);
  }

  @override
  Future<void> addRange(List<User> items) async {
    await _box.addAll(items);
  }

  @override
  Future<User> get(dynamic key) async {
    return _box.get(key)!; // Make sure to handle null according to your app's needs
  }

  @override
  Future<User?> getFirst(String id) async {
    for (var element in _box.values) {
      if (element.userId==id) return element;
    }
    return null;
  }

  @override
  Future<User?> getFirstOrDefault() async {
    if (_box.values.isNotEmpty) {
      return _box.values.first;
    }
    return null;
  }

  @override
  Future<List<User>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<List<User>> getAllAndPaginate(int pageNo, int pageSize) async {
    return _box.values.skip(pageNo * pageSize).take(pageSize).toList();
  } 

  @override
  Future<void> update(dynamic key, User updatedItem) async {
    await _box.put(key, updatedItem);
  }

  @override
  Future<void> delete(dynamic key) async {
    await _box.delete(key);
  }

  @override
  Future<void> deleteAll() async {
    await _box.clear();
  }

  @override
  int get length => _box.length;

  @override
  Future<void> close() async {
    if(_box.isOpen){
      await _box.close();
    }
  }

  @override
  Future<void> reOpenBox() async {
    if(_box.isOpen){
      await close();
    }
    _box = await Hive.openBox<User>("users");
  }
}