import flash.geom.Rectangle;
import flash.ui.Keyboard;
import haxe.FastList;
import flash.events.MouseEvent;

import HitTest;
import com.mlabs.resource.ResourceManager;
import flash.display.Bitmap;
import flash.display.BitmapData;
import com.mlabs.interp.LinearIP;

class GameScene extends Scene {

   static inline var RESTART_TIME = 2.0;

   var hand : Cursor;

   public var falling(default, null) : FastList<FallingDiam>;
   var fall_src : FallingSource;

   public var pts(default, null) : FastList<FadeText>;

   var restart : Bool;
   var restart_counter : Float;

   var delayed_start : Bool;
   
   var remaining_gems : Int;
   var level_finished : Bool;

   var start_ip : com.mlabs.interp.Interpolator;
   var can_go : Bool;

   public var ending(default, null) : Bool;

   var lcfg : LevelConfig;
 
   var bg_tile : Bitmap;

   var x_ip : LinearIP;
   var y_ip : LinearIP;

   var ms : MenuScene;
   public var sc : ScoreScene;

   public var time_bar(default, null) : TimeBar;
   public var score_cnt(default, null) : Counter;
   public var level_cnt(default, null) : Counter;

   public var hp_bar: HealthBar;
   static var hp_max: Float = 100.0;
   static var hp_bonus: Float = 15.0;
   static var hp_penalty: Float = -10.0;
   static var hp_decrate = 10;
   static var hp_decrate_inc: Float = 0.9;

   var extradec : Float; 

   var spd_mult : Float;

   var ht : HitTest;

   public function new(ms : MenuScene, mx : Float, my : Float) {
      super();

      ht = HitTest.instance;

      this.ms = ms;
      extradec = 0.0;

      /* Background */
      var bg_img = cast(ResourceManager.instance.get("com.mlabs.resource.BGImg"), Bitmap);
      addChild(bg_img);

      lcfg = LevelConfig.instance;
      

      /* Timer */
      time_bar = new TimeBar(lcfg);
      time_bar.x = 435;
      time_bar.y = 505;
      addChild(time_bar);

      /* Score counter */
      score_cnt = new Counter(130, '', ' pts', 1.0, 16);
      score_cnt.x = 25;
      score_cnt.y = 508;
      addChild(score_cnt);
      
      /* Level counter */
      level_cnt = new Counter(130, 'Level ', '', 0.01, 20);
      level_cnt.x = 193;
      level_cnt.y = 505;
      level_cnt.value = 1;
      addChild(level_cnt);

      /* HP bar */
      //hp_bar = new Bar(300, 20, 5, 10, 5, [0x8080ff, 0x0000ff], [0xff0000, 0xffff00, 0x00ff00], 100, 100, 10);
      hp_bar = new HealthBar(300, 20, GameScene.hp_max, GameScene.hp_max, 10, 3);
      hp_bar.x = (550 - 330) / 2;
      hp_bar.y = 460;
      addChild(hp_bar);

      fall_src = new FallingSource(this);
      falling = new FastList<FallingDiam>();

      spd_mult = 1.0;
      delayed_start = false;
      restart = false;
      can_go = true;
      ending = false;
      level_finished = false;
      alpha = 1.0;

      start_ip = new com.mlabs.interp.LinearIP();
      start_ip.setEndCallback(fadedIn);

      x_ip = new LinearIP();
      y_ip = new LinearIP();
      
      this.mx = mx;
      this.my = my;

      pts = new FastList<FadeText>();

      /* Cursor */
      hand = new Cursor(fall_src, this);
      hand.x = mx;
      hand.y = my;
      addChild(hand);
      hand.notifyLevel(lcfg.getCurrentLevelDesc());

      flash.ui.Mouse.hide();
   }

   public function playAgain() {
      delayed_start = true;
      restart = false;
      can_go = true;
      ending = false;
      level_finished = false;
      alpha = 1.0;

      hp_bar.value = GameScene.hp_max;
      hp_bar.dec_rate = hp_decrate;

      lcfg.restart();
      flash.ui.Mouse.hide();
      hand.fadeBack();
   }

   function do_restart() {
      time_bar.restart();
      var ld = lcfg.getFirstLevelDesc();
      hand.restart(ld);
      extradec = 0.0;
      fall_src.restart(ld);
      score_cnt.value = 0;
      level_cnt.value = 1;
   }

   public function do_remove() {
      can_go = false;
      start_ip.setEndCallback(removeSelf);
      start_ip.setFrom(1.0);
      start_ip.setTarget(0.0, 0.3);
   }
   
   override function removeSelf() {
      super.removeSelf();
      flash.ui.Mouse.show();
      // trace("remove");
   }

