import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;

class FadeText extends TextField {

   var alpha_ip : com.mlabs.interp.LinearIP;
   public var dead(default, null) : Bool;

   var t_start : Float;
   var t_in : Float;
   var t_hold : Float;
   var t_out : Float;

   public function new(txt : String, t_start : Float, t_in : Float, t_hold : Float, t_out : Float, color : Int = 0xffffff, ?t_fmt : TextFormat) {
      super();

      alpha = 0.0;
      this.t_start = t_start;
      this.t_in = t_in;
      this.t_hold = t_hold;
      this.t_out = t_out;

      dead = false;

      embedFonts = true;
      antiAliasType = flash.text.AntiAliasType.ADVANCED;
      textColor = color;
      
      if (t_fmt == null)
         t_fmt = new TextFormat("GameFont", 24);
      defaultTextFormat = t_fmt;
      
      text = txt;
      width = 450;
      height = 140;
      selectable = false;

      alpha_ip = new com.mlabs.interp.LinearIP(0.0, 0.95, t_in);
      alpha_ip.setEndCallback(atTop);
   }

   public function atTop() {
      alpha_ip.setTarget(1.0, t_hold);
      alpha_ip.setEndCallback(endAtTop);
   }
   
   public function endAtTop() {
      alpha_ip.setTarget(0.0, t_out);
      alpha_ip.setEndCallback(finish);
   }


   public function finish() {
      parent.removeChild(this);
      dead = true;
   }

   public function elapsedTime(dt : Float) {
         t_start -= dt;
         if (t_start <= 0.0) {
            alpha_ip.elapsedTime(dt);
            alpha = alpha_ip.act;
         }
   }



}
