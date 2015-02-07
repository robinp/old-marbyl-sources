import flash.media.Sound;
import flash.media.SoundTransform;
import flash.media.SoundChannel;

class FakeLoop
{
   var snd : Sound;
   var active_channel : SoundChannel;
   var passive_channel : SoundChannel;

   var fade_msec : Float;
   var playing : Bool;

   var stopping : Bool;
   var stop_ip : com.mlabs.interp.LinearIP;

   public function new(snd : Sound, fade_msec : Float = 1000.0) {
      this.snd = snd;
      this.fade_msec = fade_msec;

      playing = false;
      stopping = false;
      
      stop_ip = new com.mlabs.interp.LinearIP();
   }

   public function start(init_volume : Float = 0.0) {
      playing = true;
      stopping = false;
      active_channel = startChannel(init_volume);
   }

   public function stop() {
      stopping = true;
      stop_ip.setFrom(active_channel.soundTransform.volume);
      stop_ip.setTarget(0.0, 1.0);
   }

   public function elapsedTime(dt : Float) {
      if (passive_channel != null) {
         advanceChannel(passive_channel);
      }

      if (stopping)
         stop_ip.elapsedTime(dt);

      if (playing && advanceChannel(active_channel) && passive_channel == null) {
         passive_channel = active_channel;
         active_channel = startChannel();  
      }
   }

   function startChannel(init_volume : Float = 0.0) : SoundChannel {
      var ch = snd.play(0.0, 0, new SoundTransform(init_volume));
      ch.addEventListener(flash.events.Event.SOUND_COMPLETE, deletePassive);
      return ch;
   }

   function deletePassive(e : flash.events.Event) {
      passive_channel = null;
   }

   function advanceChannel(ch : SoundChannel) : Bool {
      var pos = ch.position;
      var tr = ch.soundTransform;
      
      if (stopping) {
         tr.volume = stop_ip.act;
         ch.soundTransform = tr;

         if (stop_ip.atTarget) {
            stopping = false;
            playing = false;
            active_channel.stop();
         }
      }
      else if (pos <= fade_msec) {
         tr.volume = Math.max(tr.volume, 1.0 - (fade_msec - pos) / fade_msec);
         ch.soundTransform = tr;
      }
      else if (pos >= snd.length - fade_msec) {
         tr.volume = (snd.length - pos) / fade_msec;
         ch.soundTransform = tr;
         return true;
      }
      else if (tr.volume != 1.0) {
         tr.volume = 1.0;
         ch.soundTransform = tr;
      }
      return false;
   }
}
