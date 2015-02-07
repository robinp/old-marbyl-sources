class Actor extends flash.display.Sprite, implements TimeReceiver {
   
   public function new() {
      super();

      var t = new TimcsymSpr();

      t.x = -t.width / 2;
      t.y = -t.height / 2;

      addChild(t);

      speed = 300.0;
      sumT = 0.0;
   }

   var direction : Dir;
   var leftPress : Bool;
   var rightPress : Bool;

   var speed : Float;

   var sumT : Float;

   public function elapsedTime(dt : Float) {
      
      sumT += dt;

      if (leftPress)
         direction = Dir.Left;
      else if (rightPress)
         direction = Dir.Right;
      else
         direction = Dir.None;

      switch (direction) {
         case Dir.Left:
            x -= dt * speed;
         case Dir.Right:
            x += dt * speed;
      }
   }

   public function goLeft(b) { leftPress = b; }
   public function goRight(b) { rightPress = b; }
}
