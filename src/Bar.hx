import flash.geom.Matrix;
import flash.display.Sprite;
import flash.display.GradientType;
import flash.display.Graphics;

import com.mlabs.interp.LinearIP;

class Bar extends Sprite {

   public var value(getValue, setValue): Float;
   public var ipValue(getIPValue, null): Float;
   public var ipAtTarget(getIPAtTarget, null): Bool;
   public var max(getMax, setMax): Float;

   var _value: Float;
   public var _max(default, null): Float;

   var value_ip: LinearIP;
   var rate: Float;
   
   var out_bar: Sprite;
   var in_bar: Sprite;

   var spacing: Float;
   var inner_bevel: Float;
   var inner_colors: Array<UInt>;
   var inner_alphas: Array<Float>;
   var inner_ratios: Array<Float>;
   var inner_matrix: Matrix;

   
   public function new(width: Float, height: Float, spacing: Float, bevel: Float, inner_bevel: Float, colors: Array<UInt>, inner_colors: Array<UInt>, ?max: Float = 100.0, ?act = 0.0, ?rate: Float = 10.0) {
      super();

      this._value = act;
      this._max = max;
      
      this.spacing = spacing;
      this.inner_bevel = inner_bevel;
      this.inner_colors = inner_colors;

      value_ip = new LinearIP(act, act);
      this.rate = 1.0 / rate;
      
      var alphas = new Array<Float>();
      var ratios = new Array<Float>();
      for (i in 0...colors.length) {
         alphas.push(1.0);
         ratios.push(255.0 * i / (colors.length - 1.0));
      }
      
      var mat: Matrix = new Matrix();
      mat.createGradientBox(height, width);
      mat.rotate(Math.PI / 2.0);
      
      out_bar = new Sprite();
      
      var gr: Graphics = out_bar.graphics;
      gr.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, mat);
      gr.drawRoundRect(0, 0, width, height, bevel);
      gr.endFill();

      out_bar.cacheAsBitmap = true;

      in_bar = new Sprite();
      
      inner_alphas = new Array<Float>();
      inner_ratios = new Array<Float>();
      for (i in 0...inner_colors.length) {
         inner_alphas.push(1.0);
         inner_ratios.push(255.0 * i / (inner_colors.length - 1.0));
      }
      
      inner_matrix = new Matrix();
      inner_matrix.createGradientBox(width - 2.0 * spacing, height - 2.0 * spacing);

      updateBar();

      addChild(out_bar);
      addChild(in_bar);
   }

   public function elapsedTime(dt: Float) {
      if (!ipAtTarget) {
         value_ip.elapsedTime(dt);
         updateBar();
      }
   }

   function updateBar() {
      var gr: Graphics = in_bar.graphics;

      gr.clear();
      gr.beginGradientFill(GradientType.LINEAR, inner_colors, inner_alphas, inner_ratios, inner_matrix);
      gr.drawRoundRect(spacing, spacing, (out_bar.width - 2.0 * spacing) * ipValue / _max, out_bar.height - 2.0 * spacing, inner_bevel);
      gr.endFill();
   }

   function getValue(): Float {
      return _value;
   }

   function setValue(val: Float): Float {
      val = val > _max ? _max : val;
      val = val < 0 ? 0 : val;
      value_ip.setTarget(val, rate);
      _value = val;
      
      return val;
   }

   function getIPValue(): Float {
      return value_ip.getValue();
   }

   function getIPAtTarget(): Bool {
      return value_ip.atTarget;
   }

   function getMax(): Float {
      return _max;
   }

   function setMax(m: Float): Float {
      max = m;
      updateBar();

      return m;
   }
}
