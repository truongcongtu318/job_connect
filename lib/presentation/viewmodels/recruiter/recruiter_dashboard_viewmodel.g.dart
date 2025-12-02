// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruiter_dashboard_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recruiterDashboardViewModelHash() =>
    r'4ba8d167718e07f0b308cef9b80a5bcb4ebd3e53';

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

abstract class _$RecruiterDashboardViewModel
    extends BuildlessAutoDisposeNotifier<RecruiterDashboardState> {
  late final String recruiterId;

  RecruiterDashboardState build(String recruiterId);
}

/// Recruiter dashboard ViewModel
///
/// Copied from [RecruiterDashboardViewModel].
@ProviderFor(RecruiterDashboardViewModel)
const recruiterDashboardViewModelProvider = RecruiterDashboardViewModelFamily();

/// Recruiter dashboard ViewModel
///
/// Copied from [RecruiterDashboardViewModel].
class RecruiterDashboardViewModelFamily
    extends Family<RecruiterDashboardState> {
  /// Recruiter dashboard ViewModel
  ///
  /// Copied from [RecruiterDashboardViewModel].
  const RecruiterDashboardViewModelFamily();

  /// Recruiter dashboard ViewModel
  ///
  /// Copied from [RecruiterDashboardViewModel].
  RecruiterDashboardViewModelProvider call(String recruiterId) {
    return RecruiterDashboardViewModelProvider(recruiterId);
  }

  @override
  RecruiterDashboardViewModelProvider getProviderOverride(
    covariant RecruiterDashboardViewModelProvider provider,
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
  String? get name => r'recruiterDashboardViewModelProvider';
}

/// Recruiter dashboard ViewModel
///
/// Copied from [RecruiterDashboardViewModel].
class RecruiterDashboardViewModelProvider
    extends
        AutoDisposeNotifierProviderImpl<
          RecruiterDashboardViewModel,
          RecruiterDashboardState
        > {
  /// Recruiter dashboard ViewModel
  ///
  /// Copied from [RecruiterDashboardViewModel].
  RecruiterDashboardViewModelProvider(String recruiterId)
    : this._internal(
        () => RecruiterDashboardViewModel()..recruiterId = recruiterId,
        from: recruiterDashboardViewModelProvider,
        name: r'recruiterDashboardViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$recruiterDashboardViewModelHash,
        dependencies: RecruiterDashboardViewModelFamily._dependencies,
        allTransitiveDependencies:
            RecruiterDashboardViewModelFamily._allTransitiveDependencies,
        recruiterId: recruiterId,
      );

  RecruiterDashboardViewModelProvider._internal(
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
  RecruiterDashboardState runNotifierBuild(
    covariant RecruiterDashboardViewModel notifier,
  ) {
    return notifier.build(recruiterId);
  }

  @override
  Override overrideWith(RecruiterDashboardViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: RecruiterDashboardViewModelProvider._internal(
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
  AutoDisposeNotifierProviderElement<
    RecruiterDashboardViewModel,
    RecruiterDashboardState
  >
  createElement() {
    return _RecruiterDashboardViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecruiterDashboardViewModelProvider &&
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
mixin RecruiterDashboardViewModelRef
    on AutoDisposeNotifierProviderRef<RecruiterDashboardState> {
  /// The parameter `recruiterId` of this provider.
  String get recruiterId;
}

class _RecruiterDashboardViewModelProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          RecruiterDashboardViewModel,
          RecruiterDashboardState
        >
    with RecruiterDashboardViewModelRef {
  _RecruiterDashboardViewModelProviderElement(super.provider);

  @override
  String get recruiterId =>
      (origin as RecruiterDashboardViewModelProvider).recruiterId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
