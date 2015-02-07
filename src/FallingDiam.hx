class FallingDiam extends Diam {

   public var speed : Float;

   public function new(ang : Int) {
      super(ang);
   }

   public override function elapsedTime(dt : Float) {
      super.elapsedTime(dt);
      if (!disabled) {
         y += speed * dt;
      }
   }

}
