class BGMLoop {

   public static var instance(getInstance, null) : FakeLoop;

   static function getInstance() : FakeLoop {
      if (instance == null) {
         var bgm = cast(com.mlabs.resource.ResourceManager.instance.get("com.mlabs.resource.BGM"), flash.media.Sound);
         instance = new FakeLoop(bgm, 7000.0);
      }

      return instance;
   }

}
