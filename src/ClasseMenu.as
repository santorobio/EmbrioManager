package src
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.SimpleButton;
	import flash.events.KeyboardEvent;
	import flash.accessibility.AccessibilityProperties;

	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.navigateToURL;

	import flash.geom.Rectangle;
	
	import fl.motion.Color;
	import flash.geom.ColorTransform;


	import src.*;

	public class ClasseMenu extends MovieClip
	{
		public var numeroQuadro:Number = 0;
		private var objetoPrincipal:Object;
		var subMenuPadrao:RegExp = /subMenu_\d*/;
		var capituloPatt:RegExp = /cap_/;

		public function ClasseMenu ():void
		{
			addEventListener(Event.ADDED_TO_STAGE, iniciar);
			//objeto.addEventListener (MouseEvent.CLICK, function(evt:Event) { funcaoGenerica(parametros); });
			
		}

		function iniciar (evt:Event)
		{
			objetoPrincipal = Object(parent.parent.parent);
			
			if (objetoPrincipal.localParaMenu != 1 || objetoPrincipal.localParaMenuCena != "")
			{
				this.gotoAndStop(objetoPrincipal.localParaMenu, objetoPrincipal.localParaMenuCena);
			}
			
			menu_3.addEventListener(MouseEvent.CLICK, menuClick);
			//cap_1_textos.addEventListener(MouseEvent.CLICK, menuClick);
		}
		
		private function menuClick(evt:MouseEvent):void 
		{
			var local:Number = evt.target.name.slice(5);
			gotoAndStop(local);
		}
		
		public function putListenersCap ()
		{
			achaTodosNoPadrao(capituloPatt, sPane.content, 2);			
		}

		public function proxCena (numero:Number, local:String)
		{
			this.gotoAndStop(numero, local);
		}
		public function proxCenaSubMenu (numero:Number, local:String, subMenu:Number)
		{
			this.gotoAndStop(numero, local);
			objetoPrincipal.controlaSubMenu = subMenu;
		}
		public function proxQuadro (evt:MouseEvent)
		{
			this.nextFrame();
		}
		public function vaiParaQuadro (numero:Number)
		{
			this.gotoAndStop(numero);
		}
		public function playQuadro (nSub:Number, numero:Number)
		{
			//this.gotoAndPlay(nPlay);
			apagaTodosNoPadrao(subMenuPadrao, this);
			this["subMenu_"+nSub].visible = true;
			this["subMenu_"+nSub].gotoAndPlay(2);
			objetoPrincipal.controlaOverMenu = numero;
		}
		public function chamaSWF (evt:MouseEvent)
		{
			objetoPrincipal.aparece(evt.target.name);
		}
		
		public function overMenu (evt:MouseEvent)
		{
			var numero:Number = evt.target.name.slice(5);
			//titulosOver.gotoAndStop(numero+1);
		}
		public function outMenu (evt:MouseEvent)
		{
			//titulosOver.gotoAndStop(objetoPrincipal.controlaOverMenu);
		}
		
		function apagaTodosNoPadrao (padrao:RegExp, local:Object)
		{			
			for (var i=local.numChildren-1; i>=0; i--)
			{				
				if (padrao.test(local.getChildAt(i).name))
				{
					//removeObjetoPeloNome (getChildAt(i).name);
					local.getChildAt(i).visible = false;					
				}
			}
		}
		
		function achaTodosNoPadrao (padrao:RegExp, local:Object, type:int)
		{
			
			for (var i=local.numChildren-1; i>=0; i--)
			{
				if (padrao.test(local.getChildAt(i).name))
				{
					switch (type)
					{
						case 1:
							local.removeChildAt(i);
							break;
						case 2:
							local.getChildAt(i).addEventListener(MouseEvent.CLICK, chamaSWF);
							break;
						
					}
				}
			}
		}

	}
}