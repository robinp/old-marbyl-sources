package com.mlabs.graphics.sprite;

import flash.media.Sound;

class SpriteActionPartSound {
   public var sound(default, null): Sound;
   public var delay(default, null): Float;

   public function new(sound: Sound, delay: Float) {
      this.sound = sound;
      this.delay = delay;
   }
}

