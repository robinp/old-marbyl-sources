package com.mlabs.graphics.sprite;

class SpriteSequence {
   public var tiles(default, null): Array<Int>;
   public var fps(default, null): Float;

   public function new(tiles: Array<Int>, fps: Float) {
      this.tiles = tiles;
      this.fps = fps;
   }
}

