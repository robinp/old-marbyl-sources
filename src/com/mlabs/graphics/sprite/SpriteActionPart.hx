package com.mlabs.graphics.sprite;

import flash.media.Sound;

class SpriteActionPart {
   public var sequence(default, null): SpriteSequence;
   public var next(default, null): SpriteActionPart;
   public var loops(default, null): Int;
   public var fps(default, null): Float;
   public var sounds(default, null): Array<SpriteActionPartSound>;

   var next_id: String;

   public function new(sequence: SpriteSequence, next: String, loops: Int, fps: Float) {
      this.sequence = sequence;
      this.next = null;
      this.loops = loops;
      this.fps = fps;
      this.sounds = new Array<SpriteActionPartSound>();

      this.next_id = next;
   }

   public function getNextId(): String {
      return next_id;
   }

   public function setNext(next: SpriteActionPart) {
      this.next = next;
   }

   public function addSound(sound: Sound, delay: Float) {
      sounds.push(new SpriteActionPartSound(sound, delay));
   }
}

