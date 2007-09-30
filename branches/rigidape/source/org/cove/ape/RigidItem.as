package org.cove.ape {
	
	public class RigidItem extends AbstractParticle implements IRigidItem{
		private var _angularVelocity:Number;
		private var _frictionalCoefficient:Number;
		private var _radian:Number;
		private var _range:Number;
		
		function RigidItem(
				x:Number, 
				y:Number, 
				range:Number,
				isFixed:Boolean, 
				mass:Number=1, 
				elasticity:Number=0.3,
				friction:Number=0,
				radian:Number=0,
				angularVelocity:Number=0) {
			_range=range;
			_frictionalCoefficient=friction;
			_radian=radian;
			_angularVelocity=angularVelocity;
			super(x,y,isFixed,mass,elasticity,0);
		}
		public override function init():void {
			cleanup();
			if (displayObject != null) {
				initDisplay();
			} else {
				drawShape(sprite.graphics);
			}
			paint();
		}
		public override function paint():void {
			sprite.x = curr.x;
			sprite.y = curr.y;
			sprite.rotation = angle;
		}	
		public function drawShape(graphics){}
		public function set frictionalCoefficient(n):void{
			_frictionalCoefficient=n;
		}
		public function get frictionalCoefficient():Number{
			return _frictionalCoefficient;
		}
		public function set radian(n:Number):void{
			_radian=n;
			setAxes(n);
		}
		public function get radian():Number{
			return _radian;
		}
		public function setAxes(n:Number):void{}
		public function set angularVelocity(n:Number):void{
			_angularVelocity=n;
		}
		public function get angularVelocity():Number{
			return _angularVelocity;
		}
		public function get angle():Number {
			return radian * MathUtil.ONE_EIGHTY_OVER_PI;
		}
		public function set angle(a:Number):void {
			radian = a * MathUtil.PI_OVER_ONE_EIGHTY;
		}
		public function get range():Number{
			return _range;
		}
		public override function update(dt2:Number):void {
			radian+=_angularVelocity*dt2;
			super.update(dt2);
		}
		public function resolveRigidCollision(aa:Number,
				mtd:Vector, vel:Vector, n:Vector, d:Number,
				o:int, p:AbstractParticle):void{
			_angularVelocity+=aa;
			resolveCollision(mtd,vel,n,d,o,p);
		}
		public function isInside(vertex:Vector):Boolean{
			return false;
		}
		public function checkRange(r:RigidItem):Boolean{
			return r.samp.minus(samp).magnitude()<=(range+r.range);
		}
	}
}