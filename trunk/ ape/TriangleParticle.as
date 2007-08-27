/*
Copyright (c) 2006, 2007 Alec Cove

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
	
	import flash.display.Graphics;
	
	/**
	 * A triangular shaped particle. 
	 */ 
	public class TriangleParticle extends AbstractParticle {
		
		private var _cornerPositions:Array;
		
		private var _extents:Array;
		private var _axes:Array;
		private var _radian:Number;
		
		private var _height:Number;
		private var _width:Number;
		
		
		/**
		 * @param x The initial x position.
		 * @param y The initial y position.
		 * @param width The width of this particle.
		 * @param height The height of this particle.
		 * @param rotation The rotation of this particle in radians.
		 * @param fixed Determines if the particle is fixed or not. Fixed particles
		 * are not affected by forces or collisions and are good to use as surfaces.
		 * Non-fixed particles move freely in response to collision and forces.
		 * @param mass The mass of the particle
		 * @param elasticity The elasticity of the particle. Higher values mean more elasticity.
		 * @param friction The surface friction of the particle. 
		 * <p>
		 * Note that TriangleParticles can be fixed but still have their rotation property 
		 * changed.
		 * </p>
		 */
		public function TriangleParticle (
				x:Number, 
				y:Number, 
				width:Number, 
				height:Number, 
				rotation:Number = 0, 
				fixed:Boolean = false,
				mass:Number = 1, 
				elasticity:Number = 0.3,
				friction:Number = 0) {
			
			super(x, y, fixed, mass, elasticity, friction);
			
			this.width = width;
			this.height = height;
			
			_extents = setExtents();
			_axes = new Array(new Vector(0,0), new Vector(0,0), new Vector(0,0));
			radian = rotation;
		}
		
		
		/**
		 * The rotation of the TriangleParticle in radians. For drawing methods you may 
		 * want to use the <code>angle</code> property which gives the rotation in
		 * degrees from 0 to 360.
		 * 
		 * <p>
		 * Note that while the TriangleParticle can be rotated, it does not have angular
		 * velocity. In otherwords, during collisions, the rotation is not altered, 
		 * and the energy of the rotation is not applied to other colliding particles.
		 * </p>
		 */
		public function get radian():Number {
			return _radian;
		}
		
		
		/**
		 * @private
		 */		
		public function set radian(t:Number):void {
			_radian = t;
			setAxes(t);
			if (_cornerPositions != null) updateCornerPositions();
		}
			
		
		/**
		 * The rotation of the TriangleParticle in degrees. 
		 */
		public function get angle():Number {
			return radian * MathUtil.ONE_EIGHTY_OVER_PI;
		}


		/**
		 * @private
		 */		
		public function set angle(a:Number):void {
			radian = a * MathUtil.PI_OVER_ONE_EIGHTY;
		}
			
		
		/**
		 * Sets up the visual representation of this TriangleParticle. This method is called 
		 * automatically when an instance of this TriangleParticle's parent Group is added to 
		 * the APEngine, when  this TriangleParticle's Composite is added to a Group, or the 
		 * TriangleParticle is added to a Composite or Group.
		 */				
		public override function init():void {
			cleanup();
			if (displayObject != null) {
				initDisplay();
			} else {
			
				var w:Number = extents[0] * 2;
				var h:Number = extents[1] * 2;
				var cp:Array = cornerPositions;
				
				sprite.graphics.clear();
				sprite.graphics.lineStyle(lineThickness, lineColor, lineAlpha);
				sprite.graphics.beginFill(fillColor, fillAlpha);
				sprite.graphics.moveTo(curr.x + cp[0].x, curr.y + cp[0].y);
				sprite.graphics.lineTo(curr.x + cp[1].x, curr.y + cp[1].y);
				sprite.graphics.lineTo(curr.x + cp[2].x, curr.y + cp[2].y);
				sprite.graphics.lineTo(curr.x + cp[0].x, curr.y + cp[0].y);
				//sprite.graphics.drawRect(-w/2, -h/2, w, h);
				sprite.graphics.endFill();
			}
			paint();
		}
		
		
		/**
		 * The default painting method for this particle. This method is called automatically
		 * by the <code>APEngine.paint()</code> method. If you want to define your own custom painting
		 * method, then create a subclass of this class and override <code>paint()</code>.
		 */	
		public override function paint():void {
			//sprite.x = curr.x;
			//sprite.y = curr.y;
			//sprite.rotation = angle;
		}
		
		
		public function set width(w:Number):void {
			//_extents[0] = w/2;
			_width = w;
		}

		
		public function get width():Number {
			//return _extents[0] * 2
			return _width;
		}


		public function set height(h:Number):void {
			//_extents[1] = h / 2;
			_height = h;
		}


		public function get height():Number {
			//return _extents[1] * 2
			return _height;
		}
				
		
		/**
		 * @private
		 */	
		internal function get axes():Array {
			return _axes;
		}
		

		/**
		 * @private
		 */	
		internal function get extents():Array {
			return _extents;
		}
		
		
		/**
		 * @private
		 */	
		internal function getProjection(axis:Vector):Interval {
			
			var c:Number = curr.dot(axis);
			var cp:Array = cornerPositions;
						
			var rad0 = cp[0].dot(axis);
			var rad1 = cp[1].dot(axis);
			var rad2 = cp[2].dot(axis);
					
			var negRad = Math.min(rad0, rad1, rad2);
			var posRad = Math.max(rad0, rad1, rad2);
			
			interval.min = c + negRad;
			interval.max = c + posRad;
			
			return interval;
		}


		/**
		 * 
		 */					
		private function setAxes(t:Number):void {
			var s:Number = Math.sin(t);
			var c:Number = Math.cos(t);
			
			var ang = Math.atan(-height/(width/2));
			
			var s1:Number = Math.sin(ang+t);
			var c1:Number = Math.cos(ang+t);
			
			var ang2 = -ang;
			var s2:Number = Math.sin(ang2+t);
			var c2:Number = Math.cos(ang2+t);
			
			axes[0].x = -s;
			axes[0].y = c;
			axes[1].x = s1;
			axes[1].y = -c1;
			axes[2].x = s2;
			axes[2].y = -c2;
		}
		
		/**
		 * 
		 */
		private function setExtents():Array{
			var e0 = height/3;
			var e1 = Math.sqrt(Math.pow(width/4,2) + Math.pow(height/6, 2));
			var e2 = e1;
			var ext:Array = new Array(e0, e1, e2);
			return ext;
		}
		
		public function get cornerPositions():Array {
					
			if (_cornerPositions == null) {
				_cornerPositions = new Array(
						new Vector(0,0), 
						new Vector(0,0),
						new Vector(0,0));	
				updateCornerPositions();
			}
			return _cornerPositions;
		}
		
		/**
		 * @private
		 */	
		internal function updateCornerPositions():void {
			
			var o0x = curr.x;
			var o0y = curr.y - height*2/3;
			var diff0x = o0x - curr.x;
			var diff0y = o0y - curr.y;
			var d0 = Math.sqrt(Math.pow(diff0x, 2)+Math.pow(diff0y,2));
			var ang0 = Math.atan2(diff0y, diff0x);

			ang0 += radian;
		
			var n0x = Math.cos(ang0)*d0;
			var n0y = Math.sin(ang0)*d0;
			
			var o1x = curr.x + width/2;
			var o1y = curr.y + height/3;
			var diff1x = o1x - curr.x;
			var diff1y = o1y - curr.y;
			var d1 = Math.sqrt(Math.pow(diff1x, 2)+Math.pow(diff1y,2));
			var ang1 = Math.atan2(diff1y, diff1x);

			ang1 += radian;
		
			var n1x = Math.cos(ang1)*d1;
			var n1y = Math.sin(ang1)*d1;
			
			var o2x = curr.x - width/2;
			var o2y = curr.y + height/3;
			var diff2x = o2x - curr.x;
			var diff2y = o2y - curr.y;
			var d2 = Math.sqrt(Math.pow(diff2x, 2)+Math.pow(diff2y,2));
			var ang2 = Math.atan2(diff2y, diff2x);

			ang2 += radian;
		
			var n2x = Math.cos(ang2)*d2;
			var n2y = Math.sin(ang2)*d2;
			
			_cornerPositions[0].x = n0x;
			_cornerPositions[0].y = n0y;
			_cornerPositions[1].x = n1x;
			_cornerPositions[1].y = n1y;
			_cornerPositions[2].x = n2x;
			_cornerPositions[2].y = n2y;
			
		}
	}
}