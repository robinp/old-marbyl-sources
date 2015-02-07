/**
 * Implementation of the Park Miller (1988) "minimal standard" linear 
 * congruential pseudo-random number generator.
 * 
 * For a full explanation visit: http://www.firstpr.com.au/dsp/rand31/
 * 
 * The generator uses a modulus constant (m) of 2^31 - 1 which is a
 * Mersenne Prime number and a full-period-multiplier of 16807.
 * Output is a 31 bit unsigned integer. The range of values output is
 * 1 to 2,147,483,646 (2^31-1) and the seed must be in this range too.
 * 
 * David G. Carta's optimisation which needs only 32 bit integer math,
 * and no division is actually *slower* in flash (both AS2 & AS3) so
 * it's better to use the double-precision floating point version.
 * 
 * @author Michael Baczynski, www.polygonal.de
 */
package de.polygonal.math;

class Prng
{
   /**
    * set seed with a 31 bit unsigned integer
    * between 1 and 0X7FFFFFFE inclusive. don't use 0!
    */
   public var seed : UInt;
   
   public function new(seed : Int = 1)
   {
      if (seed == 0)
         seed = 1;
      this.seed = seed;
   }
   
   /**
    * provides the next pseudorandom number
    * as an unsigned integer (31 bits)
    */
   public inline function nextInt() : UInt
   {
      return gen();
   }
   
   /**
    * provides the next pseudorandom number
    * as a float between nearly 0 and nearly 1.0.
    */
   public inline function nextDouble() : Float
   {
      return (gen() / 2147483647.0);
   }
   
   /**
    * provides the next pseudorandom number
    * as an unsigned integer (31 bits) betweeen
    * a given range.
    */
   public function nextIntRange(mn  : Int, mx : Int) : UInt
   {
      var min = mn - 0.4999;
      var max = mx - 0.4999;
      return Math.round(min + ((max - min) * nextDouble()));
   }
   
   /**
    * provides the next pseudorandom number
    * as a float between a given range.
    */
   public inline function nextDoubleRange(min : Float, max : Float) : Float
   {
      return min + ((max - min) * nextDouble());
   }
   
   /**
    * generator:
    * new-value = (old-value * 16807) mod (2^31 - 1)
    */
   private inline function gen() : UInt
   {
      //integer version 1, for max int 2^46 - 1 or larger.
      seed = (seed * 16807) % 2147483647;
      return seed;
      
      /**
       * integer version 2, for max int 2^31 - 1 (slowest)
       */
      //var test:int = 16807 * (seed % 127773 >> 0) - 2836 * (seed / 127773 >> 0);
      //return seed = (test > 0 ? test : test + 2147483647);
      
      /**
       * david g. carta's optimisation is 15% slower than integer version 1
       */
      //var hi:uint = 16807 * (seed >> 16);
      //var lo:uint = 16807 * (seed & 0xFFFF) + ((hi & 0x7FFF) << 16) + (hi >> 15);
      //return seed = (lo > 0x7FFFFFFF ? lo - 0x7FFFFFFF : lo);
   }
}
