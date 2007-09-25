package{
	import org.cove.ape.*;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class apetest extends Sprite{
		private var balls:Group;
		private var ball:RectangleParticle;
		private var p1,p2,p3,p4;
		private var s1,s2,s3,s4,s5;
		
		function apetest(){
			APEngine.init(1/4);
			APEngine.container = this;
			APEngine.addForce(new VectorForce(false,0, 0.5));//Massless
			var wall:RectangleParticle = new RectangleParticle(640, 240, 100, 480, 0, true);
			var wall2:RectangleParticle = new RectangleParticle(0, 240, 100, 480, 0, true);
			var ground:RectangleParticle = new RectangleParticle(320, 480, 640, 100, 0, true);
			var pad:RectangleParticle = new RectangleParticle(220, 150, 280, 5, 0.3, true);
			var pad2:RectangleParticle = new RectangleParticle(420, 250, 280, 5, -0.3, true);
			var pad3:RectangleParticle = new RectangleParticle(220, 350, 280, 5, 0.3, true);
			
			var surfaces:Group = new Group();
			surfaces.addParticle(wall);
			surfaces.addParticle(wall2);
			surfaces.addParticle(ground);
			surfaces.addParticle(pad);
			surfaces.addParticle(pad2);
			surfaces.addParticle(pad3);
			surfaces.addParticle(new CircleParticle(500,120,10,true));
			surfaces.addParticle(new CircleParticle(460,130,10,true));
			//surfaces.addParticle(new CircleParticle(100,400,5,true));
			APEngine.addGroup(surfaces);
			balls = new Group();
			APEngine.addGroup(balls);
			var randomX:Number = 290;
			//Math.random()*300+100;
			
			//ball.setStyle(2, 0x333333, 1, 0x0099FF, 1);
			//ball.addCollidableList(new Array(surfaces));
			//p1=new WheelParticle(100,100,1);
			//p2=new WheelParticle(120,100,1);
			//p3=new WheelParticle(160,100,1);
			//s1=new SpringConstraint(p1,p2,1);
			//s2=new SpringConstraint(p2,p3,1);
			balls.addParticle(new RigidParticle(randomX, 30, 40,20,0,false,1,0.1,0));
			balls.addParticle(new RigidParticle(randomX+50, 30, 40,20,0,false,1,0.1,0));
			balls.addParticle(new RigidParticle(randomX-50, 30, 40,20,0,false,1,0.1,0));
			balls.addParticle(new RigidParticle(randomX+100, 30, 40,20,0,false,1,0.1,0));
			balls.addParticle(new RigidParticle(430, 420, 40,20,0,false,1,0.1,0));
			balls.addParticle(new RigidParticle(430, 400, 40,20,0,false,1,0.1,0));
			balls.addParticle(new RigidParticle(430, 380, 40,20,0,false,1,0.1,0));
			balls.addParticle(new RigidParticle(430, 360, 40,20,0,false,1,0.1,0));
			balls.addParticle(new RigidParticle(430, 340, 40,20,0,false,1,0.1,0));
			balls.addParticle(new RigidParticle(430, 320, 40,20,0,false,1,0.1,0));
			balls.addParticle(new RigidParticle(430, 300, 40,20,0,false,1,0.1,0));
			//balls.addParticle(p1);
			//balls.addParticle(p2);
			//balls.addParticle(p3);
			//balls.addConstraint(s1);
			//balls.addConstraint(s2);
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
					balls.addParticle(new RigidParticle(Math.random()*450+100, 20, Math.random()*20+20,Math.random()*20+20,Math.random()*1.6));
					//,false,1,0.1,0.1
				}else{
					balls.addParticle(new CircleParticle(Math.random()*450+100, 20, Math.random()*10+10));
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