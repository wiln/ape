﻿/*
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
				friction:Number=0.2,
				radian:Number=0,
				angularVelocity:Number=0) {
			_radius=radius;
			super(x,y,radius,isFixed,mass*radius*radius/2,elasticity,friction,radian,angularVelocity);
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
		public function getVertices(axis:Array):Array{
			var vertices=new Array();
			for(var i=0;i<axis.length;i++){
				vertices.push(axis[i].mult(radius).plusEquals(samp));
			}
			return vertices;
		}
		internal function getProjection(axis:Vector):Interval {
			var c:Number = samp.dot(axis);
			interval.min = c - _radius;
			interval.max = c + _radius;
			
			return interval;
		}
		
		/**
		 * @private
		 */
		internal function getIntervalX():Interval {
			interval.min = samp.x - _radius;
			interval.max = samp.x + _radius;
			return interval;
		}
		
		
		/**
		 * @private
		 */		
		internal function getIntervalY():Interval {
			interval.min = samp.y - _radius;
			interval.max = samp.y + _radius;
			return interval;
		}
	}
}