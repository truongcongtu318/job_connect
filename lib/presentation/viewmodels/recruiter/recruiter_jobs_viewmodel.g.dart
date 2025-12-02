// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruiter_jobs_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recruiterJobsViewModelHash() =>
    r'61dc1fc9bf4755a43f0e5ecf2e75bf01750fc767';

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

abstract class _$RecruiterJobsViewModel
    extends BuildlessAutoDisposeNotifier<RecruiterJobsState> {
  late final String recruiterId;

  RecruiterJobsState build(String recruiterId);
}

/// Recruiter jobs ViewModel
///
/// Copied from [RecruiterJobsViewModel].
@ProviderFor(RecruiterJobsViewModel)
const recruiterJobsViewModelProvider = RecruiterJobsViewModelFamily();

/// Recruiter jobs ViewModel
///
/// Copied from [RecruiterJobsViewModel].
class RecruiterJobsViewModelFamily extends Family<RecruiterJobsState> {
  /// Recruiter jobs ViewModel
  ///
  /// Copied from [RecruiterJobsViewModel].
  const RecruiterJobsViewModelFamily();

  /// Recruiter jobs ViewModel
  ///
  /// Copied from [RecruiterJobsViewModel].
  RecruiterJobsViewModelProvider call(String recruiterId) {
    return RecruiterJobsViewModelProvider(recruiterId);
  }

  @override
  RecruiterJobsViewModelProvider getProviderOverride(
    covariant RecruiterJobsViewModelProvider provider,
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
  String? get name => r'recruiterJobsViewModelProvider';
}

/// Recruiter jobs ViewModel
///
/// Copied from [RecruiterJobsViewModel].
class RecruiterJobsViewModelProvider
    extends
        AutoDisposeNotifierProviderImpl<
          RecruiterJobsViewModel,
          RecruiterJobsState
        > {
  /// Recruiter jobs ViewModel
  ///
  /// Copied from [RecruiterJobsViewModel].
  RecruiterJobsViewModelProvider(String recruiterId)
    : this._internal(
        () => RecruiterJobsViewModel()..recruiterId = recruiterId,
        from: recruiterJobsViewModelProvider,
        name: r'recruiterJobsViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$recruiterJobsViewModelHash,
        dependencies: RecruiterJobsViewModelFamily._dependencies,
        allTransitiveDependencies:
            RecruiterJobsViewModelFamily._allTransitiveDependencies,
        recruiterId: recruiterId,
      );

  RecruiterJobsViewModelProvider._internal(
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
  RecruiterJobsState runNotifierBuild(
    covariant RecruiterJobsViewModel notifier,
  ) {
    return notifier.build(recruiterId);
  }

  @override
  Override overrideWith(RecruiterJobsViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: RecruiterJobsViewModelProvider._internal(
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
  AutoDisposeNotifierProviderElement<RecruiterJobsViewModel, RecruiterJobsState>
  createElement() {
    return _RecruiterJobsViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecruiterJobsViewModelProvider &&
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
mixin RecruiterJobsViewModelRef
    on AutoDisposeNotifierProviderRef<RecruiterJobsState> {
  /// The parameter `recruiterId` of this provider.
  String get recruiterId;
}

class _RecruiterJobsViewModelProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          RecruiterJobsViewModel,
          RecruiterJobsState
        >
    with RecruiterJobsViewModelRef {
  _RecruiterJobsViewModelProviderElement(super.provider);

  @override
  String get recruiterId =>
      (origin as RecruiterJobsViewModelProvider).recruiterId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
