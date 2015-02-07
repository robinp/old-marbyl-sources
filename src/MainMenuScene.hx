import flash.events.MouseEvent;

class MainMenuScene extends MenuScene {

   var music_stat : Int;
   public static var sound_stat : Int = 1;

   var music_txt : Array<String>;
   var sound_txt : Array<String>;

   var chs : Array<String>;

   var tooltip : TextScene;
   var was_hint : Bool;

   var do_gameplay : Bool;

   public function new() {

      was_hint = false;

      music_stat = 1;

      music_txt = [
         "Music: Off",
         "Music: On",
      ];
      
      sound_txt = [
         "Sounds: Off",
         "Sounds: On",
      ];

      chs = [
         "Start",
         "Instructions",
         music_txt[music_stat],
         sound_txt[MainMenuScene.sound_stat],
         "High Scores",
         "Credits",
      ];

      if (Main.isFett) {
         chs[4] = "";
      }

      super(chs, 0xffffff);

      var img : flash.display.Bitmap = com.mlabs.resource.ResourceManager.instance.get("com.mlabs.resource.MenuImg");
      addChildAt(img, 0);

      var ml_img : flash.display.Bitmap = com.mlabs.resource.ResourceManager.instance.get("com.mlabs.resource.MLabs");
      var ml = new flash.display.Sprite();
      ml.addChild(ml_img);
      ml.x = 40;
      ml.y = 541 -  ml.height;
      ml.buttonMode = true;
      ml.mouseChildren = false;
      ml.addEventListener(flash.events.MouseEvent.CLICK, function(e) {
         flash.Lib.getURL(new flash.net.URLRequest("http://www.mindless-labs.com/games"), "_blank");
      }, false, 0);
      ml.addEventListener(flash.events.MouseEvent.MOUSE_OVER, function(e) {
         ml.filters = [new flash.filters.GlowFilter(0xff0000, 25)];
      }, false, 0);
      ml.addEventListener(flash.events.MouseEvent.MOUSE_OUT, function(e) {
         ml.filters = [];
      }, false, 0);
      addChild(ml);
      
   }

   override function onMouseDown(e : MouseEvent) {
      if (tooltip_mode) {
         if (selected != 5 && selected != 4) was_hint = true;
         tooltip.startEnd();
         tooltip = null;
         tooltip_mode = false;
         
         if (do_gameplay)
            transit_to_scene = new GameScene(this, mx, my);
            do_gameplay = false;
      }
      else
         super.onMouseDown(e);
   }

   static var hint_txt = "Move your mouse and catch marbles of the same color or shape as the mouse. The game is over once your time bar is empty! Go for a long flawless chain to score high!\n\n\n\n\n\n\nHave fun!! :)\n\n&lt;Click to continue&gt;";

   override function onSelection() {
      super.onSelection();

      if (selected == 0) {
      
         if (!was_hint) {
            tooltip = new TextScene(this, MainMenuScene.hint_txt, true);
            SceneManager.instance.addScene(tooltip);
            tooltip_mode = true;
            do_gameplay = true;
         }
         else
            transit_to_scene = new GameScene(this, mx, my);
      }
      else if (selected == 1) {
         tooltip = new TextScene(this, MainMenuScene.hint_txt, true);
         SceneManager.instance.addScene(tooltip);
         tooltip_mode = true;
      }
      else if (selected == 2) {
         music_stat = 1 - music_stat;
         choiceTF[2].text = music_txt[music_stat];

         if (music_stat == 1) 
            BGMLoop.instance.start(1.0);
         else
            BGMLoop.instance.stop();
      } 
      else if (selected == 3) {
         MainMenuScene.sound_stat = 1 - MainMenuScene.sound_stat;
         choiceTF[3].text = sound_txt[MainMenuScene.sound_stat];
      }
      else if (selected == 4 && !Main.isFett) {
         if (mindjolt.MJ.instance.mindjolt != null) {
            tooltip = new TextScene(this, "Build the longest chain to achive a massive score!\n\n&lt;Click to continue&gt;");
            SceneManager.instance.addScene(tooltip);
            tooltip_mode = true;
         }
         else {
            tooltip_mode = true;
            mochi.MochiScores.showLeaderboard({boardID: "77a45435c91608e9", res: "550x550", onClose: noTooltip, onError: noTooltip} );
         }
      }
      else if (selected == 5) {
         tooltip = new TextScene(this, "\nMarbyl v1.03e\n\nDeveloper: Mindless Labs\nFont: BlueStone @ F. Kiener\nMusic: Baby Thing @ melodyloops\nGfx: Mindless Labs, OpenClipart, nicubunu.ro\n\nAvailable for licensing on <u><a href='http://www.flashgamelicense.com/view_game.php?game_id=3048' target='_blank'>FGL</a></u>\n\n&lt;Click to continue&gt;");
         SceneManager.instance.addScene(tooltip);
         tooltip_mode = true;
      }

   }

   function noTooltip() {
      tooltip_mode = false;
   }
}
