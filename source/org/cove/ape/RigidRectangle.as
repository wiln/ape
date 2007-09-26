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
	
	public class RigidRectangle extends RectangleParticle implements IRigidItem{
		private var _av:Number;
		private var _vertices:Array;
		private var _marginCenters:Array;
		private var _normals:Array;
		private var _rigidFriction:Number;
		
		public function RigidRectangle (
				x:Number, 
				y:Number, 
				width:Number, 
				height:Number, 
				rotation:Number = 0, 
				fixed:Boolean = false,
				mass:Number = 1, 
				elasticity:Number = 0.3,
				friction:Number = 0) {
			
			_normals=new Array();
			_marginCenters=new Array();
			_vertices=new Array();
			_rigidFriction=friction;
			for(var i=0;i<4;i++){
				_normals.push(new Vector(0,0));
				_marginCenters.push(new Vector(0,0));
				_vertices.push(new Vector(0,0));
			}
			_av=0;
			super(x, y, width,height,rotation,fixed, mass, elasticity, 0);
		}
		public function isInside(vertex:Vector):Boolean{
			for(var i=0;i<_marginCenters.length;i++){
				var x=vertex.minus(_marginCenters[i]).dot(_normals[i])
				if(x>0.01){
					return false;
				}
			}
			return true;
		}
		public function getVertices(axis:Array):Array{
			return _vertices;
		}
		internal function getNormals():Array{
			return _normals;
		}
		internal function getMarginCenters():Array{
			return _marginCenters;
		}
		public function set k(n:Number){
			_rigidFriction=n;
		}
		public function get k():Number{
			return _rigidFriction;
		}
		public override function update(dt2:Number):void {
			angle+=_av*dt2;
			super.update(dt2);
		}
		internal function resolveRigidCollision(
				aa:Number, mtd:Vector, vel:Vector, n:Vector, 
				d:Number, o:int, p:AbstractParticle):void {
			_av+=aa;
			resolveCollision(mtd,vel,n,d,o,p);
		}
		//private function setAxes(t:Number):void
		internal override function setAxes(t:Number):void {
			super.setAxes(t);
			_normals[0].copy(axes[0]);
			_normals[1].copy(axes[1]);
			_normals[2]=axes[0].mult(-1);
			_normals[3]=axes[1].mult(-1);
			//.plusEquals(curr)
			_marginCenters[0]=axes[0].mult( extents[0]);
			_marginCenters[1]=axes[1].mult( extents[1]);
			_marginCenters[2]=axes[0].mult(-extents[0]);
			_marginCenters[3]=axes[1].mult(-extents[1]);
			//.minusEquals(curr)
			_vertices[0]=_marginCenters[0].plus(_marginCenters[1]);
			_vertices[1]=_marginCenters[1].plus(_marginCenters[2]);
			_vertices[2]=_marginCenters[2].plus(_marginCenters[3]);
			_vertices[3]=_marginCenters[3].plus(_marginCenters[0]);
		}
	}
}