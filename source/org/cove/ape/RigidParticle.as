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
	
	public class RigidParticle extends RectangleParticle {
	
		private var _av:Number;
		private var _vertices:Array;
		
		public function RigidParticle (
				x:Number, 
				y:Number, 
				width:Number, 
				height:Number, 
				rotation:Number = 0, 
				fixed:Boolean = false,
				mass:Number = 1, 
				elasticity:Number = 0.3,
				friction:Number = 0) {
			
			super(x, y, width,height,rotation,fixed, mass, elasticity, friction);
			_av=0;
			_vertices=new Array(new Vector(extents[0],-extents[1]),
								new Vector(extents[0],extents[1]),
								new Vector(-extents[0],extents[1]),
								new Vector(-extents[0],-extents[1]));
		}
		public override function update(dt2:Number):void {
			angle+=_av*dt2;
			super.update(dt2);
		}
		private function findHitPoint(p:AbstractParticle):Vector{
			if(p is RectangleParticle){
				return findHitPointOBB(p as RectangleParticle);
			}else if(p is CircleParticle){
				return findHitPointCircle(p as CircleParticle);
			}
			return new Vector(0,0);
		}
		private function findHitPointCircle(p:CircleParticle){
			var normals:Array=new Array(axes[0],
									  axes[1],
									  axes[0].mult(-1),
									  axes[1].mult(-1));
			var sides:Array=new Array(normals[0].mult(extents[0]),
									  normals[1].mult(extents[1]),
									  normals[2].mult(extents[0]),
									  normals[3].mult(extents[1]));
			var vertices:Array=new Array(sides[0].plus(sides[1]),
										 sides[1].plus(sides[2]),
										 sides[2].plus(sides[3]),
										 sides[3].plus(sides[0]));
			var i;
			for(i=0;i<4;i++){
				if(vertices[i].plus(curr).distance(p.curr)<=p.radius){
					return vertices[i]
				}
			}
			var c=p.curr.minus(curr);
			var j;
			for(i=0;i<4;i++){
				var hit=true;
				//var dotoncircle=new Vector(0,0);
				//this is the farest dot of the circle on normals[i] direction
				var dotoncircle=p.curr.minus(normals[i].mult(p.radius)).minus(curr);
				for(j=0;j<4;j++){
					//check if dotoncircle is on the other side of the border
					var test=dotoncircle.minus(sides[j]).dot(normals[j]);
					//trace(normals[j]+" "+sides[j]);
					//trace(p.curr.minus(curr)+" "+dotoncircle+" "+test);
					if(test>=0.01){
						hit=false;
						break;
					}
				}
				if(hit){
					return dotoncircle;
				}
			}
			//trace("not hit");
			return new Vector(0,0);
		}
		private function findHitPointOBB(p:RectangleParticle):Vector{
			//get normals, side center and vertices for this particle
			var normals:Array=new Array(axes[0],
									  axes[1],
									  axes[0].mult(-1),
									  axes[1].mult(-1));
			var sides:Array=new Array(normals[0].mult(extents[0]),
									  normals[1].mult(extents[1]),
									  normals[2].mult(extents[0]),
									  normals[3].mult(extents[1]));
			var vertices:Array=new Array(sides[0].plus(sides[1]),
										 sides[1].plus(sides[2]),
										 sides[2].plus(sides[3]),
										 sides[3].plus(sides[0]));
			var diff:Vector=p.curr.minus(curr);
			//get normals, side center and vertices for the other particle
			var pnormals:Array=new Array(p.axes[0],
									  p.axes[1],
									  p.axes[0].mult(-1),
									  p.axes[1].mult(-1));
			var psides:Array=new Array(pnormals[0].mult(p.extents[0]),
									   pnormals[1].mult(p.extents[1]),
									   pnormals[2].mult(p.extents[0]),
									   pnormals[3].mult(p.extents[1]));
			var pvertices:Array=new Array(psides[0].plus(psides[1]),
										  psides[1].plus(psides[2]),
										  psides[2].plus(psides[3]),
										  psides[3].plus(psides[0]));
			var i,j;
			//transform colliding particle's side center and vertices' coordinates to this particle's center
			for(i=0;i<4;i++){
				psides[i].plusEquals(diff);
				pvertices[i].plusEquals(diff);
			}
			/*trace(normals)
			trace(sides)
			trace(vertices)
			trace(pnormals)
			trace(psides)
			trace(pvertices)*/
			var hitpoints:Array=new Array();
			var hit;
			for(i=0;i<4;i++){
				hit=true;
				//trace(i);
				for(j=0;j<4;j++){
					//trace(vertices[i]+" vs "+pnormals[j]+" = "+vertices[i].minus(psides[j]).dot(pnormals[j]));
					//check if this particle's vertices are inside colliding particle
					if(vertices[i].minus(psides[j]).dot(pnormals[j])>0.01){
						hit=false;
						break;
					}
				}
				if(hit){
					hitpoints.push(vertices[i]);
				}
			}
			//trace("p");
			for(i=0;i<4;i++){
				hit=true;
				//trace(i);
				for(j=0;j<4;j++){
					//trace(pvertices[i]+" vs "+normals[j]+" = "+pvertices[i].minus(sides[j]).dot(normals[j]));
					//check if the colliding particle's vertices are inside this particle
					if(pvertices[i].minus(sides[j]).dot(normals[j])>0.01){
						hit=false;
						break;
					}
				}
				if(hit){
					hitpoints.push(pvertices[i]);
				}
			}
			//trace(hitpoints);
			var hitpoint:Vector=new Vector(0,0);
			for(i=0;i<hitpoints.length;i++){
				hitpoint.plusEquals(hitpoints[i]);
			}
			if(hitpoints.length>0){
				hitpoint.multEquals(1/hitpoints.length);
			}
			return hitpoint;
		}
		internal override function resolveCollision(
				mtd:Vector, vel:Vector, n:Vector, d:Number, o:int, p:AbstractParticle):void {
			var arm=findHitPoint(p)
			if(arm==undefined){
				super.resolveCollision(mtd,vel,n,d,o,p);
				return;
			}
			//.minusEquals(curr);
			var aa=arm.cross(mtd);
			_av+=aa;
			super.resolveCollision(mtd,vel,n,d,o,p);
		}
	}
}