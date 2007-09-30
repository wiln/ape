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
	public class RigidCircle extends RigidItem{
		private var _radius;
		
		function RigidCircle(
				x:Number, 
				y:Number, 
				radius:Number,
				isFixed:Boolean=false, 
				mass:Number=1, 
				elasticity:Number=0.3,
				friction:Number=0,
				radian:Number=0,
				angularVelocity:Number=0) {
			_radius=radius;
			super(x,y,radius,isFixed,mass,elasticity,friction,radian,angularVelocity);
		}
		public function get radius():Number{
			return _radius;
		}
		public override function drawShape(graphics){
			graphics.clear();
			graphics.lineStyle(lineThickness, lineColor, lineAlpha);
			graphics.beginFill(fillColor, fillAlpha);
			graphics.drawCircle(0, 0, radius);
			graphics.moveTo(radius,0);
			graphics.lineTo(-radius,0);
			graphics.moveTo(0,radius);
			graphics.lineTo(0,-radius);
			graphics.endFill();
		}
		public override function isInside(vertex:Vector):Boolean{
			return vertex.magnitude()<=radius;
		}
		public function getVertices(axis:Array):Array{
			var vertices=new Array();
			for(var i=0;i<axis.length;i++){
				vertices.push(axis[i].mult(radius));
			}
			return vertices;
		}
		internal function getProjection(axis:Vector):Interval {
			var c:Number = samp.dot(axis);
			interval.min = c - _radius;
			interval.max = c + _radius;
			
			return interval;
		}
	}
	/*public class RigidCircle extends CircleParticle implements IRigidItem{
		private var _av:Number;
		private var _vertices:Array;
		private var _rigidFriction:Number;
		private var _normals:Array;
		private var _radian:Number;

		public function RigidCircle (
				x:Number, 
				y:Number, 
				radius:Number, 
				fixed:Boolean = false,
				mass:Number = 1, 
				elasticity:Number = 0.3,
				friction:Number = 0) {
			super(x, y, radius, fixed, mass, elasticity, 0);
			_av=0;
			radian = 0;
			_rigidFriction=friction;
			_normals=new Array();
		}
		public override function init():void {
			cleanup();
			if (displayObject != null) {
				initDisplay();
			} else {
				sprite.graphics.clear();
				sprite.graphics.lineStyle(lineThickness, lineColor, lineAlpha);
				sprite.graphics.beginFill(fillColor, fillAlpha);
				sprite.graphics.drawCircle(0, 0, radius);
				sprite.graphics.moveTo(radius,0);
				sprite.graphics.lineTo(-radius,0);
				sprite.graphics.moveTo(0,radius);
				sprite.graphics.lineTo(0,-radius);
				sprite.graphics.endFill();
			}
			paint();
		}
		public override function paint():void {
			sprite.x = curr.x;
			sprite.y = curr.y;
			sprite.rotation = angle;
		}
		public function get radian():Number {
			return _radian;
		}
		public function set radian(t:Number):void {
			_radian = t;
		}
		public function get angle():Number {
			return radian * MathUtil.ONE_EIGHTY_OVER_PI;
		}
		public function set angle(a:Number):void {
			radian = a * MathUtil.PI_OVER_ONE_EIGHTY;
		}
		public override function update(dt2:Number):void {
			radian+=_av*dt2;
			super.update(dt2);
		}
		public function isInside(vertex:Vector):Boolean{
			//trace("c is inside "+vertex+" "+vertex.magnitude()+" "+radius);
			return vertex.magnitude()<=radius;
		}
		public function getVertices(axis:Array):Array{
			var vertices=new Array();
			for(var i=0;i<axis.length;i++){
				vertices.push(axis[i].mult(radius));
			}
			return vertices;
		}
		public function getNormals():Array{
			return _normals;
		}
		public function resolveRigidCollision(
				aa:Number, mtd:Vector, vel:Vector, n:Vector, 
				d:Number, o:int, p:AbstractParticle):void {
			_av+=aa * MathUtil.PI_OVER_ONE_EIGHTY;
			resolveCollision(mtd,vel,n,d,o,p);
		}
		public function set k(n:Number){
			_rigidFriction=n;
		}
		public function get k():Number{
			return _rigidFriction;
		
	}}*/
}