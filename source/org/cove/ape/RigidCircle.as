/*
Copyright (c)2007 Frank Li
miian.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this 
software and associated documentation files (the "Software"), to deal in the Software 
without restriction, including without limitation the rights to use, copy, modify, 
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to 
permit persons to whom the Software is furnished to do so, subject to the following 
conditions:

The above copyright notice and this permission notice shall be included in all copies 
or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package org.cove.ape {
	
	public class RigidCircle extends CircleParticle implements RigidItem{
		private var _vertices:Array;
		internal function isInside(vertex:Vector):Boolean{
			return vertex.distance(curr)<=radius;
		}
		internal function getVertices(axis:Array):Array{
			var vertices=new Array();
			for(var i=0;i<axis.length;i++){
				vertices.push(curr.plus(axis.mult(radius)));
			}
			return vertices;
		}
		public function set k(n:Number){
			_rigidFriction=n;
		}
		public function get k():Number{
			return _rigidFriction;
		}
	}
}