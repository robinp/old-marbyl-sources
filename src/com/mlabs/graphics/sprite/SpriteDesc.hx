package com.mlabs.graphics.sprite;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;

class SpriteDesc {
   public var tiles(default, null): Array<BitmapData>;
   public var sequences(default, null): Hash<SpriteSequence>;
   public var actions(default, null): Hash<SpriteAction>;
   public var defaultAction(default, null): SpriteAction;
   public var hcenter(default, null): Int;
   public var vcenter(default, null): Int;

   public function new(bitmap: Bitmap, tile_width: Int, tile_height: Int, htiles: Int, vtiles: Int, hcenter: Int, vcenter: Int, hoffset: Int, voffset: Int, hgap: Int, vgap: Int, colorkey: Int) {
      this.hcenter = hcenter;
      this.vcenter = vcenter;

      tiles = new Array<BitmapData>();
      sequences = new Hash<SpriteSequence>();
      actions = new Hash<SpriteAction>();
      defaultAction = null;

      var bmdata = bitmap.bitmapData;
      var src_rect: Rectangle = new Rectangle(hoffset, voffset, tile_width, tile_height);
      var dst_pt: Point = new Point(0, 0);
      for (j in 0...vtiles) {
         for (i in 0...htiles) {
            var t: BitmapData = new BitmapData(tile_width, tile_height);
            tiles.push(t);
            t.copyPixels(bmdata, src_rect, dst_pt);

            src_rect.x += tile_width + hgap;
         }

         src_rect.x = hoffset;
         src_rect.y += tile_height + vgap;
      }
   }

   public function addSequence(id: String, tiles: Array<Int>, fps: Float) {
      sequences.set(id, new SpriteSequence(tiles, fps));
   }

   public function addAction(id:String) {
      actions.set(id, new SpriteAction());
   }

   public function setDefaultAction(action_id: String) {
      defaultAction = actions.get(action_id);
   }
}

