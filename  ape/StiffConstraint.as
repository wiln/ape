package org.cove.ape {
	public class StiffConstraint extends SpringConstraint{
		private var halfRestLength;
		
		public function StiffConstraint(
				p1:AbstractParticle, 
				p2:AbstractParticle, 
				stiffness:Number = 1,
				breakable:Boolean = false,
				collidable:Boolean = false,
				rectHeight:Number = 1,
				rectScale:Number = 1,
				scaleToLength:Boolean = false) {
			
			super(p1, p2, stiffness, breakable, collidable, rectHeight, rectScale, scaleToLength);
			halfRestLength = currLength/2;
		}		
		
		public override function set restLength(r:Number):void {
			super.restLength = r;
			halfRestLength = r/2;
		}
		
		public override function resolve():void {
			//var midPoint:Vector = center;
			//var norm:Vector = delta.normalize();
			
			//p1.curr = midPoint.plus(norm.mult(halfRestLength));
			//p2.curr = midPoint.minus(norm.mult(halfRestLength));
			
			var deltaLength:Number = currLength;
			
			var diff:Number = (deltaLength - restLength) / (deltaLength * (p2.invMass));
			var dmds:Vector = delta.mult(diff * stiffness);
			
			//p1.curr.minusEquals(dmds.mult(p1.invMass));
			p2.curr.plusEquals (dmds.mult(p2.invMass));
		}
	}
}