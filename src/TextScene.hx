import flash.text.TextField;
import com.mlabs.interp.LinearIP;

class TextScene extends Scene {

   var menu_scene : MenuScene;

   var start_ip : LinearIP;

   var finish : Bool;

   public function new(menu_scene : MenuScene, txt : String, isHint = false) {
      super();
      
      finish = false;
      alpha = 0.0;
      start_ip = new LinearIP(0.0, 1.0, 0.5);

      this.menu_scene = menu_scene;
      
      var fmt = new flash.text.TextFormat("GameFont", 18);
      fmt.align = flash.text.TextFormatAlign.JUSTIFY;
            
      var sc_display = new TextField();
      sc_display.embedFonts = true;
      sc_display.defaultTextFormat = fmt;
      sc_display.wordWrap = true;
      sc_display.width = sw * 0.8;
      sc_display.height = sh * 0.8;
      
      sc_display.htmlText = txt;
      
      sc_display.textColor = 0xffffff;
      sc_display.selectable = false;

      var top_y = 100;
      var _h = 350;

      sc_display.x = 0.1 * sw;
      sc_display.y = top_y + 10;

      var s = new flash.display.Shape();
      s.graphics.beginFill(0x000000);
      s.graphics.drawRoundRect(0.05*sw, top_y, 0.9*sw, _h, 15);
      s.graphics.endFill();
      s.alpha = 0.9;
      addChild(s);
   
      addChild(sc_display);

      if (isHint) {
         var b : flash.display.Bitmap = com.mlabs.resource.ResourceManager.instance.get("com.mlabs.resource.InstrImg");
         addChild(b);
         b.x = 210;
         b.y = 225;
      }
   }
   
   override function elapsedTime(dt : Float) {
      super.elapsedTime(dt);
   }

   public function startEnd() {
      start_ip = new LinearIP(alpha, 0.0, 0.25);
      finish = true;
   }

   public override function run(dt : Float) {
      if (start_ip != null) {
         start_ip.elapsedTime(dt);
         alpha = start_ip.getValue();

         if (start_ip.atTarget) {
            start_ip = null;
            
            if (finish) {
               removeSelf();
            }
         }
      }
      
      elapsedTime(dt);
   }
}
