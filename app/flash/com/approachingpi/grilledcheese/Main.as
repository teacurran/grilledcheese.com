package com.approachingpi.grilledcheese {

	import flash.display.StageScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// We import the FIVe3D classes needed.
	import five3D.display.DynamicText3D;
	import five3D.display.Scene3D;
	import five3D.display.Shape3D;
	import five3D.display.Sprite3D;
	import five3D.utils.Drawing;
	import com.approachingpi.grilledcheese.fonts.*;

	public class Main extends Sprite {

		public function Main() {
			
			// We define the Stage scale mode.
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// We create a new Scene3D named "scene", center it and add it to the display list.
			var scene:Scene3D = new Scene3D();
			scene.x = 350;
			scene.y = 200;
			addChild(scene);

			/*
			var cube:Sprite3D = new Sprite3D();
			
			var face:Sprite3D = new Sprite3D();
			face.graphics3D.beginFill(0x000000);
			//drawRoundRect(x, y, width, height, ellipsewidth, ellipseheight)
			face.graphics3D.drawRoundRect(-250, -150, 600, 100, 40, 40);
			face.z = -350;
			face.graphics3D.endFill();

			cube.addChild(face);

			var faceRight:Sprite3D = new Sprite3D();
			faceRight.graphics3D.beginFill(0x000000);
			faceRight.graphics3D.drawRoundRect(-250, -150, 600, 100, 40, 40);
			faceRight.rotationY = -90;
			faceRight.x = 350;
			faceRight.graphics3D.endFill();

			cube.addChild(faceRight);
			
			
			scene.addChild(cube);
			
			// We create a new DynamicText3D named "world", modify its properties, place it and add it to the "sign" display list.
			var text_grilledcheese:DynamicText3D = new DynamicText3D(SimpleRad);
			text_grilledcheese.size = 80;
			text_grilledcheese.color = 0x666666;
			text_grilledcheese.text = "grilledcheese.com";
			text_grilledcheese.x = -200;
			text_grilledcheese.y = -150;
			face.addChild(text_grilledcheese);
			
			*/
			
			var cube = new Sprite3D();
			cube.mouseChildren = false;
			scene.addChild(cube);
			
			// front
			cube.addChild(createFace(0, 0, -250, 0, 0, 0));
			
			// right
			//cube.addChild(createFace(250, 0, 0, 0, -90, 0));
			
			// left
			cube.addChild(createFace(-250, 0, 0, 0, 90, 0));
			
			// back
			cube.addChild(createFace(0, 0, 250, 0, 180, 0));


			// We create a new DynamicText3D named "world", modify its properties, place it and add it to the "sign" display list.
			var text_grilledcheese:DynamicText3D = new DynamicText3D(SimpleRad);
			text_grilledcheese.size = 80;
			text_grilledcheese.color = 0x000000;
			text_grilledcheese.text = "grilledcheese.com";
			text_grilledcheese.x = 250;
			text_grilledcheese.y = 0;
			text_grilledcheese.z = 0 - text_grilledcheese.textWidth/2;
			text_grilledcheese.rotationY = -90;
			cube.addChild(text_grilledcheese);

			
			//cube.addChild(createFace(0, 0, 150, 0, 180, 0));
			//cube.addChild(createFace(-150, 0, 0, 0, 90, 0));
			//cube.addChild(createFace(0, -150, 0, -90, 0, 0));
			//cube.addChild(createFace(0, 150, 0, 90, 0, 0));
			
			// We attribute a random value to the rotations on the X, Y and Z axes of the "sign".
			
			cube.rotationX = 2;
			//sign.rotationX = Math.random()*100-50;
			//sign.rotationY = Math.random()*100-50;
			//sign.rotationZ = Math.random()*100-50;
			
			// We register the class Main as a listener for the "click" mouse event of the "sign" and modify some of its mouse-related properties.
			cube.addEventListener(MouseEvent.CLICK, signClickHandler);
			cube.mouseChildren = false;
			cube.buttonMode = true;

			cube.addEventListener(Event.ENTER_FRAME, cubeEnterFrameHandler);

		}
		
		private function createFace(x:Number, y:Number, z:Number, rotationx:Number, rotationy:Number, rotationz:Number):Sprite3D {
			var face:Sprite3D = new Sprite3D();
			face.graphics3D.beginFill(0x000000);
			//drawRoundRect(x, y, width, height, ellipsewidth, ellipseheight)
			face.graphics3D.drawRoundRect(-250, 0, 500, 100, 40, 40);
			face.graphics3D.endFill();

			face.x = x;
			face.y = y;
			face.z = z;
			face.rotationX = rotationx;
			face.rotationY = rotationy;
			face.rotationZ = rotationz;
			//face.singleSided = true;
			face.flatShaded = true;
			return face;
		}


		private function cubeEnterFrameHandler(event:Event):void {
			// We rotate the "star".
			event.target.rotationY++;
		}

		private function signClickHandler(event:MouseEvent):void {
			// We attribute a new random value to the rotations on the X, Y and Z axes of the "sign".
			
			//event.target.rotationX = Math.random()*100-50;
			//event.target.rotationY = Math.random()*100-50;
			//event.target.rotationZ = Math.random()*100-50;

			event.target.rotationY += 2;
			//event.target.x -= 2;
			//event.target.rotationY += 2;
			//event.target.rotationY += 2;

		}

	}

}