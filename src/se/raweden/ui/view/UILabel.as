﻿////	UILabel.as//	Core UI Framework////	Created by Raweden on 2011-07-11//	Copyright 2011 Raweden. Some rights reserved.//package se.raweden.ui.view{	import flash.display.DisplayObjectContainer;	import flash.geom.Rectangle;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;	import flash.text.TextFormat;		import se.raweden.core.core;			/**	 * A <code>UILabel</code> view	 * 	 * <p> Copyright 2011 Raweden. All rights reserved.</p>	 * @author Raweden	 */	public class UILabel extends UIView{				// 		// TODO: implement a method to resize the bounds after the text bounds.		// TODO: add better behavior when setting font-face, it should check whether the font is avaible.		// TODO: implement truncate based from center of string.		// TODO: write better documentation.		// TODO: better system to manage embeded fonts.		//				use namespace core;				private static const DEFAULT_TEXTFORMAT:TextFormat = new TextFormat("Arial",13,0x101010);				private var m_render:TextField;		private var m_truncate:String = "none";		private var m_text:String;		private var m_textFormat:TextFormat;		private var _html:Boolean = false;				/**		 * Constructor.		 */		public function UILabel(parent:DisplayObjectContainer = null,frame:Rectangle = null){			super(parent,frame);			// initilizes this instance.			addChildren();			init();		}				// adding DisplayObject and sub-component to this component instance.		private function addChildren():void{			// creates the text-field to hold the text label.			m_render = new TextField();			m_render.defaultTextFormat = DEFAULT_TEXTFORMAT;			m_render.autoSize = TextFieldAutoSize.LEFT;			m_textFormat = new TextFormat();			m_render.height = height;			m_render.embedFonts = false;			m_render.selectable = false;			m_render.mouseEnabled = false;			this.addChild(m_render);		}				// Initilizes the label instance.		private function init():void{			// setting the defaults size.			this.resize(120,16);		}				//------------------------------------		// Getting and Setting Text Properties		//------------------------------------				/**		 * 		 * 		 * @default <code>null</code>		 */		public function set text(value:String):void{			_html = false;			m_render.text = value;			m_text = value;			this.setNeedsLayout();		}		// returns the current text set as label.		public function get text():String{			return(m_text)		}				/**		 * 		 * 		 * @default <code>"none"</code>		 */		public function set truncate(value:String):void{			m_truncate = value;		}		// return the current truncation type.		public function get truncate():String{			return m_truncate;		}				/**		 * 		 * 		 * @default <code>false</code>		 */		public function set wordWrap(value:Boolean):void{			m_render.wordWrap = value;		}		// indicates if wordWrap is currently enabled.		public function get wordWrap():Boolean{			return(m_render.wordWrap);		}				/**		 * 		 * 		 * @default <code>"Arial"</code>		 */		public function set font(value:String):void{			m_textFormat.font = value;			applyFormat(m_textFormat);		}		// returns the current font.		public function get font():String{			return m_textFormat.font;		}				/**		 * A Boolean value that determine whether the <code>UILabel</code> instance		 * should use emebed fonts to render the text.		 * 		 * @default <code>false</code>		 */		public function set useEmbeddedFonts(value:Boolean):void{			m_render.embedFonts = value;		}		//		public function get useEmbeddedFonts():Boolean{			return m_render.embedFonts;		}				/**		 * 		 * 		 * @default <code>0x000000</code>		 */		public function set textColor(value:uint):void{			m_textFormat.color = value;			applyFormat(m_textFormat);		}		// returns the current textcolor.		public function get textColor():uint{			return m_textFormat.color as uint;		}				/**		 * 		 * 		 * @default <code>13</code>		 */		public function set size(value:Number):void{			m_textFormat.size = value;			applyFormat(m_textFormat);		}		// indicates the current fontsize.		public function get size():Number{			return m_textFormat.size as Number;		}				/**		 * 		 * 		 * @default <code>"left"</code>		 */		public function set align(value:String):void{			value = (value == "left" || value  == "center" || value == "right") ? value : "left";			m_render.autoSize = value;		}		// indicates the current align.		public function get align():String{			return(m_render.autoSize);		}				//------------------------------------		//	GRAPHICAL RENDER METHODS		//------------------------------------				/**		 * @inheritDoc		 */		override protected function layout(rect:Rectangle):void{			if(m_text)				truncateText(rect.width);			var w:int = m_render.width;			var h:int = m_render.height;			switch (m_render.autoSize) {				case TextFieldAutoSize.CENTER:					m_render.x = (rect.width-w)*0.5;					break;				case TextFieldAutoSize.LEFT:					m_render.x = 0;					break;				case TextFieldAutoSize.RIGHT:					m_render.x = -(w - rect.width);					break;			}		}					private function truncateText(width:Number,suffix:String = "..."):void{			var str:String = m_text;			var i:int = str.length;			if(m_truncate == "none"){				m_render.text = str;				return;			}else if(m_truncate == "right"){				while(m_render.textWidth > width-4 && str.length > 0){					str = str.substr(0,str.length-1);					while(str.charAt(str.length-1) == " "){						str = str.substr(0,str.length-1);					}							m_render.text = str+suffix;				}					return;			}else if(m_truncate == "center"){				// NOT IMPLEMENTED YEAT.				return;			}else if(m_truncate == "left"){				while(m_render.textWidth > width-4 && str.length > 0){					str = str.substr(1);					while(str.charAt() == " "){						str = str.substr(1);					}							m_render.text = suffix+str;				}				return;			}		}				private function applyFormat(format:TextFormat):void{			m_render.defaultTextFormat = format;			m_render.setTextFormat(format);		}				//------------------------------------		// Deconstruction		//------------------------------------				/**		 * @inheritDoc		 */		override public function dispose():void{			// destoying the super implemenation.			super.dispose();		}			}}/*Accessing the Text Attributestext  propertyfont  propertytextColor  propertytextAlignment  propertylineBreakMode  propertyenabled  propertySizing the Label’s TextadjustsFontSizeToFitWidth  propertybaselineAdjustment  propertyminimumFontSize  propertynumberOfLines  propertyManaging Highlight ValueshighlightedTextColor  propertyhighlighted  propertyDrawing a ShadowshadowColor  propertyshadowOffset  propertyDrawing and Positioning Overrides– textRectForBounds:limitedToNumberOfLines:– drawTextInRect:Setting and Getting AttributesuserInteractionEnabled  property*/