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
		internal static function resolve2 (pa, pb, normal:Vector, depth:Number):void {
			var hp=getHitPoint(pa,pb);
			if(hp==undefined){
				trace("miss");
				return;
			}
			var vpa=getVelocity(hp.minus(pa.samp),pa.av);
			var vpb=getVelocity(hp.minus(pb.samp),pb.av);
		}
		static public function getVelocity(arm,angular){
			var v=arm.normalize();
			return new Vector(-v.y,v.x).multEquals(angular*arm.magnitude());
		}
		static public function resolve(pa,pb,
									normal,depth,mtd,tf,mtdA,mtdB,vnA,vnB,ca,cb){
			var hp=getHitPoint(pa,pb);
			if(hp==undefined){
				trace("miss");
				return;
			}
			//trace(hp);
			var k=(pa.k+pb.k)/2;
			var arm=hp.minus(pa.samp)
			//trace(vnA+" "+pa.velocity);
			var dfa=ca.vt.normalize();
			var ffa=dfa.mult(-k*mtdA.magnitude());
			//vnA.plusEquals(ffa.mult(0.2));
			var aa=arm.cross(mtdA.plus(ffa));
			pa.resolveRigidCollision(aa,mtdA, vnA, normal, depth, -1, pb);
			//.plus(ca.vt.mult(0.5-0.5/tf))
			//.plusEquals(vnA.minus(pa.velocity));
			//aa.plusEquals();
			//trace(arm+" "+mtdA);
			//trace("a:"+aa);
			var dfb=cb.vt.normalize();
			var ffb=dfb.mult(-k*mtdB.magnitude());
			var ab=hp.minus(pb.samp).cross(mtdB.plus(ffb));
			//vnB.plusEquals(ffb.mult(0.2));
			pb.resolveRigidCollision(ab,mtdB, vnB, normal, depth,  1, pa);
			//mtdB.plus(cb.vt.mult(0.5-0.5/tf))
			//.plusEquals(vnB.minus(pb.velocity));;
			//trace("b:"+ab);
		}
		static public function getHitPoint(pa:RigidItem,pb:RigidItem):Vector{
			if(pa is RigidCircle && pb is RigidCircle){
				return getHitPointCC(pa as RigidCircle, pb as RigidCircle);
			}else{
				return getHitPointRR(pa, pb);
			}
		}
		static public function getHitPointCC(pa:RigidCircle,pb:RigidCircle){
			//if(pa.samp.distance(pb.samp)<=(pa.radius+pb.radius)){
			var hp=pb.samp.minus(pa.samp).normalize().multEquals(pa.radius).plusEquals(pa.samp);
			trace(hp);
			return hp;
			//}
		}
		static public function getHitPoints(hitPoints:Array, pa:RigidRectangle, pb){
			var diff=pa.samp.minus(pb.samp);
			var vertices=pb.getVertices(pa.getNormals());
			for(var i=0;i<vertices.length;i++){
				if(pa.isInside(vertices[i].minus(diff))){
					hitPoints.push(vertices[i].plus(pb.samp));
				}
			}
			/*var diff=pb.samp.minus(pa.samp);
			var avertices=pa.getVertices(pb.getNormals());
			for(var i=0;i<avertices.length;i++){
				if(pb.isInside(avertices[i].minus(diff))){
					hitPoints.push(avertices[i].plus(pa.samp));
				}
			}*/
		}
		static public function getHitPointR(pa,pb):Vector{
			var hitPoint=new Vector(0,0);
			var hitPoints=new Array();
			if(pa is RigidRectangle){
				getHitPoints(hitPoints,pa,pb);
			}
			if(pb is RigidRectangle){
				getHitPoints(hitPoints,pb,pa);
			}
			if(hitPoints.length>0){
				for(var i=0;i<hitPoints.length;i++){
					hitPoint.plusEquals(hitPoints[i]);
				}
				hitPoint.multEquals(1/hitPoints.length);
				return hitPoint;
			}else{
				return undefined;
			}
		}
		static public function getHitPointRR(pa,pb){
			var hitPoint=new Vector(0,0);
			var hitPoints=new Array;
			var i;
			var diff=pb.samp.minus(pa.samp);
			var avertices=pa.getVertices(pb.getNormals());
			for(i=0;i<avertices.length;i++){
				if(pb.isInside(avertices[i].minus(diff))){
					hitPoints.push(avertices[i].plus(pa.samp));
				}
			}
			var bvertices=pb.getVertices(pa.getNormals());
			for(i=0;i<bvertices.length;i++){
				if(pa.isInside(bvertices[i].plus(diff))){
					hitPoints.push(bvertices[i].plus(pb.samp));
				}
			}
			if(hitPoints.length>0){
				for(i=0;i<hitPoints.length;i++){
					hitPoint.plusEquals(hitPoints[i]);
				}
				hitPoint.multEquals(1/hitPoints.length);
				return hitPoint;
			}else{
				return undefined;
			}
		}
	}
}