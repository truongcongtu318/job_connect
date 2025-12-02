// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant_detail_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$applicantDetailViewModelHash() =>
    r'4102a445d84575597d3dad49fd76e0e3dd89174c';

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

abstract class _$ApplicantDetailViewModel
    extends BuildlessAutoDisposeNotifier<ApplicantDetailState> {
  late final String applicationId;

  ApplicantDetailState build(String applicationId);
}

/// See also [ApplicantDetailViewModel].
@ProviderFor(ApplicantDetailViewModel)
const applicantDetailViewModelProvider = ApplicantDetailViewModelFamily();

/// See also [ApplicantDetailViewModel].
class ApplicantDetailViewModelFamily extends Family<ApplicantDetailState> {
  /// See also [ApplicantDetailViewModel].
  const ApplicantDetailViewModelFamily();

  /// See also [ApplicantDetailViewModel].
  ApplicantDetailViewModelProvider call(String applicationId) {
    return ApplicantDetailViewModelProvider(applicationId);
  }

  @override
  ApplicantDetailViewModelProvider getProviderOverride(
    covariant ApplicantDetailViewModelProvider provider,
  ) {
    return call(provider.applicationId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'applicantDetailViewModelProvider';
}

/// See also [ApplicantDetailViewModel].
class ApplicantDetailViewModelProvider
    extends
        AutoDisposeNotifierProviderImpl<
          ApplicantDetailViewModel,
          ApplicantDetailState
        > {
  /// See also [ApplicantDetailViewModel].
  ApplicantDetailViewModelProvider(String applicationId)
    : this._internal(
        () => ApplicantDetailViewModel()..applicationId = applicationId,
        from: applicantDetailViewModelProvider,
        name: r'applicantDetailViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$applicantDetailViewModelHash,
        dependencies: ApplicantDetailViewModelFamily._dependencies,
        allTransitiveDependencies:
            ApplicantDetailViewModelFamily._allTransitiveDependencies,
        applicationId: applicationId,
      );

  ApplicantDetailViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.applicationId,
  }) : super.internal();

  final String applicationId;

  @override
  ApplicantDetailState runNotifierBuild(
    covariant ApplicantDetailViewModel notifier,
  ) {
    return notifier.build(applicationId);
  }

  @override
  Override overrideWith(ApplicantDetailViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ApplicantDetailViewModelProvider._internal(
        () => create()..applicationId = applicationId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        applicationId: applicationId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<
    ApplicantDetailViewModel,
    ApplicantDetailState
  >
  createElement() {
    return _ApplicantDetailViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApplicantDetailViewModelProvider &&
        other.applicationId == applicationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, applicationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ApplicantDetailViewModelRef
    on AutoDisposeNotifierProviderRef<ApplicantDetailState> {
  /// The parameter `applicationId` of this provider.
  String get applicationId;
}

class _ApplicantDetailViewModelProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          ApplicantDetailViewModel,
          ApplicantDetailState
        >
    with ApplicantDetailViewModelRef {
  _ApplicantDetailViewModelProviderElement(super.provider);

  @override
  String get applicationId =>
      (origin as ApplicantDetailViewModelProvider).applicationId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
