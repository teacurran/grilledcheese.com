package com.approachingpi.grilledcheese {
   import flash.display.Sprite; 
   import flash.events.*;
   import flash.ui.*;
   import sandy.core.Scene3D;
   import sandy.core.data.*;
   import sandy.core.scenegraph.*;
   import sandy.materials.*;
   import sandy.materials.attributes.*;
   import sandy.primitive.*;
 
   public class Main extends Sprite {
      private var scene:Scene3D;
      private var camera:Camera3D;
      var box:Box;
 
      public function Main() { 
         camera = new Camera3D( 600, 400 );
         //camera.z = -400;
 
         var root:Group = createScene();
 
         scene = new Scene3D( "scene", this, camera, root );
 
         addEventListener( Event.ENTER_FRAME, enterFrameHandler );         

         stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
      }
 
      private function createScene():Group {
         var g:Group = new Group();
 
         box = new Box( "box", 200, 50, 200);
 
         //box.rotateX = 45;
         //box.rotateY = 45;
 
 
			 // we define two Movie Material
			 var material01:MovieMaterial = new MovieMaterial(new SideIntro, 40);
			 material01.lightingEnable = true;
		     var app01:Appearance = new Appearance( material01 );


			 box.aPolygons[0].appearance = app01;
			 box.aPolygons[1].appearance = app01;
			 box.aPolygons[2].appearance = app01;
			 box.aPolygons[3].appearance = app01;
			 box.aPolygons[10].appearance = app01;
			 box.aPolygons[11].appearance = app01;

	         g.addChild( box );

         return g;
      }
 
      private function enterFrameHandler( event : Event ) : void {
         scene.render();
      }

      private function keyPressed(event:KeyboardEvent):void {
         switch(event.keyCode) {
            case Keyboard.UP:
               box.y +=2;
               break;
            case Keyboard.DOWN:
               box.y -=2;
               break;
            case Keyboard.RIGHT:
               box.rotateY +=2;
               break;
            case Keyboard.LEFT:
               box.rotateY -=2;
               break;
         }
      }


   }
}