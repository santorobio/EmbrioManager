package src
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.ui.ContextMenu;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.system.Capabilities;
	import flash.system.fscommand;
	import flash.external.ExternalInterface;
	
	import fl.motion.Color;
	import flash.geom.ColorTransform;

	import src.*;

	public class Principal extends MovieClip
	{
		private var imagem:CarregaImagem;
		public var larguraFilme:Number;
		public var alturaFilme:Number;
		private var barra:barraLoad;
		public var quadroAtual:Number;
		
		public var localParaMenu:Number = 1;
		public var localParaMenuCena:String = "";
		
		public var controlaOverMenu:Number = 1;
		public var controlaSubMenu:Number = 0;
		
		var localURL;
		
		public var currentColor:int = 1;
		
		var pictLdr = new Loader();
		
		var xmlLoader:URLLoader = new URLLoader();

		public function Principal ( )
		{
			larguraFilme = 280;
			alturaFilme = 285;

			barra = new barraLoad();
			barra.name = "barra";


			//Carrega o primeiro filme dentro do filme principal
			imagem = new CarregaImagem("SWF/menu.swf",barra,larguraFilme,alturaFilme);
			imagem.name = "imagem";
			addChild (imagem);

			//Some com as opções do botão direito do mouse
			var myContextMenu:ContextMenu;
			myContextMenu = new ContextMenu();
			myContextMenu.hideBuiltInItems ();
			contextMenu = myContextMenu;	
			
			localURL = findLocalURL ();
		}
		
		
		
		//Métodos publicos do objeto Principal

		public function aparece (nome:String)
		{
			trace (nome);
			//Descarrega o swf atual e carrega o novo dependendo do numero passado.
			//removeObjetoPeloNome ("imagem");
			//imagem = new CarregaImagem("SWF/"+nome+".swf",barra,larguraFilme,alturaFilme);
			//imagem = new CarregaImagem(nome + ".swf", barra, larguraFilme, alturaFilme);
			//imagem.name = "imagem";
			//addChild (imagem);
			
			
			//pictLdr.name = "pictLdr";			
			//pictLdr.load(new URLRequest(nome + ".swf"));			
			//pictLdr.addEventListener(Event.COMPLETE, completeHandler);
			
				

			//var url:String = ExternalInterface.call("window.location.href.toString");
			//if (url) resumoTxt.text = url;
			
			var myURL:URLRequest = new URLRequest(localURL + nome+".swf");
			navigateToURL(myURL, "_self");
			
		}
		
		function findLocalURL ():String
		{
			var url:String = ExternalInterface.call("window.location.href.toString");
			if (!url)
			{
				url = "url not finded";
			}
			
			for (var i = url.length ; i > 0 ; i-- )
			{				
				if (url.charAt(i) == "/" || url.charAt(i) == "\\")
				{					
					break;
				}
			}
			url = url.slice(0, i + 1);
			return url;			
		}
		
		function completeHandler(event:Event):void
		{
			//Quando completa muda a variável começou tira a barra do palco e adiciona o objeto carregado.
			trace ("COMPLETE");			
			addChild(pictLdr);
		}
		
		public function apareceMenu ()
		{
			//Descarrega o swf atual e carrega o novo dependendo do numero passado.
			removeObjetoPeloNome ("imagem");
			imagem = new CarregaImagem("SWF/menu.swf",barra,larguraFilme,alturaFilme);
			imagem.name = "imagem";
			addChild (imagem);
		}
		
		
		function sair ()
		{
			if (Capabilities.playerType != "PlugIn")
			{
				fscommand ("quit", "true");
			}
			else
			{
				var url:String = "about:blank";
				var teste:URLRequest = new URLRequest(url);
				try
				{
					navigateToURL (teste, "_self");
				}
				catch (e:Error)
				{
					// handle error here
				}
			}
		}
		
		public function removeObjetoPeloNome (nome:String)
		{
			//verifica se objeto existe e se sim, o remove.
			if (getChildByName(nome) != null)
			{
				removeChild (getChildByName(nome));
			}
		}
		
		
		
/**
		 * Acerta os tags HTML
		 * */
		public function acertaTags (txtPassado:String):String
		{
			var myString:String = txtPassado;

			var pattern:RegExp = /\[/gi;
			myString = myString.replace(pattern,"<");

			var pattern2:RegExp = /\]/gi;
			myString = myString.replace(pattern2,">");


			var supStartExpression:RegExp = new RegExp("<sup>","g");
			var supEndExpression:RegExp = new RegExp("</sup>","g");
			var subStartExpression:RegExp = new RegExp("<sub>","g");
			var subEndExpression:RegExp = new RegExp("</sub>","g");

			myString = myString.replace(supStartExpression,'<font face="\GG Superscript\">');
			myString = myString.replace(supEndExpression,"</font>");
			myString = myString.replace(subStartExpression,'<font face="\GG Subscript\">');			
			myString = myString.replace(subEndExpression,"</font>");
			
			return (myString);
		}
		
		public function carregaTexto (caminho:String, obj:Object, scrollBar:Object)
		{
			
			var textoCarregado:URLRequest = new URLRequest(localURL + caminho);
			var loader:URLLoader = new URLLoader();
			loader.load (textoCarregado);
			//trace (loader.data);
			loader.addEventListener (Event.COMPLETE, completeHandler);

			function completeHandler (event:Event):void
			{
				//trace(loader.data);
				obj.htmlText = acertaTags(loader.data);
				//scrollBar.tabEnabled = false;
				//scrollBar.update ();
				//scrollBar.scrollPosition = 0;
				
				if (obj.textHeight < obj.height)
				{
					scrollBar.visible = false;
				}
				else
				{
					scrollBar.visible = true;
					scrollBar.update ();
					scrollBar.scrollPosition = 0;
				}
			}			
		}
		
		public function loadXML (local:String)
		{
			//xmlLoader = new URLLoader();
			//xmlLoader.addEventListener(Event.COMPLETE, showXML);
			//xmlLoader.load(new URLRequest(local));
		}
			
		function showXML(evt:Event):void 
		{
			XML.ignoreWhitespace = true; 
			var rests:XML = new XML(evt.target.data);
			//trace(rests.restaurante.length());
			var i:Number;
			/*
			for (i = 0; i < rests.book.length(); i++) 
			{
				//trace(" Name of the rest: "+ rests.book[i].@id);
				trace(" Name of the rest: "+ rests.book[i]);
			
			}
			
			
			Object(imagem.pictLdr.content).resumoTxt.htmlText = acertaTags(rests.Intro[0]);
			Object(imagem.pictLdr.content).objetivosTxt.htmlText = acertaTags(rests.Objetivos[0]);
			Object(imagem.pictLdr.content).desenvolvimentoTxt.htmlText = acertaTags(rests.Desenvolvimento[0]);
			Object(imagem.pictLdr.content).integracaoTxt.htmlText = acertaTags(rests.Integracao[0]);
			Object(imagem.pictLdr.content).casosTxt.htmlText = acertaTags(rests.Casos[0]);
			
			if (Object(imagem.pictLdr.content).resumoTxt.textHeight < Object(imagem.pictLdr.content).resumoTxt.height)
			{
				Object(imagem.pictLdr.content).sb1.visible = false;
			}
			if (Object(imagem.pictLdr.content).objetivosTxt.textHeight < Object(imagem.pictLdr.content).objetivosTxt.height)
			{
				Object(imagem.pictLdr.content).sb2.visible = false;
			}
			if (Object(imagem.pictLdr.content).desenvolvimentoTxt.textHeight < Object(imagem.pictLdr.content).desenvolvimentoTxt.height)
			{
				Object(imagem.pictLdr.content).sb3.visible = false;
			}
			if (Object(imagem.pictLdr.content).integracaoTxt.textHeight < Object(imagem.pictLdr.content).integracaoTxt.height)
			{
				Object(imagem.pictLdr.content).sb4.visible = false;
			}
			if (Object(imagem.pictLdr.content).casosTxt.textHeight < Object(imagem.pictLdr.content).casosTxt.height)
			{
				Object(imagem.pictLdr.content).sb5.visible = false;
			}
			*/
		}
		
		public function loadXMLText (local:String)
		{
			//xmlLoader = new URLLoader();
			//xmlLoader.addEventListener(Event.COMPLETE, showXMLText);
			//xmlLoader.load(new URLRequest(local));			
		}
			
		function showXMLText(evt:Event):void 
		{
			XML.ignoreWhitespace = true; 
			var rests:XML = new XML(evt.target.data);
			//trace(rests.restaurante.length());
			var i:Number;
			
			var finalString:String = "";
			//trace (rests);
			trace (rests.capitulo.length());
			
			for (i = 0; i < rests.capitulo.length(); i++) 
			{
				//trace(" Name of the rest: "+ rests.capitulo[i].@titulo);
				//trace(" Name of the rest: " + rests.book[i]);
				finalString += rests.capitulo[i].@titulo;
				finalString += "\n" + "\n";
				finalString += rests.capitulo[i];
				finalString += "\n" + "\n";
			
			}
			
			//trace (rests);
			Object(imagem.pictLdr.content).txt.htmlText = acertaTags(finalString);
			//Object(imagem.pictLdr.content).txt.text = rests;
		}
		

	}
}