   public function notifyLevel(ld : LevelDesc) {
      level_cnt.value = lcfg.actLevel + 1;
      
      hp_bar.dec_rate = hp_decrate + lcfg.actLevel * hp_decrate_inc + extradec;

      if (hand != null)
         hand.notifyLevel(ld);

      /*
      var work_data = bg_tile.bitmapData.clone();
      var ct = new flash.geom.ColorTransform();
      var mul = 1.0 + lcfg.actLevel * 0.01;
      ct.redMultiplier = 1.1 * mul;
      ct.greenMultiplier = 1.1 * mul;
      ct.blueMultiplier = 1.0 * mul;

      work_data.colorTransform(work_data.rect, ct);
      
      graphics.beginBitmapFill(work_data);
      graphics.drawRect(0, 0, sw, sh);
      graphics.endFill();
      */
   }

   public function fadedIn() {
      can_go = true;
      alpha = 1.0;
   }

   public override function run(dt : Float) {
      if (can_go && !level_finished)
         elapsedTime(dt);
      else {
      	 start_ip.elapsedTime(dt);
      	 alpha = start_ip.getValue();

          hand.setPos(mx, my);
      }
      
      if (level_finished) {
      	removeSelf();
         var nextScene = new MainMenuScene();
      	SceneManager.instance.addScene(nextScene);
      }

      if (restart && restart_counter <= 0.0) {
         removeSelf();
         SceneManager.instance.addScene(new MainMenuScene());
      }
   }

   function collCheck() {
      var dx = mx - hand.x;
      var dy = my - hand.y;
      var len = Math.sqrt(dx*dx + dy*dy);

      var udt = 1.0;
      if (len > 0) {
         udt = Math.min(1.0, 20.0 / len);    // 20.0 is the maximal non-checked distance
      }

      x_ip.setFrom(hand.x);
      x_ip.setTarget(mx);
      y_ip.setFrom(hand.y);
      y_ip.setTarget(my);

      while (!x_ip.atTarget) { 

         x_ip.elapsedTime(udt);
         y_ip.elapsedTime(udt);
         hand.setPos(x_ip.act, y_ip.act);

         if (delayed_start)
            continue;

         for (f in falling) {
            
            if (f.disabled || hand.protect)
               continue;
            
            var remove = false;

            var r = ht.hitTestObject(hand, f);
            if (r != null) {

               if (hand.evalPickup(f)) {
                  hand.pickup(f);
                  hp_bar.value += GameScene.hp_bonus;
               }
               else {
                  hand.collide(f);
                  hp_bar.value += GameScene.hp_penalty;
                  extradec += hp_decrate_inc * 0.3;
               }

               remove = true;
            }
            
            if (remove) {
               f.removeSoon();
               fall_src.notifyRemoved(f);
            }
         }
      } 
   }

   override function elapsedTime(dt : Float) {

      /* Restarting? */
      if (delayed_start) {
         spd_mult = 2.0;
         if (falling.isEmpty()) {
            //trace("do_restart");
            delayed_start = false;
            spd_mult = 1.0;

            do_restart();
         }
      }

      /* Update UI */
      if (!ending)
         time_bar.elapsedTime(dt);

      // hp_bar.dec_rate += dt * 0.05;
      hp_bar.elapsedTime(dt);
      if (!delayed_start && !ending && (hp_bar.ipValue <= 0.01)) {
         //trace("ending");
         ending = true; 
        
         sc = new ScoreScene(ms, this, score_cnt.value);
         SceneManager.instance.addScene(sc, true, 1);
        
         hand.startEnding();
         flash.ui.Mouse.show();
      }

      score_cnt.elapsedTime(dt);
      level_cnt.elapsedTime(dt);
      
      for (pt in pts) {
         pt.elapsedTime(dt);
         if (pt.dead)
            pts.remove(pt);
      }
   
      if (!delayed_start) {
         /* Add a new falling */
         fall_src.elapsedTime(dt);

         if (fall_src.timeToAdd()) {
            var f = fall_src.getNew();
            addChildAt(f, 1);
            falling.add(f);
         }
      }

      /* Move diamonds, remove out-of-screen ones */
      for (f in falling) {
         f.elapsedTime(dt * spd_mult);
         
         if (f.y > sh + 0.5*f.height)
            f.setDead();
      }

      /* Update Hand size, rotation */
      hand.elapsedTime(dt);
      
      if (!ending) {
         /* Collision check */
         collCheck();
      }

      /* Clean dead sprites */
      for (f in falling) {
         if (f.dead) {
            removeChild(f);
            falling.remove(f);
         }
      }
     
   }
   
   public override function onKeyUpDown(e : flash.events.KeyboardEvent, down : Bool) { 
      if (down && e.keyCode == flash.ui.Keyboard.ESCAPE) {
         if (sc != null) {
            sc.startEnd();
            sc = null;
         }
         do_remove();
         ms.transit_ip.setTarget(0.0, 0.25);
      }
   }
}
