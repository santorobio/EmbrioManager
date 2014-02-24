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

	public class Caso extends MovieClip
	{
		public var numeroQuadro:Number = 5;
		//private var objetoPrincipal:Object;
		private var objetoPrincipal:Principal = new Principal();
		var verLegenda:Boolean = true;
		var padraoLegenda:RegExp = /legenda_\d*/;
		var padraoLateral:RegExp = /lateral_pausa_\d*/;

		//========== Define largura do controle de tempo ==========
		var larguraMarcador:Number = 200;
		//=========================================================

		var estaArrastando:Boolean = false;
		var limite:Rectangle = new Rectangle(0,0,larguraMarcador,0);
		
		var corOn:Color = new Color();
		var corOff:Color = new Color();
		var corOver:Color = new Color();
		var estaTocando:Boolean = false;

		public function Caso ():void
		{
			addEventListener(Event.ADDED_TO_STAGE, firstFrame);
						
			//Acerta as cores dos botões laterais para os dois estados Ligado e desligado
			corOn.setTint(0xFF9900, 1);
			corOff.setTint(0x000000, 1);
			corOver.setTint(0xFF6600, 1);

			//Controla o botão de tempo
			/*
			marcaTempo.marcador.x = 0;
			marcaTempo.marcador.y = 0;
			marcaTempo.marcador.buttonMode = true;
			marcaTempo.marcador.addEventListener (MouseEvent.MOUSE_DOWN, arrasta);
			marcaTempo.marcador.addEventListener (MouseEvent.MOUSE_UP, solta);
			marcaTempo.largura.width = larguraMarcador;
			*/
			
			stop();

			//Para animação
			mc.stop ();			

			//inicia o botão playPause
			/*
			play_mc.buttonMode = true;
			play_mc.addEventListener (MouseEvent.MOUSE_UP, playUpFunc);
			play_mc.addEventListener (MouseEvent.MOUSE_OVER, playOverFunc);
			play_mc.addEventListener (MouseEvent.MOUSE_OUT, playOutFunc);
			*/
			
			//inicia o botão volta ao menu
			//voltar.addEventListener (MouseEvent.CLICK, function(evt:Event) { voltaMenu(1, "casoclinico"); });
		
			//inicia o botão que mostra ou não as legendas
			legenda_mc.buttonMode = true;
			legenda_mc.addEventListener (MouseEvent.MOUSE_UP, mostraLegenda);
			legenda_mc.addEventListener (MouseEvent.MOUSE_OVER, playOverFunc);
			legenda_mc.addEventListener (MouseEvent.MOUSE_OUT, playOutFunc);
			legenda_mc.gotoAndStop("on");
			
			//mc.botGrande.addEventListener (MouseEvent.CLICK, botGrandeFc);
			
			//textoFrente.addEventListener (MouseEvent.CLICK, moveTextoFrente);
			//textoVolta.addEventListener (MouseEvent.CLICK, moveTextoVolta);
			
			for (var i=this.numChildren-1; i>=0; i--)
			{				
				if (padraoLateral.test(this.getChildAt(i).name))
				{
					Object(getChildAt(i)).buttonMode = true;
					this.getChildAt(i).addEventListener (MouseEvent.MOUSE_UP, lateralFunc);
					this.getChildAt(i).addEventListener (MouseEvent.MOUSE_OVER, lateralOver);
					this.getChildAt(i).addEventListener (MouseEvent.MOUSE_OUT, lateralOut);
				}
			}
		}
		
//*****  MÉTODOS *****

		function firstFrame (evt:Event)
		{
			removeEventListener(Event.ADDED_TO_STAGE, firstFrame);
			gotoAndStop(1);
			iniciar();
		}

		function iniciar ()
		{
			//objetoPrincipal = Object(parent.parent.parent);

			//stage.addEventListener (MouseEvent.MOUSE_UP, soltaMarcador);
			
			pintaTodosNoPadrao(padraoLateral, this, corOff);
			lateral_pausa_1.transform.colorTransform = corOn;			
			
			//objetoPrincipal.carregaTexto("txt/q13.txt", textoNovo);
			//objetoPrincipal.carregaTexto("txt/q13_1.txt", mc.textoNovo);
			
			
			var caminho:String = localTexto.slice(0, localTexto.length - 4);
			
			if (objetoPrincipal.currentColor == 1)
			{
				objetoPrincipal.carregaTexto(localTexto, txt, sbTxt);				
			}
			else
			{
				gotoAndStop(2);
				objetoPrincipal.carregaTexto(localTexto, txt_2, scrlBar_2);	
			}	
			
			objetoPrincipal.carregaTexto(caminho + "_1.txt", mc.subtitle, mc.sb);
			
		}
		
		public function chamaSWF (evt:MouseEvent)
		{
			objetoPrincipal.aparece(evt.target.name);
		}
		
		private function colorChange(evt:MouseEvent):void 
		{
			if (currentFrame == 1)
			{
				gotoAndStop(2);
				objetoPrincipal.carregaTexto(localTexto, txt_2, scrlBar_2);		
				objetoPrincipal.currentColor = 2;
			}
			else
			{
				gotoAndStop(1);
				objetoPrincipal.carregaTexto(localTexto, txt, sbTxt);
				objetoPrincipal.currentColor = 1;
			}
			
			
		}

//================================Funçoes do botão de tempo=====================================

		
//==============================================================================================

		function voltaMenu (numero:Number, cena:String)
		{
			objetoPrincipal.localParaMenu = numero;
			objetoPrincipal.localParaMenuCena = cena;
			objetoPrincipal.apareceMenu();
		}
		
		

		


/*
		Função do botão Play - Pause
*/
		function playUpFunc (evt:MouseEvent)
		{
			if (evt.target.currentLabel == "play")
			{
				mc.play ();
				evt.target.gotoAndStop ("pause");
				evt.target.gotoAndStop (evt.target.currentFrame + 1);
				//mc.addEventListener (Event.ENTER_FRAME, moveMarcadorPeloMc);
				
				estaTocando = true;
			}
			else
			{
				mc.stop ();
				evt.target.gotoAndStop ("play");
				evt.target.gotoAndStop (evt.target.currentFrame + 1);
				//mc.removeEventListener (Event.ENTER_FRAME, moveMarcadorPeloMc);
				
				estaTocando = false;
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
						sbTxt.scrollPosition = i;	
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
						scrlBar_2.scrollPosition = i;	
						break;
					}
				}
			}
			
			
		}
		
		
		
