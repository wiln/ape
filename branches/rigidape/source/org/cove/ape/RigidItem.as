package org.cove.ape {
	
	public class RigidItem extends AbstractParticle{
		private var _angularVelocity:Number;
		private var _frictionalCoefficient:Number;
		private var _radian:Number;
		private var _prevRadian:Number;
		private var torque:Number;
		private var _range:Number;
		private var _mi:Number;
		
		function RigidItem(
				x:Number, 
				y:Number, 
				range:Number,
				isFixed:Boolean, 
				mass:Number=1,
				mi:Number=-1,
				elasticity:Number=0.3,
				friction:Number=0.2,
				radian:Number=0,
				angularVelocity:Number=0) {
			_range=range;
			_frictionalCoefficient=friction;
			_radian=radian;
			_angularVelocity=angularVelocity;
			torque=0;
			if(mi==-1){
				_mi=mass;
			}else{
				_mi=mi;
			}
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
		public function get mi():Number{
			return _mi;
		}
		public override function update(dt2:Number):void {
			//_angularVelocity*=0.99;
			//angularVelocity+=torque;
			radian+=angularVelocity*APEngine.damping;
			super.update(dt2);
			torque=0;
		}
		public function addTorque(aa){
			//torque+=aa;
			angularVelocity+=aa;
		}
		public function resolveRigidCollision(aa:Number,fr:Vector,p):void{
			if (fixed || (! solid) || (! p.solid)) return;
			addTorque(aa);
			//_angularVelocity+=aa/10;
			//_torque=aa;
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
			var r=angularVelocity*arm.magnitude();
			var d=new Vector(-v.y,v.x).multEquals(r)
			return d.plusEquals(velocity);
		}
	}
}