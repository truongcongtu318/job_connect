// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_rating_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiRatingViewModelHash() => r'17f130f8390f340e9198b8c3ed9e0f7c1ed4fbb9';

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

abstract class _$AiRatingViewModel
    extends BuildlessAutoDisposeNotifier<AiRatingState> {
  late final String applicationId;

  AiRatingState build(String applicationId);
}

/// See also [AiRatingViewModel].
@ProviderFor(AiRatingViewModel)
const aiRatingViewModelProvider = AiRatingViewModelFamily();

/// See also [AiRatingViewModel].
class AiRatingViewModelFamily extends Family<AiRatingState> {
  /// See also [AiRatingViewModel].
  const AiRatingViewModelFamily();

  /// See also [AiRatingViewModel].
  AiRatingViewModelProvider call(String applicationId) {
    return AiRatingViewModelProvider(applicationId);
  }

  @override
  AiRatingViewModelProvider getProviderOverride(
    covariant AiRatingViewModelProvider provider,
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
  String? get name => r'aiRatingViewModelProvider';
}

/// See also [AiRatingViewModel].
class AiRatingViewModelProvider
    extends AutoDisposeNotifierProviderImpl<AiRatingViewModel, AiRatingState> {
  /// See also [AiRatingViewModel].
  AiRatingViewModelProvider(String applicationId)
    : this._internal(
        () => AiRatingViewModel()..applicationId = applicationId,
        from: aiRatingViewModelProvider,
        name: r'aiRatingViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$aiRatingViewModelHash,
        dependencies: AiRatingViewModelFamily._dependencies,
        allTransitiveDependencies:
            AiRatingViewModelFamily._allTransitiveDependencies,
        applicationId: applicationId,
      );

  AiRatingViewModelProvider._internal(
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
  AiRatingState runNotifierBuild(covariant AiRatingViewModel notifier) {
    return notifier.build(applicationId);
  }

  @override
  Override overrideWith(AiRatingViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: AiRatingViewModelProvider._internal(
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
  AutoDisposeNotifierProviderElement<AiRatingViewModel, AiRatingState>
  createElement() {
    return _AiRatingViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AiRatingViewModelProvider &&
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
mixin AiRatingViewModelRef on AutoDisposeNotifierProviderRef<AiRatingState> {
  /// The parameter `applicationId` of this provider.
  String get applicationId;
}

class _AiRatingViewModelProviderElement
    extends AutoDisposeNotifierProviderElement<AiRatingViewModel, AiRatingState>
    with AiRatingViewModelRef {
  _AiRatingViewModelProviderElement(super.provider);

  @override
  String get applicationId =>
      (origin as AiRatingViewModelProvider).applicationId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
