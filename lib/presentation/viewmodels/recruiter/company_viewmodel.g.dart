// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$companyViewModelHash() => r'58cd390b82287409d81b38325b794c8a7826d81d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$CompanyViewModel
    extends BuildlessAutoDisposeNotifier<CompanyState> {
  late final String recruiterId;

  CompanyState build(String recruiterId);
}

/// Company ViewModel
///
/// Copied from [CompanyViewModel].
@ProviderFor(CompanyViewModel)
const companyViewModelProvider = CompanyViewModelFamily();

/// Company ViewModel
///
/// Copied from [CompanyViewModel].
class CompanyViewModelFamily extends Family<CompanyState> {
  /// Company ViewModel
  ///
  /// Copied from [CompanyViewModel].
  const CompanyViewModelFamily();

  /// Company ViewModel
  ///
  /// Copied from [CompanyViewModel].
  CompanyViewModelProvider call(String recruiterId) {
    return CompanyViewModelProvider(recruiterId);
  }

  @override
  CompanyViewModelProvider getProviderOverride(
    covariant CompanyViewModelProvider provider,
  ) {
    return call(provider.recruiterId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'companyViewModelProvider';
}

/// Company ViewModel
///
/// Copied from [CompanyViewModel].
class CompanyViewModelProvider
    extends AutoDisposeNotifierProviderImpl<CompanyViewModel, CompanyState> {
  /// Company ViewModel
  ///
  /// Copied from [CompanyViewModel].
  CompanyViewModelProvider(String recruiterId)
    : this._internal(
        () => CompanyViewModel()..recruiterId = recruiterId,
        from: companyViewModelProvider,
        name: r'companyViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$companyViewModelHash,
        dependencies: CompanyViewModelFamily._dependencies,
        allTransitiveDependencies:
            CompanyViewModelFamily._allTransitiveDependencies,
        recruiterId: recruiterId,
      );

  CompanyViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.recruiterId,
  }) : super.internal();

  final String recruiterId;

  @override
  CompanyState runNotifierBuild(covariant CompanyViewModel notifier) {
    return notifier.build(recruiterId);
  }

  @override
  Override overrideWith(CompanyViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: CompanyViewModelProvider._internal(
        () => create()..recruiterId = recruiterId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        recruiterId: recruiterId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<CompanyViewModel, CompanyState>
  createElement() {
    return _CompanyViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompanyViewModelProvider &&
        other.recruiterId == recruiterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, recruiterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CompanyViewModelRef on AutoDisposeNotifierProviderRef<CompanyState> {
  /// The parameter `recruiterId` of this provider.
  String get recruiterId;
}

class _CompanyViewModelProviderElement
    extends AutoDisposeNotifierProviderElement<CompanyViewModel, CompanyState>
    with CompanyViewModelRef {
  _CompanyViewModelProviderElement(super.provider);

  @override
  String get recruiterId => (origin as CompanyViewModelProvider).recruiterId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
