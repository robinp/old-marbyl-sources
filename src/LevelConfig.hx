class LevelConfig{

	static public var instance(getInstance, null) : LevelConfig;
	
	static function getInstance() : LevelConfig {
		if (instance == null)
			instance = new LevelConfig();
		
		return instance;
	}

	var root : Xml;
	var levels : Array<LevelDesc>;

   public var game_time(default, null) : Float;
	
	public var actLevel(default, null) : Int;

	private function new(){
		var doc = Xml.parse( haxe.Resource.getString("level_cfg") );
		root = doc.firstElement();
		levels = new Array<LevelDesc>();
		
      var prevLD : LevelDesc = null;
       
      game_time = Std.parseFloat(root.get("game_time"));

      for (ls in root.elementsNamed("levels"))
         for (l in ls.elementsNamed("level")) {
            var ld = new LevelDesc(l, prevLD);
            prevLD = ld;
            levels.push(ld);
         }
		
		//trace("loaded levels: " + levels.length);
		
		actLevel = -1;
	}
	
   public function restart() {
      actLevel = -1;
   }

	public function getFirstLevelDesc() : LevelDesc {
		actLevel = -1;
		return getNextLevelDesc();
	}
	
	public function getNextLevelDesc() : LevelDesc {
		if (actLevel < levels.length) {
			return levels[++actLevel];
		}
		return null;
	}
   
   public function getPreviousLevelDesc() : LevelDesc {
		if (actLevel > 0) {
			return levels[--actLevel];
		}
		return null;
	}

   public function getCurrentLevelDesc() : LevelDesc {
      if (actLevel >= 0 && actLevel < levels.length)
         return levels[actLevel];
      return null;
   }
 
}
