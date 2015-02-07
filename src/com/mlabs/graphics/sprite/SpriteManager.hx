package com.mlabs.graphics.sprite;

import flash.display.Bitmap;
import flash.media.Sound;

import com.mlabs.resource.ResourceManager;

class SpriteManager {
   static public var instance(getInstance, null): SpriteManager;

   static public function getInstance(): SpriteManager {
      if (instance == null)
         instance = new SpriteManager();

      return instance;
   }

   var sprites: Hash<SpriteDesc>;

   private function new() {
      sprites = new Hash<SpriteDesc>();

      var doc: Xml = Xml.parse( haxe.Resource.getString("sprites") ); 
      var root: Xml = doc.firstElement();
      var rmgr: ResourceManager = ResourceManager.getInstance();

      var xmlGetInt = function(node: Xml, attr: String, ?default_value: Int = 0): Int {
         var v = if (node.exists(attr)) Std.parseInt(node.get(attr)) else default_value;
         if (v == null)
            throw new Exception("Invalid integer attribute: " + attr + " in <" + node.nodeName +"> tag");

         return v;
      }
      
      var xmlGetFloat = function(node: Xml, attr: String, ?default_value: Float = 0.0): Float {
         var v: Float = if (node.exists(attr)) Std.parseFloat(node.get(attr)) else default_value;
         
         if (v == Math.NaN)
            throw new Exception("Invalid floating point attribute: " + attr + " in <" + node.nodeName +"> tag");

         return v;
      }

      for (sp in root.elementsNamed("sprite")) {
         var id: String = sp.get("id");

         // Parse bitmap field
         var bm: Xml = sp.elementsNamed("bitmap").next();
         
         var bitmap: Bitmap;
         //try {
            bitmap = cast(rmgr.get(bm.get("class")), Bitmap);
         //} catch (e: Dynamic) {
         //   throw new Exception("Invalid resource class ("+bm.get("class")+") used as Bitmap.");
         //}
         var tile_width: Int = xmlGetInt(bm, "tilewidth");
         var tile_height: Int = xmlGetInt(bm, "tileheight");
         var htiles: Int = xmlGetInt(bm, "htiles");
         var vtiles: Int = xmlGetInt(bm, "vtiles");
         var hcenter: Int = xmlGetInt(bm, "hcenter", Math.floor(tile_width / 2));
         var vcenter: Int = xmlGetInt(bm, "vcenter", Math.floor(tile_height / 2));
         var hoffset: Int = xmlGetInt(bm, "hoffset");
         var voffset: Int = xmlGetInt(bm, "voffset");
         var hgap: Int = xmlGetInt(bm, "hgap");
         var vgap: Int = xmlGetInt(bm, "vgap");
         var colorkey: Int = xmlGetInt(bm, "colorkey", -1);

         // Create sprite and add to hash
         var sprite: SpriteDesc = new SpriteDesc(bitmap, tile_width, tile_height, htiles, vtiles, hcenter, vcenter, hoffset, voffset, hgap, vgap, colorkey);
         sprites.set(id, sprite);

         // Parse sequences
         for (seq in sp.elementsNamed("sequences").next().elementsNamed("sequence")) {
            var id: String = seq.get("id");
            var fps: Float = xmlGetFloat(seq, "fps");
            var tiles_str: String = seq.firstElement().firstChild().nodeValue;
            var tiles: Array<Int> = new Array<Int>();
               
            for (t in tiles_str.split(",")) {
               var t_int = Std.parseInt(StringTools.trim(t));
               if (t_int == null)
                  throw new Exception("Invalid tile number '" + t + "' in sequence '" + id + "'");

               tiles.push(t_int);
            }

            sprite.addSequence(id, tiles, fps);
         }

         // Parse actions
         var default_action_id: String = sp.elementsNamed("actions").next().get("default");
         for (act in sp.elementsNamed("actions").next().elementsNamed("action")) {
            var id: String = act.get("id");
            sprite.addAction(id);
            var action: SpriteAction = sprite.actions.get(id);

            for (prt in act.elementsNamed("part")) {
               var id: String = prt.get("id");
               var seq_id: String = prt.get("sequence");
               var sequence: SpriteSequence = if (sprite.sequences.exists(seq_id)) sprite.sequences.get(seq_id) else throw new Exception("Sequence '"+seq_id+"' doesn't exists in part '"+id+"'");
               var next_id: String = prt.get("nextpart");
               var loops: Int = xmlGetInt(prt, "loops", 1);
               var fps: Float = xmlGetFloat(prt, "fps", sequence.fps);

               action.addPart(id, sequence, next_id, loops, fps);
               
               // Parse sounds
               var part: SpriteActionPart = action.parts.get(id);
               for (snd in prt.elementsNamed("sound")) {
                  var cls: String = snd.get("class");
                  var delay: Float = xmlGetFloat(snd, "delay", 0.0);
                  var sound: Sound;
                  try {
                     sound = cast(rmgr.get(cls), Sound);
                  } catch (e: Dynamic) {
                     throw new Exception("Invalid resource class ("+cls+") used as Sound.");
                  }

                  part.addSound(sound, delay);
               }
            }
         }

         // All actions and parts are parsed. Set all partss' next attribute according to next_id.
         for (action in sprite.actions) {
            for (part in action.parts) {
               part.setNext(action.parts.get(part.getNextId()));
            }
         }

         sprite.setDefaultAction(default_action_id);
      }
   }

   public function get(id: String): SpriteDesc {
      return sprites.get(id);
   }
}

