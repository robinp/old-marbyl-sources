import flash.events.MouseEvent;
import com.mlabs.interp.LinearIP;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;

class TextButton extends MyButton {

   var tf : TextField;
   var bg_color : UInt;

   var extend : Float;

   var _w : Float;
   var _h : Float;

   public function new(s : String, fnt_size : Int, width = 0.0, height = 0.0,  bg_color : UInt, textColor = 0xffffff, bold = false) {
      this.bg_color = bg_color;
      extend = 1.3;

      _w = width;
      _h = height;

      tf = new TextField();
      tf.embedFonts = true;

      var tfmt = new TextFormat("GameFont", fnt_size);
      tfmt.bold = bold;
      tfmt.align = TextFormatAlign.CENTER;

      tf.defaultTextFormat = tfmt;
      tf.textColor = textColor;
      tf.selectable = false;

      tf.text = s;
      tf.height = extend * tf.textHeight;
      tf.width = extend * tf.textWidth;
      tf.x = -0.5 * tf.width;
      tf.y = -0.5 * tf.height;

      addChild(tf);

      super();
   }

   override function postInit() {
      graphics.beginFill(bg_color);
      
      var w = (_w == 0.0) ? tf.width : _w;
      var h = (_h == 0.0) ? tf.height : _h;

      graphics.drawRoundRect(-0.5*w, -0.5*h, w, h, 15);
      graphics.endFill();
   }

}
