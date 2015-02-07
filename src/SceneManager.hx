import haxe.FastList;
import flash.Lib;

class SceneManager {

   static public var instance(getInstance, null) : SceneManager;

   static function getInstance() : SceneManager {
      if (instance == null)
         instance = new SceneManager();

      return instance;
   }

   public var scene_list(default, null) : FastList<Scene>;
   public var main_scene(default, null) : Scene;

   public function new() {
      scene_list = new FastList<Scene>();
   }

   public function addScene(sc : Scene, set_main = true, ?z : Null<Int>) {
      scene_list.add(sc);

      if (z == null)
         Lib.current.addChild(sc);
      else
         Lib.current.addChildAt(sc, z);

      if (set_main) {
         main_scene = sc;
      }
      
      Lib.current.stage.focus = Lib.current.stage;
   }

   public function removeScene(sc : Scene) {
      scene_list.remove(sc);
      Lib.current.removeChild(sc);

      if (main_scene == sc)
         main_scene = null;
   }

   public inline function run(dt : Float) {
      for (sc in scene_list)
         sc.run(dt);
   }

}
