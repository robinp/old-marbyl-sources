class FallingSource {

   var next_gentime : Float;

   var level_idx : Int;
   var scene : GameScene;

   var lcfg : LevelConfig;
   var ld : LevelDesc;

   var colsOnScene : Array<Int>;

   static inline var URGENT_VALUE : Int = 1;

   public function new(sc : GameScene) {

      scene = sc;

      lcfg = LevelConfig.instance;
      level_idx = 0;
      ld = lcfg.getFirstLevelDesc();

      sc.notifyLevel(ld);
      
      colsOnScene = new Array<UInt>();

      for (i in 0...Colors.colors.length) {
         colsOnScene.push(0);
      }

      next_gentime = 0.0;
   }

   public function elapsedTime(dt : Float) {
      next_gentime -= dt;
   }

   public function timeToAdd() : Bool {
      if (next_gentime <= 0.0) {
         next_gentime = ld.avg_gentime - ld.diff_gentime + Math.random() * 2 * ld.diff_gentime;
         return true;
      }
      return false;
   }

   public function getNew() : FallingDiam {

      var shape = 4 + Std.random(ld.shape-3);

      var f = new FallingDiam(shape);

      f.speed = ld.avg_speed - ld.diff_speed + Math.random() * 2 * ld.diff_speed;
      
      f.scaleX = ld.avg_size - ld.diff_size + Math.random() * 2 * ld.diff_size;
      f.scaleY = f.scaleX;

      f.y = -0.5 * f.height;
      f.x = 10 + (scene.sw-20) * Math.random();
      
      f.rotation = -30.0 + Math.random() * 60.0;

      var has_urgent = false;
      var min_urgent = 999;
      for (i in 0...ld.enabledColors) {
         if (colsOnScene[i] <= URGENT_VALUE) {
            has_urgent = true;
            if (colsOnScene[i] < min_urgent)
               min_urgent = colsOnScene[i];
            break;
         }
      }

      var colidx = Std.random( ld.enabledColors );
      
      while (has_urgent && colsOnScene[colidx] > min_urgent) {
         colidx += 1;
         if (colidx == ld.enabledColors)
            colidx = 0;
      }
      

      f.colidx = colidx;
      f.intensity = 0.7;

      colsOnScene[f.colidx]++;

      return f;
   }

   public function notifyLevelFlush() {
      /* Go to next level, if applicable */
      var nextLD = lcfg.getNextLevelDesc();
      if (nextLD != null) {
         ld = nextLD;
         scene.notifyLevel(ld);
      }
      else {
         /* No next level.. */
      }
   }

   public function levelBack() {
       /* Go to previous level, if applicable */
      var prevLD = lcfg.getPreviousLevelDesc();
      if (prevLD != null) {
         ld = prevLD;
         scene.notifyLevel(ld);
      }
   }

   public function restart(ld : LevelDesc) {
      this.ld = ld;
      level_idx = 0;
   }

   public function notifyRemoved(f : FallingDiam) {
      colsOnScene[f.colidx]--;
      // trace("on stage:" + colsOnScene[0] + ", " + colsOnScene[1] + ', ' + colsOnScene[2] + ", " + colsOnScene[3]);
   }

}
