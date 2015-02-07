import com.mlabs.resource.ResourceManager;

class Diam extends flash.display.Sprite {

   static inline var ANG_MIN = 4;
   static inline var ANG_MAX = 6;

   public var colidx(default, setColidx) : UInt;

   public var alphaIP(default, null) : com.mlabs.interp.LinearIP;

   public var disabled(default, null) : Bool;
   public var dead(default, null) : Bool;

   public var ang : Int;

   var d_bmp : flash.display.Bitmap;

   public function setDead() {
      dead = true;
      disabled = true;
   }

   function setColidx(i : UInt) : UInt {
      colidx = i;
      color = Colors.colors[i];
      return i;
   }

   public var color(default, setColor) : UInt;
   public var intensity(default, setIntensity): Float;

   function setColor(c : UInt) : UInt{
      color = c;
      var cm = new ColorMatrix();
      cm.colorize(color, intensity);
      filters = [cm.filter()];
      return c;
   }

   function setIntensity(i : Float) : Float {
      intensity = i;
      var cm = new ColorMatrix();
      cm.colorize(color, intensity);
      filters = [cm.filter()];
      return i;
   }

   public function elapsedTime(dt : Float) {
      if (!alphaIP.atTarget) {
         alphaIP.elapsedTime(dt);
         alpha = alphaIP.act;
      }
   }

   public function removeSoon() {
      myRemove();
      /*
      disabled = true;
      alphaIP.setTarget(0.0, 0.15);
      alphaIP.setEndCallback(myRemove);
      */
   }

   public function myRemove() {
      setDead();
   }

   function addAsChild(ang : Int) {
      d_bmp = ResourceManager.instance.get("com.mlabs.resource.Diam" + Std.string(ang), true);
      d_bmp.smoothing = true;
      d_bmp.x = -0.5 * d_bmp.width;
      d_bmp.y = -0.5 * d_bmp.height;
      addChild(d_bmp); 
   }

   public function changeShape() {
      removeChild(d_bmp);
      addAsChild(ang);
   }

   public function cycleShape() {
      ang += 1;
      if (ang > ANG_MAX)
         ang = ANG_MIN;
      changeShape();
   }

   public function new(ang : Int) {
      super();

      this.ang = ang;

      alphaIP = new com.mlabs.interp.LinearIP(1.0, 1.0);
      disabled = false;
      dead = false;

      addAsChild(ang);
  }

}
