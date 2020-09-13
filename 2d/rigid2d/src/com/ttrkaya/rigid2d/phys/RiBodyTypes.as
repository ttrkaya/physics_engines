package com.ttrkaya.rigid2d.phys
{
	internal class RiBodyTypes
	{
		public static const CIRCLE:uint = 0x1;
		public static const POLYGON:uint = 0x2;
		
		public static const STATIC:uint =  0x10;
		
		public static const S_POLYGON:uint = POLYGON | STATIC;
		public static const S_CIRCLE:uint = CIRCLE | STATIC;
	}
}