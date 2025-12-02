// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_history_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$applicationHistoryViewModelHash() =>
    r'7b38702549d601c03323a5bbc41b4b4b155d8c75';

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

abstract class _$ApplicationHistoryViewModel
    extends BuildlessAutoDisposeNotifier<ApplicationHistoryState> {
  late final String candidateId;

  ApplicationHistoryState build(String candidateId);
}

/// Application history ViewModel
///
/// Copied from [ApplicationHistoryViewModel].
@ProviderFor(ApplicationHistoryViewModel)
const applicationHistoryViewModelProvider = ApplicationHistoryViewModelFamily();

/// Application history ViewModel
///
/// Copied from [ApplicationHistoryViewModel].
class ApplicationHistoryViewModelFamily
    extends Family<ApplicationHistoryState> {
  /// Application history ViewModel
  ///
  /// Copied from [ApplicationHistoryViewModel].
  const ApplicationHistoryViewModelFamily();

  /// Application history ViewModel
  ///
  /// Copied from [ApplicationHistoryViewModel].
  ApplicationHistoryViewModelProvider call(String candidateId) {
    return ApplicationHistoryViewModelProvider(candidateId);
  }

  @override
  ApplicationHistoryViewModelProvider getProviderOverride(
    covariant ApplicationHistoryViewModelProvider provider,
  ) {
    return call(provider.candidateId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'applicationHistoryViewModelProvider';
}

/// Application history ViewModel
///
/// Copied from [ApplicationHistoryViewModel].
class ApplicationHistoryViewModelProvider
    extends
        AutoDisposeNotifierProviderImpl<
          ApplicationHistoryViewModel,
          ApplicationHistoryState
        > {
  /// Application history ViewModel
  ///
  /// Copied from [ApplicationHistoryViewModel].
  ApplicationHistoryViewModelProvider(String candidateId)
    : this._internal(
        () => ApplicationHistoryViewModel()..candidateId = candidateId,
        from: applicationHistoryViewModelProvider,
        name: r'applicationHistoryViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$applicationHistoryViewModelHash,
        dependencies: ApplicationHistoryViewModelFamily._dependencies,
        allTransitiveDependencies:
            ApplicationHistoryViewModelFamily._allTransitiveDependencies,
        candidateId: candidateId,
      );

  ApplicationHistoryViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.candidateId,
  }) : super.internal();

  final String candidateId;

  @override
  ApplicationHistoryState runNotifierBuild(
    covariant ApplicationHistoryViewModel notifier,
  ) {
    return notifier.build(candidateId);
  }

  @override
  Override overrideWith(ApplicationHistoryViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ApplicationHistoryViewModelProvider._internal(
        () => create()..candidateId = candidateId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        candidateId: candidateId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<
    ApplicationHistoryViewModel,
    ApplicationHistoryState
  >
  createElement() {
    return _ApplicationHistoryViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApplicationHistoryViewModelProvider &&
        other.candidateId == candidateId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, candidateId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ApplicationHistoryViewModelRef
    on AutoDisposeNotifierProviderRef<ApplicationHistoryState> {
  /// The parameter `candidateId` of this provider.
  String get candidateId;
}

class _ApplicationHistoryViewModelProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          ApplicationHistoryViewModel,
          ApplicationHistoryState
        >
    with ApplicationHistoryViewModelRef {
  _ApplicationHistoryViewModelProviderElement(super.provider);

  @override
  String get candidateId =>
      (origin as ApplicationHistoryViewModelProvider).candidateId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
