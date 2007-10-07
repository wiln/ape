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
			var va=pa.velocity;
			var vb=pb.velocity;
			CollisionResolver.resolve(pa,pb,normal,depth);
			va=pa.velocity.minus(va);
			vb=pb.velocity.minus(vb);
			var aaa=hitpoint.minus(pa.samp).cross(va)/10;
			var aab=hitpoint.minus(pb.samp).cross(vb)/10;
			pa.resolveRigidCollision(aaa,new Vector(),pb);
			pb.resolveRigidCollision(aab,new Vector(),pa);
		}
	}
}