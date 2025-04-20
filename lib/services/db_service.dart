import 'dart:async';

abstract class IHiveService<T> {
  Future<void> init();
  Future<List<T>> search(String searchValue);
  Future<List<T>> searchAndPaginate(
      String searchValue, int pageNo, int pageSize);
  Future<void> add(T item);
  Future<void> addOrUpdate(T item);
  Future<void> deleteAllAndAdd(T item);
  Future<void> deleteAllAndAddRange(List<T> items);
  Future<void> addRange(List<T> items);
  Future<void> addOrUpdateRange(List<T> items);
  Future<void> getAllWithPredicate(bool Function(T) predicate);
  Future<T> get(dynamic key);
  Future<T?> getFirst(String id);
  Future<T?> getFirstOrDefault();
  Future<List<T>> getAll();
  Future<List<T>> getAllAndPaginate(int pageNo, int pageSize);
  Future<void> update(dynamic key, T updatedItem);
  Future<void> delete(dynamic key);
  Future<void> deleteAll();
  int get length;
  Future<void> close();
  Future<void> reOpenBox();
}
