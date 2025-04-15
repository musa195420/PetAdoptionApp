import 'package:hive/hive.dart';
import 'package:petadoption/Services/db_service.dart';
import 'package:petadoption/models/hive_models/api_queue.dart';

class APIQueueRepo implements IHiveService<APIQueue> {
  late Box<APIQueue> _box;

  @override
  Future<void> init() async {
    Hive.registerAdapter(APIQueueAdapter());
    _box = await Hive.openBox<APIQueue>("apiQueue");
  }

   @override
  Future<List<APIQueue>> getAllWithPredicate(bool Function(APIQueue) predicate) async {
    return _box.values.where(predicate).toList();
  }
 
  @override
  Future<List<APIQueue>> search(String searchValue) async {
    return _box.values.where((item) => item.id.toString() == searchValue).toList();
  } 

  @override
  Future<List<APIQueue>> searchAndPaginate(String searchValue, int pageNo, int pageSize) async {
    return _box.values.where((item) => item.id.toString() == searchValue).skip(pageNo * pageSize).take(pageSize).toList();
  } 

  @override
  Future<void> add(APIQueue item) async {
    await _box.add(item);
  }

  @override
  Future<void> addOrUpdate(APIQueue item) async {
    if (_box.values.any((element) => item.id == element.id)) {
      var bar = await getFirst(item.id.toString());
      update(bar?.key, item);
    } else {
      await add(item);
    }
  }

  @override
  Future<void> addOrUpdateRange(List<APIQueue> items) async {
    for (var item in items) {
      if (_box.values.any((element) => item.id == element.id)) {
        var bar = await getFirst(item.id.toString());
        update(bar?.key, item);
      } else {
        await add(item);
      }
    }
  }

  @override
  Future<void> deleteAllAndAdd(APIQueue item) async {
    await _box.clear();
    await _box.add(item);
  }

  @override
  Future<void> deleteAllAndAddRange(List<APIQueue> items) async {
    await _box.clear();
    await _box.addAll(items);
  }

  @override
  Future<void> addRange(List<APIQueue> items) async {
    await _box.addAll(items);
  }

  @override
  Future<APIQueue> get(dynamic key) async {
    return _box.get(key)!; // Make sure to handle null according to your app's needs
  }

  @override
  Future<APIQueue?> getFirst(String id) async {
    for (var element in _box.values) {
      if (element.id.toString()==id) return element;
    }
    return null;
  }

  @override
  Future<APIQueue?> getFirstOrDefault() async {
    if (_box.values.isNotEmpty) {
      return _box.values.first;
    }
    return null;
  }

  @override
  Future<List<APIQueue>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<List<APIQueue>> getAllAndPaginate(int pageNo, int pageSize) async {
    return _box.values.skip(pageNo * pageSize).take(pageSize).toList();
  } 

  @override
  Future<void> update(dynamic key, APIQueue updatedItem) async {
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
    _box = await Hive.openBox<APIQueue>("apiQueue");
  }
}