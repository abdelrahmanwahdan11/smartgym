class FeatureFlags {
  FeatureFlags({
    required this.communities,
    required this.buddyMatch,
    required this.miniLive,
  });

  final bool communities;
  final bool buddyMatch;
  final bool miniLive;

  FeatureFlags copyWith({
    bool? communities,
    bool? buddyMatch,
    bool? miniLive,
  }) {
    return FeatureFlags(
      communities: communities ?? this.communities,
      buddyMatch: buddyMatch ?? this.buddyMatch,
      miniLive: miniLive ?? this.miniLive,
    );
  }

  Map<String, dynamic> toMap() => {
        'communities': communities,
        'buddy_match': buddyMatch,
        'mini_live': miniLive,
      };

  factory FeatureFlags.fromMap(Map<String, dynamic>? map) {
    return FeatureFlags(
      communities: (map?['communities'] as bool?) ?? true,
      buddyMatch: (map?['buddy_match'] as bool?) ?? true,
      miniLive: (map?['mini_live'] as bool?) ?? true,
    );
  }

  static FeatureFlags defaults() => FeatureFlags(
        communities: true,
        buddyMatch: true,
        miniLive: true,
      );
}
