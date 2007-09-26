package org.cove.ape {
	
	public interface IRigidItem{
		function isInside(vertex:Vector):Boolean;
		function getVertices(axis:Array):Array;
		function set k(n:Number);
		function get k():Number;
	}
}