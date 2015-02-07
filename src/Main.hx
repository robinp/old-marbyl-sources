import flash.Lib;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

class Main
{
   static var _mochiads_game_id : String = "fa57f09ba55e8b5f";

   #if GJ
   public static var GJ : GameJacketAS3;
   #end

   public static var isFett: Bool;
   static inline var FC1 = "3862633157";
   static inline var FC2 = "7770973684";
   
   static var fettApi: ShHighScores;

   public static function main() {
      #if GJ
      GJ = new GameJacketAS3();
      GJ.setVariables(Lib.current.loaderInfo);
      GJ.addEventListener("GameJacketPass", secOK);
      GJ.addEventListener("GameJacketFail", secError);
      Lib.current.addChild(GJ);
      #else
      trace("Main");
      var m = new Main();
      #end
   }

   #if GJ
   static function secOK(e : flash.events.Event) : Void {
      new Main();
   }

   static function secError(e  : flash.events.Event) : Void {
      Lib.current.graphics.beginFill(0xff0000);
      Lib.current.graphics.drawRect(10, 10, 50, 50);
      Lib.current.graphics.endFill(); 
   }
   #end

   var scm : SceneManager;
   
   var lastFrame : Float;

   var fake_loop : FakeLoop;

   function new() {
      scm = null;
      Lib.current.addEventListener(Event.ENTER_FRAME, game_loop);
   }
      
   function onMouseMove(e : MouseEvent) {
      for (sc in scm.scene_list)
         sc.onMouseMove(e);
   }

   function onKeyUpDown(e : KeyboardEvent, down : Bool) {
      for (sc in scm.scene_list)
         sc.onKeyUpDown(e, down);
   }
   
   function onKeyDown(e : KeyboardEvent) { onKeyUpDown(e, true); }
   function onKeyUp(e : KeyboardEvent) { onKeyUpDown(e, false); }
 
   static function getHostUrl() : String {
      var parts = flash.Lib.current.loaderInfo.url.split('://');
      var protoChar = parts[0].charAt(0);

      switch (protoChar) {
         case 'h': return parts[1];
         case 'f': return "localhost";
         default : return parts[1];
      }
   }

   static function getHostDomain() : String {
      return getHostUrl().split('/')[0];
   }

   static function ldrParam(pname: String): String {
      var ldr = flash.Lib.current.loaderInfo.loader;
      var wrapper: Dynamic;
      wrapper = if (ldr == null)
         flash.Lib.current;
      else
         ldr.parent;
      var val = Reflect.field(wrapper.loaderInfo.parameters, pname);
      trace("loader param " + pname + " is: " + val);
      return val;
   }

   public static function fettScore(sc: Int): Bool {
      if (isFett && fettApi != null) {
         trace("fett sent");
         fettApi.send(Std.string(sc), function (s: String) {
            trace("fettscore: " + s);
         });
         return true;
      }
      else
         trace("fett api not available");

      return false;
   }

   function allowOnly(allow : Array<String>) : Bool {
      var dom = getHostDomain();
      
      for (s in allow)
         if (dom.indexOf(s) != -1)
            return true;
     
      return false;
   }

   function checkFett() {
      isFett = getHostDomain().indexOf("fettspielen.de") != -1 || getHostDomain().indexOf("bificomp2") != -1;

      if (isFett) {
         trace("fettspielen");
         fettApi = new ShHighScores(
            FC1, FC2,
            ldrParam("host"),
            ldrParam("shss"),
            ldrParam("shsaurl"),
            ldrParam("shrn")
         );
         trace("fettApi: " + fettApi);
      }
      else 
         trace("not fett url");
   }

   function loaded() {
      var totalBytes = flash.Lib.current.loaderInfo.bytesTotal;
      var actBytes = flash.Lib.current.loaderInfo.bytesLoaded;
      return totalBytes == actBytes;
   }

   function initScene() {
      checkFett();

      scm = SceneManager.instance;
      scm.addScene(new MainMenuScene());
      
      MochiBot.track(flash.Lib.current, "9d7a0edb");
      mochi.MochiServices.connect("fa57f09ba55e8b5f", flash.Lib.current);
      mindjolt.MJ.instance.dummy();

      Lib.current.graphics.beginFill(0xaaaaaa);
      Lib.current.graphics.drawRect(0, 0, scm.main_scene.sw, scm.main_scene.sh);
      Lib.current.graphics.endFill(); 
 
      /* Start background music */
      fake_loop = BGMLoop.instance;
      fake_loop.start(1.0);

      lastFrame = Lib.getTimer();

      Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
      Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
   }

   function game_loop(e : Event) {
      
      if (!loaded())
         return;

      var act = Lib.getTimer();
      var dt = act - lastFrame;
      lastFrame = act;

      var _dt = dt * 0.001;

      while (_dt > 0.0) {
         if (_dt > 0.03) {
            dt = 0.03;
            _dt -= 0.03;
         }
         else {
            dt = _dt;
            _dt = 0.0;
         }

         if (scm == null)
            initScene();
         
         /* Kepp BGM playing */
         fake_loop.elapsedTime(dt);

         /* Run scenes */
         scm.run(dt);
      }
   }
   
   
}
