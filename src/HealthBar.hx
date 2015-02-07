import flash.text.TextField;

import com.mlabs.interp.LinearIP;

class HealthBar extends Bar {
   static var spacing = 5.0;
   static var outer_bevel = 10.0;
   static var inner_bevel = 5.0;
   static var outer_colors = [0x8080ff, 0x0000ff];
   static var inner_colors = [0xff0000, 0xffff00, 0x00ff00];

   var h_text: TextField;

   public var dec_rate: Float;

   public function new(width: Float, height: Float, ?max: Float = 100.0, ?act: Float = 0.0, ?dec_rate: Float = 5.0, ?ip_rate: Float = 10.0) {
      super(width, height, HealthBar.spacing, HealthBar.outer_bevel, HealthBar.inner_bevel, HealthBar.outer_colors, HealthBar.inner_colors, max, act, ip_rate);

      this.dec_rate = dec_rate;

      /*
      h_text = new TextField();

      h_text.antiAliasType = flash.text.AntiAliasType.ADVANCED;
      h_text.autoSize = flash.text.TextFieldAutoSize.CENTER;
      h_text.defaultTextFormat = new flash.text.TextFormat("GameFont", 12, 0x000000, true);
      h_text.embedFonts = true;
      h_text.selectable = false;
      h_text.textColor = 0x000000;
      h_text.text = "/";
      h_text.x = width / 2.0;
      h_text.y = (height - h_text.height) / 2.0;

      addChild(h_text);
      */
   }

   override public function elapsedTime(dt: Float) {
      value -= dec_rate * dt;

      /*
      if (!ipAtTarget) {
         h_text.text = Math.floor(ipValue) + " / " + max;
      }
      */
      
      super.elapsedTime(dt);
   }
}

