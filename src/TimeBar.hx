import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;


class TimeBar extends flash.display.Sprite {

   // ff991d

   public var time_left(default, null) : Float;
   var orig_time : Float;
   
   static inline var line_w = 362.0;
      
   var time_tf : TextField;

   var lastpop : Int;

   public function new(lcfg : LevelConfig) {
      super();

      // time_left = lcfg.game_time;
      // orig_time = lcfg.game_time;
      orig_time = 0.0;
      time_left = 0.0;
      lastpop = 100;

      /*
   
      var d_bmp : flash.display.Bitmap = com.mlabs.resource.ResourceManager.instance.get("com.mlabs.resource.TimeBar", true);
      d_bmp.smoothing = true;
      
      d_bmp.y = -0.5 * d_bmp.height;

      */

      time_tf = new TextField();
      time_tf.embedFonts = true;
      time_tf.textColor = 0x000000;
      
      var fmt = new TextFormat("GameFont", 22);
      fmt.align = TextFormatAlign.LEFT;
      time_tf.defaultTextFormat = fmt;
      
      time_tf.selectable = false;
      time_tf.text = 'XX:XX';
      time_tf.width = time_tf.textWidth;
      time_tf.height = time_tf.textHeight;

      /*
      addChild(d_bmp); 
      */
      addChild(time_tf);
   }

   public function restart() {
      // time_left = orig_time;
      time_left = 0.0;
      lastpop = 100;
   }

   function refreshTime() {
      var mins = Math.floor(time_left / 60.0 );
      var secs = Math.floor(time_left - 60.0 * mins);

      time_tf.text = Std.string(mins) + ':' + StringTools.lpad(Std.string(secs), '0', 2);

   
      var col : UInt;
      /*
      if (time_left < 10.0) {
         time_tf.textColor = 0xffffff;

         if (lastpop > Math.floor(time_left)) {
            lastpop = Math.floor(time_left);
            if (lastpop == 0)
               com.mlabs.resource.ResourceManager.instance.get("com.mlabs.resource.GongSfx", false).play();
            else
               com.mlabs.resource.ResourceManager.instance.get("com.mlabs.resource.PopSfx", false).play();

         }         
      }
      */

      /*
      var w = time_left / orig_time * line_w;
      graphics.clear();
      graphics.beginFill(col);
      graphics.drawRect(7, -5, w, 13);
      graphics.endFill();
      */
   }

   public function elapsedTime(dt : Float) {
      // time_left -= dt;
      time_left += dt;
      if (time_left < 0.0)
         time_left = 0.0;

      refreshTime();
   }


}
