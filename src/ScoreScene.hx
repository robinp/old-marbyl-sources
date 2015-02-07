import flash.text.TextField;
import com.mlabs.interp.LinearIP;

class AdHolder extends flash.display.Sprite, implements Dynamic {
   public function new() {
      super();

      graphics.beginFill(0xf08000);
      graphics.drawRoundRect(-5, -5, 310, 260, 10);
      graphics.endFill();
 
      var fmt = new flash.text.TextFormat("GameFont", 70);
      fmt.align = flash.text.TextFormatAlign.CENTER;
      fmt.bold = true;

      var sc_display = new TextField();
      sc_display.embedFonts = true;
      sc_display.defaultTextFormat = fmt;
      sc_display.text = "?";
      sc_display.textColor = 0x000000;
      sc_display.autoSize = flash.text.TextFieldAutoSize.CENTER;
      sc_display.selectable = false;

      sc_display.x = 120;
      sc_display.y = 80;
      addChild(sc_display);


      started = false;
   }

   var started : Bool;

   public function startAd() {
      if (started)
         return;

      started = true;
      MochiAd.showClickAwayAd({
         clip:this, 
         id:"fa57f09ba55e8b5f"
      });
   }
   
   public function stopAd() {
      MochiAd.unload(this);
   }

}

class ScoreScene extends Scene {

   var score : Int;
   var game_scene : GameScene;
   var menu_scene : MenuScene;

   var again_btn : TextButton;
   var submit_btn : TextButton;
   var main_btn : TextButton;
   var pmg_btn : TextButton;

   var adClip : AdHolder;

   var buttons : Array<MyButton>;

   var doing_score : Bool;

   var start_ip : LinearIP;

   var finish : Bool;
   var removeGameScene : Bool;

   public function new(menu_scene : MenuScene, game_scene : GameScene, score : Int) {
      super();
      
      doing_score = false;

      finish = false;
      removeGameScene = false;
      alpha = 0.0;
      start_ip = new LinearIP(0.0, 1.0, 1.0);

      this.score = score;
      this.game_scene = game_scene;
      this.menu_scene = menu_scene;
      
      var fmt = new flash.text.TextFormat("GameFont", 35);
      fmt.align = flash.text.TextFormatAlign.CENTER;
      fmt.bold = true;
      
      var sc_display = new TextField();
      sc_display.embedFonts = true;
      sc_display.defaultTextFormat = fmt;
      sc_display.text = "Final Score: " + Std.string(score) + " pts\n" + getScoreQualifier(score);
      sc_display.textColor = 0x000000;
      sc_display.autoSize = flash.text.TextFieldAutoSize.CENTER;
      sc_display.selectable = false;

      sc_display.x = 0.5 * (sw - sc_display.width);
      sc_display.y = 20;
      addChild(sc_display);
   
      buttons = new Array<MyButton>();

      var btns = [
         {b : again_btn, x : 100, y : 450, txt : "Play Again!", col : 0x800559},
         {b : submit_btn, x : 100, y : 490, txt : "Submit Score", col : 0x05801c},
         {b : pmg_btn, x : 300, y : 450, txt : "More Games!", col : 0x900505},
         {b : main_btn, x : 300, y : 490, txt : "Main Menu", col : 0x1d0580}
      ];

      var last_y = 0.45 * sh;

      for (btn in btns) {
         btn.b = new TextButton(btn.txt, 20, 190, 0.0, btn.col);
         btn.b.x = 70 + btn.x;
         btn.b.y = btn.y - 20;
         last_y += btn.b.height*1.2;
         buttons.push(btn.b);
         addChild(btn.b);
      }

      if (Main.fettScore(score)) {
         _ending2();
      }

      if (mindjolt.MJ.instance.mindjolt != null) {
         mindjolt.MJ.instance.mindjolt.service.submitScore(score);
      }
      else {
         adClip = new AdHolder();
         addChild(adClip);
         adClip.x = 125.0;
         adClip.y = 130;
      }
   }
   
   override function elapsedTime(dt : Float) {
      super.elapsedTime(dt);

      adClip.startAd();

      var i = 0;
      for (b in buttons) {
         b.elapsedTime(dt);

         if (!finish && b.clk) {
            b.clk = false;

            if (!doing_score) {

               switch (i) {
               case 0:
                  game_scene.playAgain();
                  startEnd();
               case 1:
                  if (mindjolt.MJ.instance.mindjolt != null) {
                     mindjolt.MJ.instance.mindjolt.service.submitScore(score);   
                  }
                  else {
                     doing_score = true;
                     mochi.MochiScores.showLeaderboard({boardID: "77a45435c91608e9", res: "550x550", score: score, onClose: _ending2});
                  }
               case 2:
                  flash.Lib.getURL(new flash.net.URLRequest("http://www.mindless-labs.com/games"), "_blank");
               case 3:
                  _ending();
               }
            }
         }

         i++;
      }
   }

   function _ending2() {
      doing_score = false;
      buttons[1].visible = false;
   }

   function _ending() {
      if (adClip != null)
         adClip.stopAd();
      menu_scene.transit_ip.setTarget(0.0, 0.25);
      startEnd();
      removeGameScene = true;
   }

   public function startEnd() {
      start_ip = new LinearIP(alpha, 0.0, 1.0);
      finish = true;
   }

   public override function run(dt : Float) {
      if (start_ip != null) {
         start_ip.elapsedTime(dt);
         alpha = start_ip.getValue();

         if (start_ip.atTarget) {
            start_ip = null;
            
            if (finish) {
               if (removeGameScene) {
                  game_scene.do_remove();
                  game_scene.sc = null;
               }
               removeSelf();
            }
         }
      }
      
      elapsedTime(dt);
   }

 
   function getScoreQualifier(sc : Int) {
      var tab = [ 
         {s : 0, q : "Nice dodging!"},
         {s : 5, q : "Give it another shot!"},
         {s : 50, q : "Better next time!"},
         {s : 100, q : "Come on!"},
         {s : 200, q : "You can do better!"},
         {s : 400, q : "Buy a new mouse"},
         {s : 800, q : "Getting warmer"},
         {s : 1500, q : "Not bad!"},
         {s : 2500, q : "You can improve!"},
         {s : 3500, q : "Well done!"},
         {s : 5000, q : "Gooood!"},
         {s : 6000, q : "Wow!!"},
         {s : 8000, q : "Excellent!"},
         {s : 10000, q : "Exceptional!"},
         {s : 12000, q : "Hand like lightning!!"},
         {s : 14000, q : "Extreme!!"},
         {s : 16000, q : "Amazing!!"},
         {s : 18000, q : "Wonder Mouse!"},
         {s : 20000, q : "You Are Incredible!"},
         {s : 30000, q : "Good Worker Man!"},
         {s : 35000, q : "Mega Marble Collector"},
         {s : 40000, q : "Marble Maniac"},
         {s : 50000, q : "The Master of Marbyl"},
         {s : 75000, q : "Unbelievable!"},
         {s : 100000, q : "My Master"},
         {s : 125000, q : "Glorious"},
         {s : 150000, q : "Eternal Master"},
         {s : 9999999, q : "Placeholder"},
      ];

      for (i in 0...tab.length-1) 
         if (sc >= tab[i].s && sc < tab[i+1].s) 
            return tab[i].q;
         
      return "No way";
   }


}
