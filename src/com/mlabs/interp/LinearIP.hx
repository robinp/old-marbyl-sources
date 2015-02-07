package com.mlabs.interp;

class LinearIP implements Interpolator {

   public var act(default, null) : Float;
   var inc_per_sec : Float;
   var target : Float;

   var end_callback : Void -> Void;

   var fun : Float -> Float -> Float;

   public var atTarget(default, null) : Bool;

   public function new(act = 0.0, target = 1.0, secs = 1.0) {
      this.act = act;
      this.target = target;
      inc_per_sec = (target - act) / secs;
      fun = inc_per_sec > 0.0 ? Math.min : Math.max;
      atTarget = false;
   }

   public function setEndCallback(cb : Void -> Void) {
      end_callback = cb;
   }

   public function setFrom(x : Float) {
      act = x;   
   }

   public function setTarget(x : Float, secs : Float = 1.0) {
      target = x;
      if (secs > 0.0) {
         inc_per_sec = (target - act) / secs;
      } else {
         if (target > act)
            inc_per_sec = -secs;
         else
            inc_per_sec = secs;
      }
      fun = inc_per_sec > 0.0 ? Math.min : Math.max;
      atTarget = false;
   }

   public function getValue() : Float {
      return act;
   }

   public function elapsedTime(dt : Float) {
      act = fun(target, act + inc_per_sec*dt);

      if (Math.abs(target - act) < 0.0001) {
      	act = target;
         atTarget = true;
         if (end_callback != null) { 
         	var ec = end_callback;
            end_callback = null;
            ec();
         }
      }
   }
}
