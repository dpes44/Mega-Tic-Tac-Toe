enum BoardSkin {
  classic,
  graphite,
  forest,
  midnight,
  rosewood,
  oceanic,
  ivory,
  ember,
}

extension BoardSkinX on BoardSkin {
  String get label {
    switch (this) {
      case BoardSkin.classic:
        return 'Classic';
      case BoardSkin.graphite:
        return 'Graphite';
      case BoardSkin.forest:
        return 'Forest';
      case BoardSkin.midnight:
        return 'Midnight';
      case BoardSkin.rosewood:
        return 'Rosewood';
      case BoardSkin.oceanic:
        return 'Oceanic';
      case BoardSkin.ivory:
        return 'Ivory';
      case BoardSkin.ember:
        return 'Ember';
    }
  }

  String get description {
    switch (this) {
      case BoardSkin.classic:
        return 'Warm wood board';
      case BoardSkin.graphite:
        return 'Cool slate tones';
      case BoardSkin.forest:
        return 'Earthy green palette';
      case BoardSkin.midnight:
        return 'Dark contrast look';
      case BoardSkin.rosewood:
        return 'Rich walnut tones';
      case BoardSkin.oceanic:
        return 'Calm sea blues';
      case BoardSkin.ivory:
        return 'Clean bright contrast';
      case BoardSkin.ember:
        return 'Burnished copper mood';
    }
  }
}
