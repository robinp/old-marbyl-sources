package com.mlabs.interp;

interface Interpolator {
   public function setFrom(x : Float) : Void;
   public function setTarget(x : Float, secs : Float = 1.0) : Void;
   public function getValue() : Float;
   public function elapsedTime(dt : Float) : Void;

   public function setEndCallback(cb : Void -> Void) : Void; 
}
