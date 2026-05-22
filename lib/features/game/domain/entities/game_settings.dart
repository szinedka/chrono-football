class GameSettings {
  const GameSettings({
    this.muted = false,
    this.lcdGreenMode = true,
  });

  final bool muted;
  final bool lcdGreenMode;

  GameSettings copyWith({
    bool? muted,
    bool? lcdGreenMode,
  }) {
    return GameSettings(
      muted: muted ?? this.muted,
      lcdGreenMode: lcdGreenMode ?? this.lcdGreenMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'muted': muted,
      'lcdGreenMode': lcdGreenMode,
    };
  }

  factory GameSettings.fromJson(Map<String, dynamic> json) {
    return GameSettings(
      muted: json['muted'] as bool? ?? false,
      lcdGreenMode: json['lcdGreenMode'] as bool? ?? true,
    );
  }
}
