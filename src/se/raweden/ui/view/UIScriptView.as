﻿package se.raweden.ui.view{	import flash.display.DisplayObjectContainer;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.FocusEvent;	import flash.events.IMEEvent;	import flash.events.KeyboardEvent;	import flash.events.TextEvent;	import flash.geom.Rectangle;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;	import flash.text.TextFormat;		/**	 * A <code>UIScriptView</code> view component is a abstract code editor.	 *	 * <p>Copyright 2011, Raweden. All Rights Reserved.</p>	 *	 * @author Raweden	 */	public class UIScriptView extends UIScrollView{				//		// TODO: use the flash text engine to render the text. check this: http://www.developria.com/2009/03/flash-text-engine.html		// TODO: Fix the dynamic line number generation.		// TODO: Add support for multiline tab formating.		// TODO: Add support for basic code snippet insertion.		// TODO: Implement method for go to a specific line		// TODO: Add end-point for syntax highlighting module. etc.		// TODO: Add implementation for collapsing code sections.		// TODO: Add implementation for drag-and-drop resources, with UIDragging class.		//				private var lineTF:TextField;		private var codeTF:TextField;		private var _numLines:int;				private var _caretIndex:int = -1;				private var _delegate:IScriptViewDelegate;		private var _content:Sprite;				/**		 * Constructor.		 */		public function UIScriptView(parent:DisplayObjectContainer = null){			super(parent);			addChildren();			init();		}				// adding sub views.		private function addChildren():void{			// Adding textfield to hold the line-numbers.			var format:TextFormat = new TextFormat("Courier New",13,0x333333,true);			lineTF = new TextField();			lineTF.width = 35;			lineTF.selectable = false;			lineTF.multiline = true;			lineTF.mouseWheelEnabled = false;			lineTF.defaultTextFormat = format;			lineTF.autoSize = TextFieldAutoSize.RIGHT;			lineTF.wordWrap = true;			// Adding the textfield to hold the code.			codeTF = new TextField();			codeTF.type = "input";			codeTF.x = 40;			codeTF.multiline = true;			codeTF.mouseWheelEnabled = false;			codeTF.defaultTextFormat = format;			codeTF.useRichTextClipboard = false;			codeTF.autoSize = TextFieldAutoSize.LEFT;			codeTF.width = 640;			// adding content.			_content = new Sprite();			_content.addChild(codeTF);			_content.addChild(lineTF);			super.content = _content;		}				// intilize this view.		private function init():void{			for(var i:int = 0;i<40;i++){				lineTF.appendText(i.toString(10)+"\n");				codeTF.appendText("code @ line --> this is a test! "+i+"\n");			}						this.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,onKeyFocusChange);			codeTF.addEventListener(Event.SCROLL,onCodeScroll);			codeTF.addEventListener(TextEvent.TEXT_INPUT,onTextChange);			codeTF.addEventListener(KeyboardEvent.KEY_DOWN,keyboardHandler);			codeTF.addEventListener(IMEEvent.IME_START_COMPOSITION,startCompositon);			// setting the default size.			this.pagingEnabled = false;			//this.alwaysShowIndicators = true;			resize(640,360);		}						//------------------------------------ 		// Rensponding to User Interaction.		//------------------------------------ 				private function onTextChange(e:TextEvent = null):void{			trace("text-field did change");			// 			if(_numLines != codeTF.numLines){				_numLines = codeTF.numLines;				generateLineNumber();			}			if(_delegate)				_delegate.onScriptChange(this,codeTF);		}				private function keyboardHandler(e:KeyboardEvent):void{			trace("key-code:",e.keyCode)			if(codeTF.caretIndex != codeTF.caretIndex){				_caretIndex = codeTF.caretIndex;				this.needsDraw();			}			trace("caretIndex:",codeTF.caretIndex);		}				private function startCompositon(e:IMEEvent):void{			trace("IME-Event");		}				// we need to use the tab key focus for tab formating the text.		private function onKeyFocusChange(e:FocusEvent):void{			e.preventDefault();			// applies tabformating to the selected text.			tagFormat();		}				// when this method is trigger a tab char is added on every line of selected text.		private function tagFormat():void{			// getting number of lines selected.			var i:int = codeTF.getLineIndexOfChar(codeTF.selectionBeginIndex);			var len:int = codeTF.getLineIndexOfChar(codeTF.selectionEndIndex);			var inserts:int;			var start:int;			for(i;i<=len;i++){				var line:String = codeTF.getLineText(i);				line = "\t"+line;				start = codeTF.getLineOffset(i);				codeTF.replaceText(start,start+codeTF.getLineLength(i),line);				inserts++;			}			// TODO: check if a tab char is inserted before the selected index.						// setting a new selection as the old range is not valid anylonger.			codeTF.setSelection(codeTF.selectionBeginIndex,codeTF.selectionEndIndex+inserts);		}				//------------------------------------		// Setting and Getting Attributes.		//------------------------------------				/**		 * 		 */		public function set delegate(value:IScriptViewDelegate):void{			_delegate = value;		}		// return the current delegate.		public function get delegate():IScriptViewDelegate{			return _delegate;		}				//------------------------------------		// Navigating the Script		//------------------------------------				/**		 * Scrolls the editor to a specific line of code.		 */		public final function goto(line:int):void{			// validates if the line within range.			if(line <= codeTF.numLines){				// Todo: modify the line value so the line is completly visible if posible.				codeTF.scrollV = line;			}		}				//------------------------------------ 		// Inserting code snippets.		//------------------------------------ 				/**		 * 		 */		public function insertSnippet(snippet:String):void{			var index:int = codeTF.caretIndex;			trace("index of insert:",index);			trace("char at index:","\""+codeTF.text.charAt(index)+"\"");			trace("code at index:",codeTF.text.charCodeAt(index));			codeTF.replaceText(codeTF.selectionBeginIndex,codeTF.selectionEndIndex,snippet);			index++;			codeTF.setSelection(index,index);		}				/**		 * Specifies the string of code be used in the Script Editor.		 */		public function set text(value:String):void{			codeTF.text = value.split('\r\n').join('\r');			onTextChange();			needs("layout",layout);			needs("draw",draw);		}		// returns the code string ready to be written to disc.		public function get text():String{			return codeTF.text.split('\r').join('\r\n');		}						// Syncing Textfield scroll to code line scroll.				private function onCodeScroll(e:Event):void{			lineTF.scrollV = codeTF.scrollV;		}				//		private function generateLineNumber():void{			var lines:String = "";			var len:int = _numLines == 0 ? 1 : _numLines;			for(var i:int = 1;i <= len;i++){				lines += i.toString()+"\n";			}			lineTF.text = lines;		}						// Getting information about Text 						/**		 * Returns a rectangle that is the bounding box of the character.		 */		public function getCharBoundaries(charIndex:int):Rectangle{			return null;		}				/**		 * Returns the zero-based index value of the character at the point specified by the x and y parameters.		 */		public function getCharIndexAtPoint(x:Number, y:Number):int{			return -1;		}				/**		 * Returns the zero-based index value of the line at the point specified by the x and y parameters.		 */		public function getLineIndexAtPoint(x:Number, y:Number):int{			return -1;			}				/**		 * Returns the zero-based index value of the line containing the character specified by the charIndex parameter.		 */		public function getLineIndexOfChar(charIndex:int):int{			return -1;		}				/**		 * Returns the number of characters in a specific text line.		 */		public function getLineLength(lineIndex:int):int{			return -1;		}				/**		 * Returns the character index of the first character in the line that the lineIndex parameter specifies.		 */		public function getLineOffset(lineIndex:int):int{			return -1;		}				/**		 * Returns the text of the line specified by the lineIndex parameter.		 */		public function getLineText(lineIndex:int):String{			return null;		}						// Managing Text Selection						/**		 * Sets as selected the text designated by the index values of the first and last characters, 		 * which are specified with the beginIndex and endIndex parameters.		 * 		 * @param beginIndex		 * @param endIndex		 */		public function setSelection(beginIndex:int,endIndex:int):void{			return codeTF.setSelection(beginIndex,endIndex);		}				/**		 * The zero-based character index value of the first character in the current selection.		 */		public function get selectionBeginIndex():int{			return codeTF.selectionBeginIndex;		}						/**		 * The zero-based character index value of the last character in the current selection.		 */		public function get selectionEndIndex():int{			return codeTF.selectionEndIndex;		}				/**		 * Appends the string specified by the newText parameter to the end of the text of the text field. 		 */		public function appendText(newText:String):void{			codeTF.appendText(newText);						// needs to refresh display as the bounds may have changed.			needs("layout",layout);			needs("draw",draw);		}				/**		 * Replaces the range of characters that the beginIndex and endIndex parameters specify 		 * with the contents of the newText parameter.		 */		public function replaceText(beginIndex:int,endIndex:int,newText:String):void{			codeTF.replaceText(beginIndex,endIndex,newText);						// needs to refresh display as the bounds may have changed.			needs("layout",layout);			needs("draw",draw);		}						//------------------------------------ 		// Laying out Drawing View.		//------------------------------------ 				/**		 * @inheritDoc		 */		override protected function layout(rect:Rectangle):void{			//codeTF.width = rect.width-40;			super.layout(rect);		}				/**		 * @inheritDoc		 */				override protected function draw(rect:Rectangle):void{			rect = rect.clone();			_content.graphics.clear();			rect.width = _content.width;			rect.width = rect.width < width ? width : rect.width;			rect.height = _content.height;			rect.height = rect.height < height ? height : rect.height;			// drawing the line-number background.			_content.graphics.beginFill(0xCCCCCC);			_content.graphics.drawRect(0,0,40,rect.height);			_content.graphics.endFill();			// drawing the code-page background.			_content.graphics.beginFill(0xF1F1F1);			_content.graphics.drawRect(40,0,rect.width-40,rect.height);			_content.graphics.endFill();			// drawing the line-number border and shadow.			_content.graphics.beginFill(0xFFFFFF,0.05);			_content.graphics.drawRect(39,0,1,rect.height);			_content.graphics.endFill();			_content.graphics.beginFill(0x000000,0.25);			_content.graphics.drawRect(40,0,1,rect.height);			_content.graphics.endFill();			_content.dispatchEvent(new Event(Event.RESIZE));		}				//------------------------------------		// Deconstruction		//------------------------------------				/**		 * @inheritDoc		 */		override public function dispose():void{			// destoying the super implemenation.			super.dispose();		}			}}