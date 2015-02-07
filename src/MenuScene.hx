import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.Font;
import flash.geom.Point;
import flash.ui.Keyboard;
import flash.media.Sound;
import flash.media.SoundChannel;

class MenuScene extends Scene {
   var tooltip_mode : Bool;

   var choices : Array<String>;
   var selected : Int;

   var choiceTF : Array<TextField>;

   var baseColor : UInt;
   var selectColor : UInt;

   var transit_to_scene : Scene;

   var _menu_x : Float;
   var _menu_y : Float;
   var _menu_dy : Float;
   var _menu_dx : Float;
   var _menu_lastx : Float;
   var _menu_lasty : Float;

   var menu_click : Sound;
   var bgm : Sound;
   var bgm_ch : SoundChannel;

   var _mtf : TextField;

   var mouse_hit : Bool;

   var do_transit : Bool;
   public var transit_ip(default, null) : com.mlabs.interp.LinearIP;

   public function new(choices : Array<String>, selectColor = 0xff0000, baseColor = 0x000000) {
      super();
      this.choices = choices;

      tooltip_mode = false;

      _menu_x = 40;
      _menu_y = 210;
      _menu_dx = 0;
      _menu_dy = 40;

      mouse_hit = false;

      transit_to_scene = null;
      transit_ip = new com.mlabs.interp.LinearIP(0.0, 0.0, 0.25);

      this.baseColor = baseColor;
      this.selectColor = selectColor;

      selected = -1;

      createTFs(choices);
      updateSelection();

      /* Music trace */
      /*
      _mtf = new TextField();
      _mtf.x = 100;
      _mtf.y = 10;
      _mtf.width = 200;
      _mtf.height = 30;
      _mtf.multiline = true;
      _mtf.defaultTextFormat = new TextFormat("Arial", 15);
      addChild(_mtf);
      */

      flash.Lib.current.stage.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, onMouseDown);
   }

   function onSelection() {}

   override function removeSelf() {
      super.removeSelf();
      flash.Lib.current.stage.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, onMouseDown);
   }

   public override function run(dt : Float) {
      elapsedTime(dt);

      if (!transit_ip.atTarget) {
         transit_ip.elapsedTime(dt);
         y = transit_ip.act;
      }

      if (transit_to_scene != null) {
         do_transit = true;
         transit_ip.setTarget(sh+10.0, 0.5);
         SceneManager.instance.addScene(transit_to_scene, true, 0);
         transit_to_scene = null;
      }
   }

   override function elapsedTime(dt) {
      super.elapsedTime(dt);

      /* BGM test */ 
      if (bgm == null) {
         //bgm = new BGMusic();
         //bgm_ch = bgm.play();
      }
   }

   public override function onKeyUpDown(e : flash.events.KeyboardEvent, down : Bool) {      
      if (e.keyCode == Keyboard.LEFT) {}
      else if (e.keyCode == Keyboard.RIGHT) {}
      else if (down && e.keyCode == Keyboard.UP) {
         selected--;
         if (selected < 0)
            selected = choiceTF.length-1;
         updateSelection();
         // menu_click.play();
      }
      else if (down && e.keyCode == Keyboard.DOWN) {
         selected++;
         if (selected == choiceTF.length)
            selected = 0;
         updateSelection();
         // menu_click.play();
      }
      else if (down && e.keyCode == Keyboard.ENTER) {
         onSelection();
      }
      
   }

   function initMenuPos() {
      _menu_lastx = _menu_x;
      _menu_lasty = _menu_y;
   }

   function getNextMenuPos() : Point {
      var p = new Point();
      p.x = _menu_lastx;
      p.y = _menu_lasty;

      _menu_lastx += _menu_dx;
      _menu_lasty += _menu_dy;

      return p;
   }
 
   static var cols = [
         0xaa0000,
         0xaa0022,
         0xaa0044,
         0x880044,
         0x440088,
         0x440088,
      ];


   function getTF(i : Int, str : String, ?p : Point) : TextField {
      var tf = new TextField();
      
      tf.embedFonts = true;
      tf.antiAliasType = flash.text.AntiAliasType.ADVANCED;
      tf.defaultTextFormat = new TextFormat("GameFont", 30);
      tf.text = str;
      tf.width = 400;
      tf.height = 50;
      tf.selectable = false;
      
      tf.textColor = i == selected ? selectColor : cols[i];
      // trace("textcol:" + tf.textColor);

      if (p == null)
         p = getNextMenuPos();

      tf.x = p.x;
      tf.y = p.y;

      var f = new flash.filters.BevelFilter();
      f.blurX = 2.0;
      f.blurY = 2.0;
      f.distance = 2.0;
      f.type = flash.filters.BitmapFilterType.OUTER;
      tf.filters = [f];

      return tf;
   }

   function createTFs(choices : Array<String>) {
      choiceTF = new Array<TextField>();

      initMenuPos();

      var i = 0;
      for (str in choices) {

         var tf = getTF(i, str);
   
         choiceTF.push(tf);
         addChild(tf);
         i++;
      }
   }

   public override function onMouseMove(e : flash.events.MouseEvent) {
      super.onMouseMove(e);

      mouse_hit = false;

      if (tooltip_mode)
         return;
      
      for (i in 0...choiceTF.length) {
         var tf = choiceTF[i];
         if (tf.hitTestPoint(mx, my, false)) {   
            selected = i;
            updateSelection();
            mouse_hit = true;
         }
      }
      if (!mouse_hit) {
         selected = -1;
         updateSelection();
      }
   }

   function onMouseDown(e : flash.events.MouseEvent) {
      if (mouse_hit) {
         onSelection();
      }
   }

   function updateSelection() {
      
      var i = 0;
      while (i < choiceTF.length) {
         var tf = choiceTF[i];
         tf.textColor = i == selected ? selectColor : cols[i];
         tf.defaultTextFormat.bold = i == selected;
         //trace('tfxy ' + tf.x + " " + tf.y);
         i++;
      }
   }

}
