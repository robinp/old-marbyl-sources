/*
 * HaXe port v0.1, by Robin Palotai, www.mindless-labs.com
 *
 *
 * Adventures In Actionscript AS3 Toolkit
 * Copyright (C) 2008 www.adventuresinactionscript.com
 * 
 * If you use this code in your own projects, please give credit to
 * the authors and feel free to let them know about your projects that
 * make use of this. You are not authorized to distribute modified
 * copies of this code, without first contacting all the authors and
 * obtaining their permission. You may however modified and use this 
 * code in your own compiled projects without permission. Do not remove
 * or modify this header in anyway.
 *
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 */
 
import flash.display.DisplayObject;
import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;

/**
* A replacement collision detection class
* @author The Actionscript Man (theactionscriptman [at] gmail.com)
* @version 1.0.0
*/
class HitTest {
   
   public static var instance(getInstance, null) : HitTest;

   static function getInstance() : HitTest {
      if (instance == null)
         instance = new HitTest();
      return instance;
   }

   var pim : Matrix;
   var tm : Matrix;

   var last_sw : Int;
   var last_sh : Int;

   var last_pim_t : UInt; 

   function new() {
      pim = flash.Lib.current.transform.concatenatedMatrix.clone();
      pim.invert();
      last_sw = flash.Lib.current.stage.stageWidth;
      last_sh = flash.Lib.current.stage.stageHeight;

      last_pim_t = flash.Lib.getTimer();
   }

   inline function checkPim() {
      if (flash.Lib.getTimer() - last_pim_t > 1000) {
         last_pim_t = flash.Lib.getTimer();
         last_sw = -1;
         last_sh = -1;
      }

      var sw = flash.Lib.current.stage.stageWidth;
      var sh = flash.Lib.current.stage.stageHeight;
      if (sw != last_sw || sh != last_sh) {
         last_sw = sw;
         last_sh = sh;
         pim = flash.Lib.current.transform.concatenatedMatrix.clone();
         pim.invert();
      }
   }

   /**
    * hitTestObject checks to see if two display objects have collided from 
    * http://www.adventuresinactionscript.com/blog/15-03-2008/actionscript-3-hittestobject-and-pixel-perfect-collision-detection
    * Based on Grant Skinner & Troy Gilberts collision detection functions
    *
    * @param  object1      the first object to be tested
    * @param  object2      the second object to be tested
    * @param  pixelPerfect check bounding rectangle only if set to false
    * @param  tolerance    alpha tolerance value
    * @return intersecting rectangle if the objects have collided, or null if no collision
    * @see         hitTestObject
    */	
   public function hitTestObject(object1:DisplayObject, object2:DisplayObject, pixelPerfect:Bool=true, tolerance:Int = 255):Rectangle {
      
      // quickly rule out anything that isn't in our hitregion
      if (object1.hitTestObject(object2)) {

         //trace("Hit!" + object1 + " " + object2 + " " + Math.random());
      
         // get bounds:
         var r = flash.Lib.current;
         var bounds1:Rectangle = object1.getBounds(r);
         var bounds2:Rectangle = object2.getBounds(r);
         
         /*
         trace("Stage bounds of o1: " + bounds1);
         trace("Stage bounds of o2: " + bounds2);
         */
                  
         // determine test area boundaries:
         var bounds:Rectangle = bounds1.intersection(bounds2);

         // trace("Intersect: " + bounds);
         
         var bx = Math.floor(bounds.x);
         var by = Math.floor(bounds.y);
         var bw = Math.ceil(bounds.width);
         var bh = Math.ceil(bounds.height);
         
         bounds.x = bx;
         bounds.y = by;
         bounds.width = bw;
         bounds.height = bh;
               
         //ignore collisions smaller than 1 pixel
         if ((bounds.width < 1) || (bounds.height < 1))
            return null;

         if (!pixelPerfect)
            return bounds;
      
         // set up the image to use:
         var img:BitmapData = new BitmapData(bw, bh, false);
         
         
         checkPim();
         
         // draw in the first image:
         
         tm = object1.transform.concatenatedMatrix.clone();
         tm.concat(pim);
         tm.translate( -bounds.left, -bounds.top);
         img.draw(object1,tm, new ColorTransform(1,1,1,1,255,-255,-255,tolerance));
         
         // overlay the second image:
         tm = object2.transform.concatenatedMatrix.clone();
         tm.concat(pim);
         tm.translate( -bounds.left, -bounds.top);
         
         img.draw(object2,tm, new ColorTransform(1,1,1,1,255,255,255,tolerance),flash.display.BlendMode.DIFFERENCE);

         
         // find the intersection:
         var intersection:Rectangle = img.getColorBoundsRect(0xFFFFFFFF,0xFF00FFFF);
         // trace("intersection:" + intersection);

         // if there is no intersection, return null:
         if (intersection.width == 0) { return null; }
         
         // adjust the intersection to account for the bounds:
         intersection.offset(bounds.left, bounds.top);
         
         return intersection; 
      }
      else
         return null;
   }
  /*	
   static function getDrawMatrix( target:DisplayObject, hitRectangle:Rectangle, accurracy:Number ):Matrix
   {
         var localToGlobal:Point;;
         var matrix:Matrix;
         
         var rootConcatenatedMatrix:Matrix = target.root.transform.concatenatedMatrix;
         
         localToGlobal = target.localToGlobal( new Point( ) );
         matrix = target.transform.concatenatedMatrix;
         matrix.tx = localToGlobal.x - hitRectangle.x;
         matrix.ty = localToGlobal.y - hitRectangle.y;
         
         matrix.a = matrix.a / rootConcatenatedMatrix.a;
         matrix.d = matrix.d / rootConcatenatedMatrix.d;
         if( accurracy != 1 ) matrix.scale( accurracy, accurracy );

         return matrix;
   }
   */
   
}
