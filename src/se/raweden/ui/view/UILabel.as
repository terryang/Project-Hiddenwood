﻿package se.raweden.ui.view{	import flash.display.DisplayObjectContainer;	import flash.geom.Rectangle;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;	import flash.text.TextFormat;			/**	 * A <code>UILabel</code> view	 * 	 * <p>Copyright 2011 Raweden. All rights reserved.</p>	 * 	 * @author Raweden	 */	public class UILabel extends UIView{				// 		// TODO: implement a method to resize the bounds after the text bounds.		// TODO: add better behavior when setting font-face, it should check whether the font is avaible.		// TODO: implement truncate based from center of string.		// TODO: write better documentation.		// TODO: better system to manage embeded fonts.				private static const DEFAULT_TEXTFORMAT:TextFormat = new TextFormat("Arial",13,0x101010);				// properties that decrible the text.		private var _text:String;		private var _truncate:String = "none";		private var _font:String		private var _size:Number;		private var _align:String = "center";		private var _textColor:uint = 0x000000;				// text render properties.		private var _render:TextField;		private var _textFormat:TextFormat;				/**		 * Constructor.		 * 		 * @param parent When specified the component will be added to that container upon creation.		 */		public function UILabel(parent:DisplayObjectContainer = null){			super(parent);			// initilizes this instance.			addChildren();			init();		}				/**		 * Creates and adds related views.		 */		private function addChildren():void{			// creates the text-field to hold the text label.			_render = new TextField();			_render.defaultTextFormat = DEFAULT_TEXTFORMAT;			_render.autoSize = TextFieldAutoSize.LEFT;			_textFormat = new TextFormat();			_render.height = height;			_render.embedFonts = false;			_render.selectable = false;			_render.mouseEnabled = false;			this.addChild(_render);		}				/**		 * Instance initilization.		 */		private function init():void{			// setting the defaults size.			this.resize(120,16);		}				//------------------------------------		// Getting and Setting Text Properties		//------------------------------------				/**		 * 		 * 		 * @default <code>null</code>		 */		public function set text(value:String):void{			_render.text = value;			_text = value;			this.needsLayout();		}		// return the current value of the text attribute.		public function get text():String{			return(_text)		}				/**		 * 		 * 		 * @default <code>"none"</code>		 */		public function set truncate(value:String):void{			_truncate = value;		}		// return the current value of the truncate attribute.		public function get truncate():String{			return _truncate;		}				/**		 * 		 * 		 * @default <code>"Arial"</code>		 */		public function set font(value:String):void{			_textFormat.font = value;			applyFormat(_textFormat);		}		// return the current value of the font attribute.		public function get font():String{			return _textFormat.font;		}				/**		 * A Boolean value that determine whether the <code>UILabel</code> instance		 * should use emebed fonts to render the text.		 * 		 * @default <code>false</code>		 */		public function set useEmbeddedFonts(value:Boolean):void{			_render.embedFonts = value;		}		// return the current value of the useEmbeddedFonts attribute.		public function get useEmbeddedFonts():Boolean{			return _render.embedFonts;		}				/**		 * 		 * 		 * @default <code>0x000000</code>		 */		public function set textColor(value:uint):void{			_textFormat.color = value;			applyFormat(_textFormat);		}		// return the current value of the textColor attribute.		public function get textColor():uint{			return _textFormat.color as uint;		}				/**		 * 		 * 		 * @default <code>13</code>		 */		public function set size(value:Number):void{			_textFormat.size = value;			applyFormat(_textFormat);		}		// return the current value of the size attribute.		public function get size():Number{			return _textFormat.size as Number;		}				/**		 * 		 * 		 * @default <code>"left"</code>		 */		public function set align(value:String):void{			switch(value){				case "left":					_render.autoSize = value;					break;				case "center":					_render.autoSize = value;					break;				case "right":					_render.autoSize = value;					break;				default:					break;			}					}		// return the current value of the align attribute.		public function get align():String{			return(_render.autoSize);		}				//------------------------------------		//	GRAPHICAL RENDER METHODS		//------------------------------------				/**		 * @inheritDoc		 */		override protected function layout(rect:Rectangle):void{			if(_text)				truncateText(rect.width);			var w:int = _render.width;			var h:int = _render.height;			switch (_render.autoSize) {				case TextFieldAutoSize.CENTER:					_render.x = (rect.width-w)*0.5;					break;				case TextFieldAutoSize.LEFT:					_render.x = 0;					break;				case TextFieldAutoSize.RIGHT:					_render.x = -(w - rect.width);					break;			}		}					/**		 * Utility method for truncate the text string displayed.		 */		private function truncateText(width:Number,suffix:String = "..."):void{			var str:String = _text;			var i:int = str.length;			if(_truncate == "none"){				_render.text = str;				return;			}else if(_truncate == "right"){				while(_render.textWidth > width-4 && str.length > 0){					str = str.substr(0,str.length-1);					while(str.charAt(str.length-1) == " "){						str = str.substr(0,str.length-1);					}							_render.text = str+suffix;				}					return;			}else if(_truncate == "center"){				// NOT IMPLEMENTED YEAT.				return;			}else if(_truncate == "left"){				while(_render.textWidth > width-4 && str.length > 0){					str = str.substr(1);					while(str.charAt() == " "){						str = str.substr(1);					}							_render.text = suffix+str;				}				return;			}		}				/**		 * Utility method for applying text formation onto the textfield in the component.		 */		private function applyFormat(format:TextFormat):void{			_render.defaultTextFormat = format;			_render.setTextFormat(format);		}				//------------------------------------		// Deconstruction		//------------------------------------				/**		 * @inheritDoc		 */		override public function dispose():void{			// destoying the super implemenation.			super.dispose();		}			}}