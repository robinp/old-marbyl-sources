import flash.Lib;

class Scene extends flash.display.Sprite {

   public var mx : Float;
   public var my : Float;

   public var sw : Float;
   public var sh : Float;

   var since_start : Float;

   public var disabled : Bool;

   function new() {
      super();

      mx = 0.0;
      my = 0.0;

      since_start = 0.0;

      /*
      sw = Lib.current.stage.stageWidth;
      sh = Lib.current.stage.stageHeight;
      */
      sw = sh = 550;

      disabled = false;
   }

   function elapsedTime(dt : Float) {
      since_start += dt;
   }

   function removeSelf() {
      disabled = true;
      SceneManager.instance.removeScene(this);
   }

   public function run(dt : Float) {
      if (disabled)
         return;
      elapsedTime(dt);
   }

   public function onMouseMove(e : flash.events.MouseEvent) {
      mx = e.stageX;
      my = e.stageY;
   }

   public function onKeyUpDown(e : flash.events.KeyboardEvent, down : Bool) {}

}
