package com.mlabs.graphics.sprite;

class SpriteAction {
   public var parts: Hash<SpriteActionPart>;

   public function new() {
      parts = new Hash<SpriteActionPart>();
   }

   public function addPart(id: String, sequence: SpriteSequence, next: String, loops: Int, fps: Float) {
      parts.set(id, new SpriteActionPart(sequence, next, loops, fps));
   }
}

