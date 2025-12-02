// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant_list_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$applicantListViewModelHash() =>
    r'1eb6f41ed344b8c9d58606d92d75356efe1b9bc7';

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

abstract class _$ApplicantListViewModel
    extends BuildlessAutoDisposeNotifier<ApplicantListState> {
  late final String jobId;

  ApplicantListState build(String jobId);
}

/// Applicant list ViewModel
///
/// Copied from [ApplicantListViewModel].
@ProviderFor(ApplicantListViewModel)
const applicantListViewModelProvider = ApplicantListViewModelFamily();

/// Applicant list ViewModel
///
/// Copied from [ApplicantListViewModel].
class ApplicantListViewModelFamily extends Family<ApplicantListState> {
  /// Applicant list ViewModel
  ///
  /// Copied from [ApplicantListViewModel].
  const ApplicantListViewModelFamily();

  /// Applicant list ViewModel
  ///
  /// Copied from [ApplicantListViewModel].
  ApplicantListViewModelProvider call(String jobId) {
    return ApplicantListViewModelProvider(jobId);
  }

  @override
  ApplicantListViewModelProvider getProviderOverride(
    covariant ApplicantListViewModelProvider provider,
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
  String? get name => r'applicantListViewModelProvider';
}

/// Applicant list ViewModel
///
/// Copied from [ApplicantListViewModel].
class ApplicantListViewModelProvider
    extends
        AutoDisposeNotifierProviderImpl<
          ApplicantListViewModel,
          ApplicantListState
        > {
  /// Applicant list ViewModel
  ///
  /// Copied from [ApplicantListViewModel].
  ApplicantListViewModelProvider(String jobId)
    : this._internal(
        () => ApplicantListViewModel()..jobId = jobId,
        from: applicantListViewModelProvider,
        name: r'applicantListViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$applicantListViewModelHash,
        dependencies: ApplicantListViewModelFamily._dependencies,
        allTransitiveDependencies:
            ApplicantListViewModelFamily._allTransitiveDependencies,
        jobId: jobId,
      );

  ApplicantListViewModelProvider._internal(
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
  ApplicantListState runNotifierBuild(
    covariant ApplicantListViewModel notifier,
  ) {
    return notifier.build(jobId);
  }

  @override
  Override overrideWith(ApplicantListViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ApplicantListViewModelProvider._internal(
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
  AutoDisposeNotifierProviderElement<ApplicantListViewModel, ApplicantListState>
  createElement() {
    return _ApplicantListViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApplicantListViewModelProvider && other.jobId == jobId;
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
mixin ApplicantListViewModelRef
    on AutoDisposeNotifierProviderRef<ApplicantListState> {
  /// The parameter `jobId` of this provider.
  String get jobId;
}

class _ApplicantListViewModelProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          ApplicantListViewModel,
          ApplicantListState
        >
    with ApplicantListViewModelRef {
  _ApplicantListViewModelProviderElement(super.provider);

  @override
  String get jobId => (origin as ApplicantListViewModelProvider).jobId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
