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

	public class Texto_1 extends MovieClip
	{
		
		//private var objetoPrincipal:Object;
		private var objetoPrincipal:Principal = new Principal();
		
		public function Texto_1 ():void
		{
			stop();
			addEventListener(Event.ADDED_TO_STAGE, firstFrame);
			
		}
		
//*****  MÉTODOS *****

		public function chamaSWF (evt:MouseEvent)
		{
			//objetoPrincipal.aparece(evt.target.name);
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
			removeEventListener(Event.ADDED_TO_STAGE, iniciar);
			//objetoPrincipal = Object(parent.parent.parent);
			
			menu.addEventListener(MouseEvent.CLICK, chamaSWF);
			//Intro2.addEventListener(MouseEvent.CLICK, moveTexto);
			
			//dispatchEvent(new Event("eventCat", true));
			//objetoPrincipal.loadXMLText("xml/Texto_1.xml");
			//objetoPrincipal.carregaTexto("txt/texto.txt", txt);
			
			//if (objetoPrincipal.currentColor == 1)
			//var localTexto:String = "../txt/texto.txt";
			//trace (localTexto);
			
			if (objetoPrincipal.currentColor == 1)
			{
				objetoPrincipal.carregaTexto(localTexto, txt, sb);
			}
			else
			{
				gotoAndStop(2);
				objetoPrincipal.carregaTexto(localTexto, txt_2, sb_2);	
			}	
			
			
			
		}
		
		private function colorChange(evt:MouseEvent):void 
		{
			if (currentFrame == 1)
			{
				gotoAndStop(2);
				objetoPrincipal.carregaTexto(localTexto, txt_2, sb_2);	
				objetoPrincipal.currentColor = 2;
			}
			else
			{
				gotoAndStop(1);
				objetoPrincipal.carregaTexto(localTexto, txt, sb);
				objetoPrincipal.currentColor = 1;
			}
			
			
		}
		
		private function moveTexto(evt:MouseEvent):void 
		{
			var botName = evt.target.name.split("_").join(" ");		
			findTextLine(botName);
		}
		
		function findTextLine (patt:String)
		{
			var s:String;
			var padrao:RegExp = new RegExp(patt);
			
			if (currentFrame == 1)
			{
				for (var i:int = 0; i < txt.numLines; i++) 
				{
					s = txt.getLineText(i);
					
					if (padrao.test(s))
					{
						trace ("Achou = " + i + "  - " + currentFrame);
						sb.scrollPosition = i;	
						break;
					}
				}
			}
			else
			{
				for (i = 0; i < txt_2.numLines; i++) 
				{
					s = txt_2.getLineText(i);
					
					if (padrao.test(s))
					{
						trace ("Achou = " + i + "  - " + currentFrame);
						sb_2.scrollPosition = i;	
						break;
					}
				}
			}
			
			
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
	}
}