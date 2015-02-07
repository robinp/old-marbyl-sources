import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;

class Counter extends flash.display.Sprite {

   var tf : TextField;

   var pre : String;
   var post : String;

   var cnt_ip : com.mlabs.interp.LinearIP;
   var rate : Float;

   public var value(default, setValue) : Int;

   function setValue(x : Int) : Int {
      value = x;
      cnt_ip.setTarget(value, rate);
      return x;
   }

   public function new(width : Int, pre = '', post = ' pts', rate=1.0, size=20) {
      super();

      this.pre = pre;
      this.post = post;
      this.rate = rate;

      tf = new TextField();

      tf.embedFonts = true;
      tf.antiAliasType = flash.text.AntiAliasType.ADVANCED;
      
      var t_fmt = new TextFormat("GameFont", size);
      
      t_fmt.align = TextFormatAlign.RIGHT;
      tf.defaultTextFormat = t_fmt;
      
      tf.text = pre + '0' + post;
      tf.width = width;
      tf.height = 70;
      tf.selectable = false;

      addChild(tf);

      cnt_ip = new com.mlabs.interp.LinearIP(0.0, 0.0);
   }

   public function elapsedTime(dt : Float) {
      if (!cnt_ip.atTarget) {
         cnt_ip.elapsedTime(dt);
         var val = Math.floor(cnt_ip.act);
         tf.text = pre + Std.string(val) + post;
      }
   }



}
