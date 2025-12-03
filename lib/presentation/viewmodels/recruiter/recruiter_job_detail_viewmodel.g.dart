// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruiter_job_detail_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recruiterJobDetailViewModelHash() =>
    r'873e2913cd3629eb9b96c11ac67194ee6e9e06f8';

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

abstract class _$RecruiterJobDetailViewModel
    extends BuildlessAutoDisposeNotifier<RecruiterJobDetailState> {
  late final String jobId;

  RecruiterJobDetailState build(String jobId);
}

/// See also [RecruiterJobDetailViewModel].
@ProviderFor(RecruiterJobDetailViewModel)
const recruiterJobDetailViewModelProvider = RecruiterJobDetailViewModelFamily();

/// See also [RecruiterJobDetailViewModel].
class RecruiterJobDetailViewModelFamily
    extends Family<RecruiterJobDetailState> {
  /// See also [RecruiterJobDetailViewModel].
  const RecruiterJobDetailViewModelFamily();

  /// See also [RecruiterJobDetailViewModel].
  RecruiterJobDetailViewModelProvider call(String jobId) {
    return RecruiterJobDetailViewModelProvider(jobId);
  }

  @override
  RecruiterJobDetailViewModelProvider getProviderOverride(
    covariant RecruiterJobDetailViewModelProvider provider,
  ) {
    return call(provider.jobId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recruiterJobDetailViewModelProvider';
}

/// See also [RecruiterJobDetailViewModel].
class RecruiterJobDetailViewModelProvider
    extends
        AutoDisposeNotifierProviderImpl<
          RecruiterJobDetailViewModel,
          RecruiterJobDetailState
        > {
  /// See also [RecruiterJobDetailViewModel].
  RecruiterJobDetailViewModelProvider(String jobId)
    : this._internal(
        () => RecruiterJobDetailViewModel()..jobId = jobId,
        from: recruiterJobDetailViewModelProvider,
        name: r'recruiterJobDetailViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$recruiterJobDetailViewModelHash,
        dependencies: RecruiterJobDetailViewModelFamily._dependencies,
        allTransitiveDependencies:
            RecruiterJobDetailViewModelFamily._allTransitiveDependencies,
        jobId: jobId,
      );

  RecruiterJobDetailViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.jobId,
  }) : super.internal();

  final String jobId;

  @override
  RecruiterJobDetailState runNotifierBuild(
    covariant RecruiterJobDetailViewModel notifier,
  ) {
    return notifier.build(jobId);
  }

  @override
  Override overrideWith(RecruiterJobDetailViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: RecruiterJobDetailViewModelProvider._internal(
        () => create()..jobId = jobId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        jobId: jobId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<
    RecruiterJobDetailViewModel,
    RecruiterJobDetailState
  >
  createElement() {
    return _RecruiterJobDetailViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecruiterJobDetailViewModelProvider && other.jobId == jobId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, jobId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecruiterJobDetailViewModelRef
    on AutoDisposeNotifierProviderRef<RecruiterJobDetailState> {
  /// The parameter `jobId` of this provider.
  String get jobId;
}

class _RecruiterJobDetailViewModelProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          RecruiterJobDetailViewModel,
          RecruiterJobDetailState
        >
    with RecruiterJobDetailViewModelRef {
  _RecruiterJobDetailViewModelProviderElement(super.provider);

  @override
  String get jobId => (origin as RecruiterJobDetailViewModelProvider).jobId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
