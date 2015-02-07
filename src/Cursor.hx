import com.mlabs.interp.LinearIP;
import com.mlabs.resource.ResourceManager;

class Cursor extends Diam {
   static inline var BASE_SIZE  = 0.8;
   static inline var SIZE_INC = 0.8;

   var rmgr : ResourceManager;
   var fall_src : FallingSource;

   var target_size : Float;

   var ld : LevelDesc;
   var lcfg : LevelConfig;

   var combo_len : Int;

   var scene : GameScene;

   var ending_ip : LinearIP;

   var level_time : Float;

   var last_colidx : Int;
   var last_colcnt : Int;

   public var protect(default, null) : Bool;
   var protect_ip : LinearIP;

   public function new(fall_src : FallingSource, sc : GameScene) {
      super(4);

      last_colidx = -1;
      last_colcnt = 0;

      scene = sc;

      lcfg = LevelConfig.instance;

      intensity = 0.8;
      protect = false;
      colidx = 0;
      // color = Colors.colors[colidx];
      scaleX = 0.1;
      scaleY = 0.1;
      protect_ip = new LinearIP();

      combo_len = 0;

      this.fall_src = fall_src;
      rmgr = ResourceManager.instance;

      displayLevel(true, 0.0, 1.0);

      changeShape();
   }

   function sanityCheck() {

      if (colidx >= ld.enabledColors && ang > ld.shape) {
         /* If there is no compatible shape on-screen, let's change */

         for (f in scene.falling) {
            if (f.colidx == colidx || f.ang == ang)
               /* Found a matching one */
               return;
         }

         /* Last resort */
         colidx = 0;
         ang = 4;
         changeShape();
      }
   }

   public function notifyLevel(ld : LevelDesc) {
      this.ld = ld;

      level_time = ld.level_time;

      sanityCheck();
   }

   public function restart(ld : LevelDesc) {
      notifyLevel(ld);

      last_colidx = -1;
      last_colcnt = 0;
      protect = false;
      combo_len = 0;

      scaleX = scaleY = BASE_SIZE;
      displayLevel(true, 0.0, 1.0);
      colidx = 0;
      ang = 4;
   }

   public override function elapsedTime(dt : Float) {
      super.elapsedTime(dt);

      sanityCheck();

      scaleX = scaleY = BASE_SIZE + SIZE_INC * scene.hp_bar.ipValue / scene.hp_bar._max;

      rotation += dt * 10.0;
 
      if (!scene.ending) {
         level_time -= dt;
         if (level_time <= 0.0) {
            fall_src.notifyLevelFlush();
            displayLevel(true);
         }
      }

      if (protect) {
         protect_ip.elapsedTime(dt);
         alpha = protect_ip.act;
         if (protect_ip.atTarget) {
            protect = false;
         }
      }

      if (ending_ip != null) {
         ending_ip.elapsedTime(dt);
         alpha = ending_ip.act;
         if (ending_ip.atTarget)
            ending_ip = null;
      }
   }

   public function startEnding() {
      ending_ip = new LinearIP(1.0, 0.0, 1.0);
   }

   public function fadeBack() {
      ending_ip = new LinearIP(0.0, 1.0, 1.0);
      colidx = 0;
      ang = 4;
      changeShape();
   }

   public function pickup(f : FallingDiam) {

      var perfect = evalPerfectPickup(f);

      if (perfect)
         combo_len += 2;
      else
         combo_len++;

      scene.score_cnt.value += combo_len;
      
      var pt = new FadeText(
         "+" + Std.string(combo_len) + (perfect ? "!" : ""),
         0.0,
         0.3,
         0.01,
         0.4,
         0x000000
      );
      pt.x = x - 0.5 * pt.textWidth;
      pt.y = y + 10.0;
      scene.pts.add(pt);
      scene.addChild(pt);

      /* Grow size 
      target_size += ld.cur_grow_size;
      size_ip.setTarget(target_size);
      */

      if (MainMenuScene.sound_stat == 1)  {
         //if (combo_len % 10 == 0)
         if (perfect)
            rmgr.get("com.mlabs.resource.FlushSfx", false).play();
         else
            rmgr.get("com.mlabs.resource.PickupSfx", false).play();
      }

      /* Change color */
      calcNextShape(f);
      changeShape();
   }

   /*****************************
    * GamePlay style functions */
 
   /*
   function calcNextShape(f: FallingDiam) {
      colidx = (colidx + 1);
      if (colidx == ld.enabledColors)
         colidx = 0;

      while (colidx == last_colidx)
         colidx = Std.random(ld.enabledColors);

      last_colidx = colidx;
      ang = 4 + Std.random(ld.shape -3);
   }

   public function evalPickup(f: FallingDiam) : Bool {
      return f.color == color && f.ang == ang;
   }
   */

   function calcNextShape(f: FallingDiam) {
      colidx = f.colidx;
      ang = f.ang;
   }

   public function evalPickup(f: FallingDiam) : Bool {
      return f.colidx == colidx || f.ang == ang;
   }
   
   public function evalPerfectPickup(f: FallingDiam) : Bool {
      return f.colidx == colidx && f.ang == ang;
   }

   /* End here
    ****************/

   function displayLevel(up : Bool, t_start = 0.0, t_in = 0.3, t_hold = 0.1, t_out = 0.5) {

      return;

      var str : String = "Level " + (lcfg.actLevel + 1);
      if (!up)
         str = "Back to " + str + " :(";

      var lev = new FadeText(
         str,
         t_start,
         t_in,
         t_hold,
         t_out,
         0x442222,
         new flash.text.TextFormat("GameFont", 50)
      );
      lev.x = 0.5 * scene.sw - 0.5 * lev.textWidth;
      lev.y = 0.5 * scene.sh - 0.5 * lev.textHeight;
      scene.pts.add(lev);
      scene.addChild(lev);
   }

   function startProtect() {
      protect = true;
      protect_ip.setFrom(0.5);
      protect_ip.setTarget(1.0, 0.5);
   }

   public function collide(f : FallingDiam) {
      if (MainMenuScene.sound_stat == 1)
         rmgr.get("com.mlabs.resource.DestroySfx", false).play();

      /*
      if (Math.abs(target_size - SIZE_DEFAULT) < 0.001) {
         if (lcfg.actLevel > 0) { 
         
            fall_src.levelBack();
            displayLevel(false);
         }
      }
      */

      var pt = new FadeText(
         "50% Combo Cut :(",
         0.0,
         0.3,
         0.01,
         0.4,
         0x000000
      );
      pt.x = x - 0.5 * pt.textWidth;
      pt.y = y + 10.0;
      scene.pts.add(pt);
      scene.addChild(pt);

      combo_len = Std.int(combo_len / 2);

      startProtect();      
   }

   public function flush() {
   }

   public function setPos(x : Float, y : Float) {
      this.x = x;
      this.y = y;
   }

}
