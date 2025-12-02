// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$jobListViewModelHash() => r'2ef814fd9777de0f9ff7e4ae12fb8e6ad47b26b1';

/// Job list ViewModel
///
/// Copied from [JobListViewModel].
@ProviderFor(JobListViewModel)
final jobListViewModelProvider =
    AutoDisposeNotifierProvider<JobListViewModel, JobListState>.internal(
      JobListViewModel.new,
      name: r'jobListViewModelProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$jobListViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$JobListViewModel = AutoDisposeNotifier<JobListState>;
String _$jobDetailViewModelHash() =>
    r'8d79676db7f835ceb00246cdf00c58d229c9e15e';

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

abstract class _$JobDetailViewModel
    extends BuildlessAutoDisposeNotifier<JobDetailState> {
  late final String jobId;

  JobDetailState build(String jobId);
}

/// Job detail ViewModel
///
/// Copied from [JobDetailViewModel].
@ProviderFor(JobDetailViewModel)
const jobDetailViewModelProvider = JobDetailViewModelFamily();

/// Job detail ViewModel
///
/// Copied from [JobDetailViewModel].
class JobDetailViewModelFamily extends Family<JobDetailState> {
  /// Job detail ViewModel
  ///
  /// Copied from [JobDetailViewModel].
  const JobDetailViewModelFamily();

  /// Job detail ViewModel
  ///
  /// Copied from [JobDetailViewModel].
  JobDetailViewModelProvider call(String jobId) {
    return JobDetailViewModelProvider(jobId);
  }

  @override
  JobDetailViewModelProvider getProviderOverride(
    covariant JobDetailViewModelProvider provider,
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
  String? get name => r'jobDetailViewModelProvider';
}

/// Job detail ViewModel
///
/// Copied from [JobDetailViewModel].
class JobDetailViewModelProvider
    extends
        AutoDisposeNotifierProviderImpl<JobDetailViewModel, JobDetailState> {
  /// Job detail ViewModel
  ///
  /// Copied from [JobDetailViewModel].
  JobDetailViewModelProvider(String jobId)
    : this._internal(
        () => JobDetailViewModel()..jobId = jobId,
        from: jobDetailViewModelProvider,
        name: r'jobDetailViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$jobDetailViewModelHash,
        dependencies: JobDetailViewModelFamily._dependencies,
        allTransitiveDependencies:
            JobDetailViewModelFamily._allTransitiveDependencies,
        jobId: jobId,
      );

  JobDetailViewModelProvider._internal(
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
  JobDetailState runNotifierBuild(covariant JobDetailViewModel notifier) {
    return notifier.build(jobId);
  }

  @override
  Override overrideWith(JobDetailViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: JobDetailViewModelProvider._internal(
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
  AutoDisposeNotifierProviderElement<JobDetailViewModel, JobDetailState>
  createElement() {
    return _JobDetailViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobDetailViewModelProvider && other.jobId == jobId;
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
mixin JobDetailViewModelRef on AutoDisposeNotifierProviderRef<JobDetailState> {
  /// The parameter `jobId` of this provider.
  String get jobId;
}

class _JobDetailViewModelProviderElement
    extends
        AutoDisposeNotifierProviderElement<JobDetailViewModel, JobDetailState>
    with JobDetailViewModelRef {
  _JobDetailViewModelProviderElement(super.provider);

  @override
  String get jobId => (origin as JobDetailViewModelProvider).jobId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
