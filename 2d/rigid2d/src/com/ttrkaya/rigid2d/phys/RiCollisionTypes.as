package com.ttrkaya.rigid2d.phys
{
	internal class RiCollisionTypes
	{
		private static const SHIFT_AMOUNT:int = 16;
		
		public static const CIRCLE_CIRCLE:uint = (RiBodyTypes.CIRCLE << SHIFT_AMOUNT) | RiBodyTypes.CIRCLE;
		
		public static const POLY_POLY:uint = (RiBodyTypes.POLYGON << SHIFT_AMOUNT) | RiBodyTypes.POLYGON;
		
		public static const POLY_CIRCLE:uint = (RiBodyTypes.POLYGON << SHIFT_AMOUNT) | RiBodyTypes.CIRCLE;
		public static const CIRCLE_POLY:uint = (RiBodyTypes.CIRCLE << SHIFT_AMOUNT) | RiBodyTypes.POLYGON;
		
		public static const POLY_SPOLY:uint = (RiBodyTypes.POLYGON  << SHIFT_AMOUNT) | RiBodyTypes.S_POLYGON;
		public static const SPOLY_POLY:uint = (RiBodyTypes.S_POLYGON  << SHIFT_AMOUNT) | RiBodyTypes.POLYGON;
		
		public static const CIRCLE_SPOLY:uint = (RiBodyTypes.CIRCLE  << SHIFT_AMOUNT) | RiBodyTypes.S_POLYGON;
		public static const SPOLY_CIRCLE:uint = (RiBodyTypes.S_POLYGON  << SHIFT_AMOUNT) | RiBodyTypes.CIRCLE;
		
		public static const POLY_SCIRCLE:uint = (RiBodyTypes.POLYGON  << SHIFT_AMOUNT) | RiBodyTypes.S_CIRCLE;
		public static const SCIRCLE_POLY:uint = (RiBodyTypes.S_CIRCLE  << SHIFT_AMOUNT) | RiBodyTypes.POLYGON;
		
		public static const CIRCLE_SCIRCLE:uint = (RiBodyTypes.CIRCLE  << SHIFT_AMOUNT) | RiBodyTypes.S_CIRCLE;
		public static const SCIRCLE_CIRCLE:uint = (RiBodyTypes.S_CIRCLE  << SHIFT_AMOUNT) | RiBodyTypes.CIRCLE;
		
		public static function get(type0:uint, type2:uint):uint
		{
			return (type0 << SHIFT_AMOUNT) | type2;
		}
	}
}