/*
		Controla a aparição ou não das legendas
*/
		function mostraLegenda (evt:MouseEvent)
		{
			if (evt.target.currentFrame < 3)
			{
				verLegenda = true;
				evt.target.gotoAndStop("on");
				evt.target.gotoAndStop(evt.target.currentFrame + 1);
				mostraTodosNoPadrao(padraoLegenda, this.mc);
			}
			else
			{
				verLegenda = false;
				evt.target.gotoAndStop("off");
				evt.target.gotoAndStop(evt.target.currentFrame + 1);
				apagaTodosNoPadrao(padraoLegenda, this.mc);
			}
			
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
		function pintaTodosNoPadrao (padrao:RegExp, local:Object, cor:Color)
		{			
			for (var i=local.numChildren-1; i>=0; i--)
			{				
				if (padrao.test(local.getChildAt(i).name))
				{
					local.getChildAt(i).transform.colorTransform = cor;
					//trace(local.getChildAt(i).name);
				}
			}
		}
		
/*
		Controla a pausa da animação:
		- pausando
		- Colocando o bot play no estado certo
		- remove o enter frame
		- e mostra as legendas se o botão estiver selecionado
*/
		public function pausa ()
		{
			mc.stop();
			//play_mc.gotoAndStop ("play");
			//mc.removeEventListener (Event.ENTER_FRAME, moveMarcadorPeloMc);
			
			estaTocando = false;
			
			
			if (verLegenda == true)
			{
				mostraTodosNoPadrao(padraoLegenda, this.mc);
			}
			else 
			{
				apagaTodosNoPadrao(padraoLegenda, this.mc);
			}
		}
/*
		Controla Função dos botões laterais
*/
		function lateralFunc (evt:MouseEvent)
		{
			var local:String = evt.target.name.slice(14);
			mc.gotoAndStop("pausa_"+local);
			
			var unidade:Number = larguraMarcador / mc.totalFrames;
			//marcaTempo.marcador.x = int(unidade * mc.currentFrame);
			
			pintaTodosNoPadrao(padraoLateral, this, corOff);
			this["lateral_"+mc.currentLabel].transform.colorTransform = corOn;
			
			estaTocando = false;
			
			var caminho:String = localTexto.slice(0, localTexto.length - 4);
			//trace (caminho);
			
			objetoPrincipal.carregaTexto(caminho + "_" + local +".txt", mc.subtitle, mc.sb);
			
		}
		function lateralOver (evt:MouseEvent)
		{
			evt.target.transform.colorTransform = corOver;
		}
		function lateralOut (evt:MouseEvent)
		{
			pintaTodosNoPadrao(padraoLateral, this, corOff);
			this["lateral_"+mc.currentLabel].transform.colorTransform = corOn;
		}
		


/*
		Funções dos botões com MouseOver e MouseOut
*/
		function playOverFunc (evt:MouseEvent)
		{
			evt.target.gotoAndStop (evt.target.currentFrame + 1);
		}
		function playOutFunc (evt:MouseEvent)
		{
			evt.target.gotoAndStop (evt.target.currentFrame - 1);
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