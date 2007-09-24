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
			return new Vector(0,0);
		}
		private function findHitPointOBB(p:RectangleParticle):Vector{
			var saxis:Array=new Array(axes[0],
									  axes[1],
									  axes[0].mult(-1),
									  axes[1].mult(-1));
			var sides:Array=new Array(saxis[0].mult(extents[0]),
									  saxis[1].mult(extents[1]),
									  saxis[2].mult(extents[0]),
									  saxis[3].mult(extents[1]));
			var vertices:Array=new Array(sides[0].plus(sides[1]),
										 sides[1].plus(sides[2]),
										 sides[2].plus(sides[3]),
										 sides[3].plus(sides[0]));
			var diff:Vector=p.curr.minus(curr);
			var paxis:Array=new Array(p.axes[0],
									  p.axes[1],
									  p.axes[0].mult(-1),
									  p.axes[1].mult(-1));
			var psides:Array=new Array(paxis[0].mult(p.extents[0]),
									   paxis[1].mult(p.extents[1]),
									   paxis[2].mult(p.extents[0]),
									   paxis[3].mult(p.extents[1]));
			var pvertices:Array=new Array(psides[0].plus(psides[1]),
										  psides[1].plus(psides[2]),
										  psides[2].plus(psides[3]),
										  psides[3].plus(psides[0]));
			var i,j;
			for(i=0;i<4;i++){
				psides[i].plusEquals(diff);
				pvertices[i].plusEquals(diff);
			}
			/*trace(saxis)
			trace(sides)
			trace(vertices)
			trace(paxis)
			trace(psides)
			trace(pvertices)*/
			var hitpoints:Array=new Array();
			var hit;
			for(i=0;i<4;i++){
				hit=true;
				//trace(i);
				for(j=0;j<4;j++){
					//trace(vertices[i]+" vs "+paxis[j]+" = "+vertices[i].minus(psides[j]).dot(paxis[j]));
					if(vertices[i].minus(psides[j]).dot(paxis[j])>0.01){
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
					//trace(pvertices[i]+" vs "+saxis[j]+" = "+pvertices[i].minus(sides[j]).dot(saxis[j]));
					if(pvertices[i].minus(sides[j]).dot(saxis[j])>0.01){
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
			super.resolveCollision(mtd,vel,n,d,o,p);
			var arm=findHitPoint(p)
			if(arm==undefined){
				return;
			}
			//.minusEquals(curr);
			var aa=arm.cross(mtd);
			_av+=aa;
			/*if(p is RectangleParticle){
				var pr=p as RectangleParticle;
				var vertices:Array;
				var base:Vector;
				var comp;
				var vertex=0;
				var test,i;
				//trace(n+" "+axes[0]+" "+axes[1]+" "+pr.axes[0]+" "+pr.axes[1]);
				//trace(n.equals(axes[0])+" "+n.equals(axes[1])+" "+n.equals(pr.axes[0])+" "+n.equals(pr.axes[1]))
				if((n.equals(axes[0]) || n.equals(axes[1])) && !n.equals(pr.axes[0]) && !n.equals(pr.axes[1])) {
					//check vertices of pr
					//trace("pr");
					base=pr.curr;
					vertices=new Array(pr.axes[0].mult(pr.extents[0]).plusEquals(pr.axes[1].mult(pr.extents[1])),
											pr.axes[0].mult(pr.extents[0]).plusEquals(pr.axes[1].mult(-pr.extents[1])),
											pr.axes[0].mult(-pr.extents[0]).plusEquals(pr.axes[1].mult(pr.extents[1])),
											pr.axes[0].mult(-pr.extents[0]).plusEquals(pr.axes[1].mult(-pr.extents[1])));
					comp=999999;
					var nn=n.rotate(angle);
					for(i=0;i<vertices.length;i++){
						test=nn.dot(vertices[i]);
						if(test<comp){
							vertex=i;
							comp=test;
						}
					}
				}else{
					//check vertices of myself
					//trace("self");
					base=curr;
					vertices=new Array(axes[0].mult(extents[0]).plusEquals(axes[1].mult(extents[1])),
											axes[0].mult(extents[0]).plusEquals(axes[1].mult(-extents[1])),
											axes[0].mult(-extents[0]).plusEquals(axes[1].mult(extents[1])),
											axes[0].mult(-extents[0]).plusEquals(axes[1].mult(-extents[1])));
					comp=-999999;
					for(i=0;i<vertices.length;i++){
						test=n.dot(vertices[i]);
						if(test>comp){
							vertex=i;
							comp=test;
						}
					}
				}
				//trace(vertices);
				//trace(vertex+" "+comp);
				var arm=vertices[vertex].plus(base).minusEquals(curr);
				//trace(arm);
				var aa=arm.cross(mtd);
				if(arm.magnitude()>25){
					//trace("note! "+aa+" "+arm.magnitude()+" "+arm+" "+vertex);
					return;
				}
				_av+=aa;
			}else if(p is CircleParticle){
				var pc=p as CircleParticle;
			}*/
		}
	}
}