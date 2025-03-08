// Mocks generated by Mockito 5.4.5 from annotations
// in db_client/test/utils/mock.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i8;
import 'dart:ffi' as _i5;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;
import 'package:sqlite3/src/database.dart' as _i7;
import 'package:sqlite3/src/ffi/api.dart' as _i2;
import 'package:sqlite3/src/functions.dart' as _i10;
import 'package:sqlite3/src/result_set.dart' as _i9;
import 'package:sqlite3/src/sqlite3.dart' as _i3;
import 'package:sqlite3/src/vfs.dart' as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDatabase_0 extends _i1.SmartFake implements _i2.Database {
  _FakeDatabase_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePreparedStatement_1 extends _i1.SmartFake
    implements _i2.PreparedStatement {
  _FakePreparedStatement_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Sqlite3].
///
/// See the documentation for Mockito's code generation for more information.
class MockSqlite3 extends _i1.Mock implements _i2.Sqlite3 {
  @override
  set tempDirectory(String? _tempDirectory) => super.noSuchMethod(
        Invocation.setter(
          #tempDirectory,
          _tempDirectory,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i3.Version get version => (super.noSuchMethod(
        Invocation.getter(#version),
        returnValue: _i4.dummyValue<_i3.Version>(
          this,
          Invocation.getter(#version),
        ),
        returnValueForMissingStub: _i4.dummyValue<_i3.Version>(
          this,
          Invocation.getter(#version),
        ),
      ) as _i3.Version);

  @override
  _i2.Database open(
    String? filename, {
    String? vfs,
    _i3.OpenMode? mode = _i3.OpenMode.readWriteCreate,
    bool? uri = false,
    bool? mutex,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #open,
          [filename],
          {
            #vfs: vfs,
            #mode: mode,
            #uri: uri,
            #mutex: mutex,
          },
        ),
        returnValue: _FakeDatabase_0(
          this,
          Invocation.method(
            #open,
            [filename],
            {
              #vfs: vfs,
              #mode: mode,
              #uri: uri,
              #mutex: mutex,
            },
          ),
        ),
        returnValueForMissingStub: _FakeDatabase_0(
          this,
          Invocation.method(
            #open,
            [filename],
            {
              #vfs: vfs,
              #mode: mode,
              #uri: uri,
              #mutex: mutex,
            },
          ),
        ),
      ) as _i2.Database);

  @override
  _i2.Database fromPointer(_i5.Pointer<void>? database) => (super.noSuchMethod(
        Invocation.method(
          #fromPointer,
          [database],
        ),
        returnValue: _FakeDatabase_0(
          this,
          Invocation.method(
            #fromPointer,
            [database],
          ),
        ),
        returnValueForMissingStub: _FakeDatabase_0(
          this,
          Invocation.method(
            #fromPointer,
            [database],
          ),
        ),
      ) as _i2.Database);

  @override
  _i2.Database openInMemory({String? vfs}) => (super.noSuchMethod(
        Invocation.method(
          #openInMemory,
          [],
          {#vfs: vfs},
        ),
        returnValue: _FakeDatabase_0(
          this,
          Invocation.method(
            #openInMemory,
            [],
            {#vfs: vfs},
          ),
        ),
        returnValueForMissingStub: _FakeDatabase_0(
          this,
          Invocation.method(
            #openInMemory,
            [],
            {#vfs: vfs},
          ),
        ),
      ) as _i2.Database);

  @override
  _i2.Database copyIntoMemory(_i2.Database? restoreFrom) => (super.noSuchMethod(
        Invocation.method(
          #copyIntoMemory,
          [restoreFrom],
        ),
        returnValue: _FakeDatabase_0(
          this,
          Invocation.method(
            #copyIntoMemory,
            [restoreFrom],
          ),
        ),
        returnValueForMissingStub: _FakeDatabase_0(
          this,
          Invocation.method(
            #copyIntoMemory,
            [restoreFrom],
          ),
        ),
      ) as _i2.Database);

  @override
  void ensureExtensionLoaded(_i2.SqliteExtension? extension) =>
      super.noSuchMethod(
        Invocation.method(
          #ensureExtensionLoaded,
          [extension],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void registerVirtualFileSystem(
    _i6.VirtualFileSystem? vfs, {
    bool? makeDefault = false,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #registerVirtualFileSystem,
          [vfs],
          {#makeDefault: makeDefault},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void unregisterVirtualFileSystem(_i6.VirtualFileSystem? vfs) =>
      super.noSuchMethod(
        Invocation.method(
          #unregisterVirtualFileSystem,
          [vfs],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [Database].
///
/// See the documentation for Mockito's code generation for more information.
class MockDatabase extends _i1.Mock implements _i2.Database {
  @override
  _i5.Pointer<void> get handle => (super.noSuchMethod(
        Invocation.getter(#handle),
        returnValue: _i4.dummyValue<_i5.Pointer<void>>(
          this,
          Invocation.getter(#handle),
        ),
        returnValueForMissingStub: _i4.dummyValue<_i5.Pointer<void>>(
          this,
          Invocation.getter(#handle),
        ),
      ) as _i5.Pointer<void>);

  @override
  int get userVersion => (super.noSuchMethod(
        Invocation.getter(#userVersion),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  set userVersion(int? _userVersion) => super.noSuchMethod(
        Invocation.setter(
          #userVersion,
          _userVersion,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i7.DatabaseConfig get config => (super.noSuchMethod(
        Invocation.getter(#config),
        returnValue: _i4.dummyValue<_i7.DatabaseConfig>(
          this,
          Invocation.getter(#config),
        ),
        returnValueForMissingStub: _i4.dummyValue<_i7.DatabaseConfig>(
          this,
          Invocation.getter(#config),
        ),
      ) as _i7.DatabaseConfig);

  @override
  int get lastInsertRowId => (super.noSuchMethod(
        Invocation.getter(#lastInsertRowId),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  int get updatedRows => (super.noSuchMethod(
        Invocation.getter(#updatedRows),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  _i8.Stream<_i7.SqliteUpdate> get updates => (super.noSuchMethod(
        Invocation.getter(#updates),
        returnValue: _i8.Stream<_i7.SqliteUpdate>.empty(),
        returnValueForMissingStub: _i8.Stream<_i7.SqliteUpdate>.empty(),
      ) as _i8.Stream<_i7.SqliteUpdate>);

  @override
  bool get autocommit => (super.noSuchMethod(
        Invocation.getter(#autocommit),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i2.PreparedStatement prepare(
    String? sql, {
    bool? persistent = false,
    bool? vtab = true,
    bool? checkNoTail = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #prepare,
          [sql],
          {
            #persistent: persistent,
            #vtab: vtab,
            #checkNoTail: checkNoTail,
          },
        ),
        returnValue: _FakePreparedStatement_1(
          this,
          Invocation.method(
            #prepare,
            [sql],
            {
              #persistent: persistent,
              #vtab: vtab,
              #checkNoTail: checkNoTail,
            },
          ),
        ),
        returnValueForMissingStub: _FakePreparedStatement_1(
          this,
          Invocation.method(
            #prepare,
            [sql],
            {
              #persistent: persistent,
              #vtab: vtab,
              #checkNoTail: checkNoTail,
            },
          ),
        ),
      ) as _i2.PreparedStatement);

  @override
  List<_i2.PreparedStatement> prepareMultiple(
    String? sql, {
    bool? persistent = false,
    bool? vtab = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #prepareMultiple,
          [sql],
          {
            #persistent: persistent,
            #vtab: vtab,
          },
        ),
        returnValue: <_i2.PreparedStatement>[],
        returnValueForMissingStub: <_i2.PreparedStatement>[],
      ) as List<_i2.PreparedStatement>);

  @override
  _i8.Stream<double> backup(
    _i2.Database? toDatabase, {
    int? nPage = 5,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #backup,
          [toDatabase],
          {#nPage: nPage},
        ),
        returnValue: _i8.Stream<double>.empty(),
        returnValueForMissingStub: _i8.Stream<double>.empty(),
      ) as _i8.Stream<double>);

  @override
  int getUpdatedRows() => (super.noSuchMethod(
        Invocation.method(
          #getUpdatedRows,
          [],
        ),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  void execute(
    String? sql, [
    List<Object?>? parameters = const [],
  ]) =>
      super.noSuchMethod(
        Invocation.method(
          #execute,
          [
            sql,
            parameters,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i9.ResultSet select(
    String? sql, [
    List<Object?>? parameters = const [],
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #select,
          [
            sql,
            parameters,
          ],
        ),
        returnValue: _i4.dummyValue<_i9.ResultSet>(
          this,
          Invocation.method(
            #select,
            [
              sql,
              parameters,
            ],
          ),
        ),
        returnValueForMissingStub: _i4.dummyValue<_i9.ResultSet>(
          this,
          Invocation.method(
            #select,
            [
              sql,
              parameters,
            ],
          ),
        ),
      ) as _i9.ResultSet);

  @override
  void createCollation({
    required String? name,
    required _i10.CollatingFunction? function,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #createCollation,
          [],
          {
            #name: name,
            #function: function,
          },
        ),
        returnValueForMissingStub: null,
      );

  @override
  void createFunction({
    required String? functionName,
    required _i10.ScalarFunction? function,
    _i10.AllowedArgumentCount? argumentCount =
        const _i10.AllowedArgumentCount.any(),
    bool? deterministic = false,
    bool? directOnly = true,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #createFunction,
          [],
          {
            #functionName: functionName,
            #function: function,
            #argumentCount: argumentCount,
            #deterministic: deterministic,
            #directOnly: directOnly,
          },
        ),
        returnValueForMissingStub: null,
      );

  @override
  void createAggregateFunction<V>({
    required String? functionName,
    required _i10.AggregateFunction<V>? function,
    _i10.AllowedArgumentCount? argumentCount =
        const _i10.AllowedArgumentCount.any(),
    bool? deterministic = false,
    bool? directOnly = true,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #createAggregateFunction,
          [],
          {
            #functionName: functionName,
            #function: function,
            #argumentCount: argumentCount,
            #deterministic: deterministic,
            #directOnly: directOnly,
          },
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
