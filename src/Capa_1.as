package src
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.SimpleButton;
	import flash.events.KeyboardEvent;
	import flash.accessibility.AccessibilityProperties;
	
	import flash.external.ExternalInterface;

	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.navigateToURL;

	import flash.geom.Rectangle;
	
	import fl.motion.Color;
	import flash.geom.ColorTransform;


	import src.*;

	public class Capa_1 extends MovieClip
	{
		
		//private var objetoPrincipal:Object;
		private var objetoPrincipal:Principal = new Principal();
		var capituloPatt:RegExp = /cap_/;
		
		
		public function Capa_1 ():void
		{
			addEventListener(Event.ADDED_TO_STAGE, firstFrame);
			stop();
		}
		
//*****  MÉTODOS *****

		public function chamaSWF (evt:MouseEvent)
		{
			objetoPrincipal.aparece(evt.target.name);
		}

		function firstFrame (evt:Event)
		{
			removeEventListener(Event.ADDED_TO_STAGE, firstFrame);
			gotoAndStop(1);			
			iniciar();
		}
		
		

		function iniciar ()
		{
			//objetoPrincipal = Object(parent.parent.parent);
			
			menu.addEventListener(MouseEvent.CLICK, chamaSWF);
			//cap_1_textos.addEventListener(MouseEvent.CLICK, chamaSWF);
			
			//dispatchEvent(new Event("eventCat", true));
			//objetoPrincipal.loadXML("xml/c1.xml");
			
			
			
			if (objetoPrincipal.currentColor == 1)
			{
				objetoPrincipal.carregaTexto(localTexto, resumoTxt, sb1);
			}
			else
			{
				gotoAndStop(2);
				objetoPrincipal.carregaTexto(localTexto, resumoTxt_2, sb2);
			}
			
			
		}
		
		private function colorChange(evt:MouseEvent):void 
		{			
			
			if (currentFrame == 1)
			{
				gotoAndStop(2);
				objetoPrincipal.carregaTexto(localTexto, resumoTxt_2, sb2);
				objetoPrincipal.currentColor = 2;
			}
			else
			{
				gotoAndStop(1);
				objetoPrincipal.carregaTexto(localTexto, resumoTxt, sb1);
				objetoPrincipal.currentColor = 1;
			}
			
			
		}
		
		public function putListenersCap ()
		{
			achaTodosNoPadrao(capituloPatt, sPane1.content, 2);
			achaTodosNoPadrao(capituloPatt, sPane2.content, 2);	
			achaTodosNoPadrao(capituloPatt, sPane3.content, 2);	
			achaTodosNoPadrao(capituloPatt, sPane4.content, 2);	
		}

		function voltaMenu (numero:Number, cena:String)
		{
			objetoPrincipal.localParaMenu = numero;
			objetoPrincipal.localParaMenuCena = cena;
			objetoPrincipal.apareceMenu();
		}
		
		function mostraTodosNoPadrao (padrao:RegExp, local:Object)
		{			
			//trace (local);
			for (var i=local.numChildren-1; i>=0; i--)
			{				
				if (padrao.test(local.getChildAt(i).name))
				{
					local.getChildAt(i).visible = true;
					
				}
			}
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

/*
		Função para fechar a janela fora do browser
*/
		function sairFunction (evt:MouseEvent)
		{
			objetoPrincipal.sair ();
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