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
	public class RigidCollisionResolver{
		static public function resolve(pa,pb,hitpoint,normal,depth){
            var mtd:Vector = normal.mult(depth);           
            var te:Number = pa.elasticity + pb.elasticity;
            var sumInvMass:Number = pa.invMass + pb.invMass;
            
            // the total friction in a collision is combined but clamped to [0,1]
            var tf:Number = MathUtil.clamp(1 - (pa.friction + pb.friction), 0, 1);
            
            // get the collision components, vn and vt
            var ca:Collision = pa.getComponents(normal);
            var cb:Collision = pb.getComponents(normal);

             // calculate the coefficient of restitution as the normal component
            var vnA:Vector = (cb.vn.mult((te + 1) * pa.invMass).plus(
            		ca.vn.mult(pb.invMass - te * pa.invMass))).divEquals(sumInvMass);
            var vnB:Vector = (ca.vn.mult((te + 1) * pb.invMass).plus(
            		cb.vn.mult(pa.invMass - te * pb.invMass))).divEquals(sumInvMass);
            
            // apply friction to the tangental component
            ca.vt.multEquals(tf);
            cb.vt.multEquals(tf);
            
            // scale the mtd by the ratio of the masses. heavier particles move less 
            var mtdA:Vector = mtd.mult( pa.invMass / sumInvMass);     
            var mtdB:Vector = mtd.mult(-pb.invMass / sumInvMass);
            
            // add the tangental component to the normal component for the new velocity 
            vnA.plusEquals(ca.vt);
            vnB.plusEquals(cb.vt);
			//insert
			//friction
			//var vpa=pa.getVelocityOn(hitpoint);
			//var vpb=pb.getVelocityOn(hitpoint);
			//var dv=vpa.minus(vpb);
			//var vr=dv.minus(normal.mult(dv.dot(normal)));
			//var vra=vr.mult( depth*pa.invMass / sumInvMass);
			//var vrb=vr.mult(-depth*pb.invMass / sumInvMass);
			//rotation
			var dva=vnA.minus(pa.velocity);
			var dvb=vnB.minus(pb.velocity);
			var aaa=hitpoint.minus(pa.samp).cross(dva)/60;
			var aab=hitpoint.minus(pb.samp).cross(dvb)/60;
			//resolve it
			pa.resolveRigidCollision(aaa,new Vector(),pb);
			pb.resolveRigidCollision(aab,new Vector(),pa);
			//vnA.plusEquals(dva.mult(0.1));
			//vnB.plusEquals(dvb.mult(0.1));
			//end insert
			
			pa.resolveCollision(mtdA, vnA, normal, depth, -1, pb);
			pb.resolveCollision(mtdB, vnB, normal, depth,  1, pa);
			//


			/*var vpa=pa.getVelocityOn(hitpoint);
			var vpb=pb.getVelocityOn(hitpoint);
			//trace(vpa+" "+vpb);
			var v=vpa.minus(vpb);
			var vr=v.minus(normal.mult(v.dot(normal)));
            var mtd:Vector = normal.mult(depth);          
			var fc=pa.frictionalCoefficient/2+pb.frictionalCoefficient/2
			var fr=vr.normalize().multEquals(-mtd.magnitude()*fc/10);
			//trace(fr);
            var sumInvMass:Number = pa.invMass + pb.invMass;
            var mtda:Vector = mtd.mult( pa.invMass / sumInvMass).plusEquals(fr);     
            var mtdb:Vector = mtd.mult(-pb.invMass / sumInvMass).plusEquals(fr.mult(-1));
			var aaa:Number=hitpoint.minus(pa.samp).cross(mtda);
			var aab:Number=hitpoint.minus(pb.samp).cross(mtdb);
			//trace(mtd+" "+hitpoint.minus(pa.samp)+" "+aaa+" vs "+aab+" "+fr);
			//trace(vr+" "+fr);
			pa.resolveRigidCollision(aaa,fr,pb);
			pb.resolveRigidCollision(aab,fr.mult(-1),pa);*/
			/*var va=pa.velocity;
			var vb=pb.velocity;
			CollisionResolver.resolve(pa,pb,normal,depth);
			va=pa.velocity.minus(va);
			vb=pb.velocity.minus(vb);
			var aaa=hitpoint.minus(pa.samp).cross(va)/10;
			var aab=hitpoint.minus(pb.samp).cross(vb)/10;
			pa.resolveRigidCollision(aaa,new Vector(),pb);
			pb.resolveRigidCollision(aab,new Vector(),pa);*/
		}
	}
}