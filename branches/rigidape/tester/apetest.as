package{
	import org.cove.ape.*;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class apetest extends Sprite{
		private var balls:Group;
		private var ball:RigidRectangle;
		private var p1,p2,p3,p4;
		private var s1,s2,s3,s4,s5;
		
		function apetest(){
			APEngine.init(1/4);
			APEngine.container = this;
			APEngine.addForce(new VectorForce(false,0, 0.5));//Massless
			var wall:RigidRectangle = new RigidRectangle(640, 240, 100, 480, 0, true);
			var wall2:RigidRectangle = new RigidRectangle(0, 240, 100, 480, 0, true);
			var ground = new RigidRectangle(320, 480, 640, 100, 0, true);
			
			var surfaces:Group = new Group();
			surfaces.addParticle(wall);
			surfaces.addParticle(wall2);
			surfaces.addParticle(ground);
			//surfaces.addParticle(new RigidRectangle(290, 300, 140,5,-0.3,true,1,0.3,1));
			//, 40, 0.3, true));
			surfaces.addParticle(new RigidRectangle(420, 200, 280, 5, -0.3, true));
			surfaces.addParticle(new RigidRectangle(220, 300, 280, 5, 0.3, true));
			//surfaces.addParticle(new RigidCircle(500,120,10,true));
			//surfaces.addParticle(new RigidCircle(460,130,10,true));
			APEngine.addGroup(surfaces);
			balls = new Group();
			APEngine.addGroup(balls);
			var randomX:Number = 330;
			//Math.random()*300+100;
			balls.addParticle(new RigidCircle(randomX, 30, 20));
			balls.addParticle(new RigidCircle(randomX+150, 0, 20));
			balls.addParticle(new RigidCircle(randomX-100, 30, 20));
			// balls.addParticle(new RigidRectangle(randomX, 30, 40, 20,0.1,false,-1,0.3,0.2,0));
			// balls.addParticle(new RigidRectangle(randomX, 90, 40, 20,0.2,false,-1,0.3,0.2,0));
			// balls.addParticle(new RigidRectangle(randomX, 150, 40, 20,0.3,false,-1,0.3,0.2,0));
			//balls.addParticle(new RigidRectangle(randomX, 130, 40,20,0.1,false,1,0.1,0.1));
			//balls.addParticle(new RigidRectangle(randomX+50, 30, 40,20,0,false,1,0.1,0.1));
			//balls.addParticle(new RigidRectangle(randomX-50, 30, 40,20,0,false,1,0.1,0.1));
			//balls.addParticle(new RigidRectangle(randomX+100, 30, 40,20,0,false,1,0.1,0.1));
			/*balls.addParticle(new RigidRectangle(500, 420, 40,20,0,false,1,0.1,0.1));
			balls.addParticle(new RigidRectangle(500, 400, 40,20,0,false,1,0.1,0.1));
			balls.addParticle(new RigidRectangle(500, 380, 40,20,0,false,1,0.1,0.1));
			balls.addParticle(new RigidRectangle(500, 360, 40,20,0,false,1,0.1,0.1));*/
			balls.addCollidableList(new Array(surfaces));
			balls.collideInternal=true;
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		private function enterFrameHandler(event:Event):void {
			//ball.angle+=0.2;
			APEngine.step();
			APEngine.paint();
		}
		private function keyDownHandler(keyboardEvent:KeyboardEvent):void {
			if (keyboardEvent.keyCode == 38) {
				//p1.addMasslessForce(new Vector(0, -1));
				if(Math.random()<0.5){
					balls.addParticle(new RigidRectangle(Math.random()*450+100, 20, Math.random()*20+20,Math.random()*20+20,Math.random()*1.6));
					//,false,1,0.1,0.1
				}else{
					balls.addParticle(new RigidCircle(Math.random()*450+100, 20, Math.random()*10+10));
				}
			} /*else if (keyboardEvent.keyCode == 40) {
				p1.addMasslessForce(new Vector(0, 1));
			} else if (keyboardEvent.keyCode == 37) {
				p1.addMasslessForce(new Vector(-1, 0));
			} else if (keyboardEvent.keyCode == 39) {
				p1.addMasslessForce(new Vector(1, 0));
			} else if (keyboardEvent.keyCode == 32) {
			}*/
		}
		private function keyUpHandler(keyboardEvent:KeyboardEvent):void {
		}
	}
}