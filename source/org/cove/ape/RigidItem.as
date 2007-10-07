package org.cove.ape {
	
	public class RigidItem extends AbstractParticle{
		private var _angularVelocity:Number;
		private var _frictionalCoefficient:Number;
		private var _radian:Number;
		private var _prevRadian:Number;
		private var torque:Number;
		private var _range:Number;
		
		function RigidItem(
				x:Number, 
				y:Number, 
				range:Number,
				isFixed:Boolean, 
				mass:Number=1, 
				elasticity:Number=0.3,
				friction:Number=0.2,
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
			_angularVelocity*=0.99;
			radian+=_angularVelocity*dt2;
			super.update(dt2);
		}
		public function resolveRigidCollision(aa:Number,fr:Vector,p):void{
			if (fixed || (! solid) || (! p.solid)) return;
			_angularVelocity+=aa/10;
			//curr.plusEquals(fr);
		}
		public function captures(vertex:Vector):Boolean{
			var d=vertex.distance(samp)-range;
			//trace(d);
			if(d<=0){
				return true;
			}else{
				return false;
			}
		}
		public function getVelocityOn(vertex:Vector){
			//trace(vertex);
			var arm=vertex.minus(samp);
			var v=arm.normalize();
			return new Vector(-v.y,v.x).multEquals(_angularVelocity*arm.magnitude()).plusEquals(velocity);
		}
	}
}