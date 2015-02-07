import flash.events.MouseEvent;
import com.mlabs.interp.LinearIP;

class MyButton extends flash.display.Sprite {

   var alpha_ip : LinearIP;
   public var fadeout_over : Float;
   public var clk : Bool;

   public function new() {
      super();

      clk = false;
      buttonMode = true;
      mouseChildren = false;

      fadeout_over = 0.75;
      alpha_ip = new LinearIP(1.0, 1.0, 0.01);

      addEventListener(MouseEvent.CLICK, clicked);
      addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
      addEventListener(MouseEvent.MOUSE_OUT, mouseOut);

      postInit();
   }

   function postInit() {
      // override
   }

   public function elapsedTime(dt : Float) {
      alpha_ip.elapsedTime(dt);
      alpha = alpha_ip.act;
   }


   public function clicked(e : MouseEvent) {
      clk = true;
   }

   public function mouseOver(e : MouseEvent) {
      alpha_ip.setTarget(fadeout_over, 0.2);
   }

   public function mouseOut(e : MouseEvent) {
      alpha_ip.setTarget(1.0, 0.2);
   }

}
