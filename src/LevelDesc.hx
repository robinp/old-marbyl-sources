/*
 File created by Template 
*/

class LevelDesc{

	public var enabledColors : Null<Int>;

	public var avg_speed : Float;
	public var diff_speed : Float;
	
   public var avg_gentime : Float;
	public var diff_gentime : Float;

   public var avg_size : Float;
	public var diff_size : Float;
   
   public var cur_max_size : Float;
   public var cur_grow_size : Float;

   public var shape : Null<Int>;
   public var diam_score : Null<Int>;

   public var level_time : Float;

	public function new(xml : Xml, ?ld : LevelDesc){

      level_time = Std.parseFloat( xml.get("time") );

		for (d in xml.elementsNamed("diams")) {
			enabledColors = Std.parseInt( d.get("colors") );

			avg_speed = Std.parseFloat( d.get("avg_speed") );
			diff_speed = Std.parseFloat( d.get("diff_speed") );

			avg_gentime = Std.parseFloat( d.get("avg_gentime") );
			diff_gentime = Std.parseFloat( d.get("diff_gentime") );
			
         avg_size = Std.parseFloat( d.get("avg_size") );
			diff_size = Std.parseFloat( d.get("diff_size") );
			
         shape = Std.parseInt( d.get("shape") );
         diam_score = Std.parseInt( d.get("diam_score") );
		}
		for (c in xml.elementsNamed("cursor")) {
			cur_max_size = Std.parseFloat( c.get("max_size") );
			cur_grow_size = Std.parseFloat( c.get("grow_size") );
		}

      if (ld != null) {
         /* TODO: Ezt reflection-nel.. */

         if (Math.isNaN(level_time)) level_time = ld.level_time;

         if (enabledColors == null) enabledColors = ld.enabledColors;
         if (shape == null) shape = ld.shape;
         if (diam_score == null) diam_score = ld.diam_score;

         if (Math.isNaN(avg_speed)) avg_speed = ld.avg_speed;
         if (Math.isNaN(diff_speed)) diff_speed = ld.diff_speed;
         
         if (Math.isNaN(avg_gentime)) avg_gentime = ld.avg_gentime * ld.avg_speed;
         if (Math.isNaN(diff_gentime)) diff_gentime = ld.diff_gentime * ld.avg_speed;

         if (Math.isNaN(avg_size)) avg_size = ld.avg_size;
         if (Math.isNaN(diff_size)) diff_size = ld.diff_size;

         if (Math.isNaN(cur_max_size)) cur_max_size = ld.cur_max_size;
         if (Math.isNaN(cur_grow_size)) cur_grow_size = ld.cur_grow_size;
      }

      avg_gentime /= avg_speed;
      diff_gentime /= avg_speed;

	}
	
}
