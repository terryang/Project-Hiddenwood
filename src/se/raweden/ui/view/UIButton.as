﻿package se.raweden.ui.view{	import flash.display.BitmapData;	import flash.display.DisplayObjectContainer;	import flash.events.MouseEvent;	import flash.geom.Rectangle;		import se.raweden.ui.UIImage;	/**	 * A <code>UIButton</code> component	 * 	 * <p>Copyright 2011 Raweden. All rights reserved.</p>	 * 	 * @author Raweden	 */	public class UIButton extends UIControl{				//		// TODO: Add support for title for state.		//				private var _toggle:Boolean = false;		private var _callback:Function;		// Button States Styles.		private var _backgrounds:Object;		private var _images:Object;		// Related Views.				private var _titleView:UILabel;		private var _imageView:UIImageView;				/**		 * Constructor.		 * 		 * @param parent		 * @param callback		 */		public function UIButton(parent:DisplayObjectContainer = null,callback:Function = null){			super(parent);			_callback = callback;			addChildren();			init();		}				/**		 * Creates and adds related views.		 */		private function addChildren():void{					}				/**		 * Initlizes this button instance.		 */		private function init():void{			resize(90,22);			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);			this.addEventListener(MouseEvent.CLICK,onMouseClick);		}				//------------------------------------ 		// Responding to User interaction		//------------------------------------				/**		 * Triggerd when the Button instace resives a mouse down event.		 */		private function onMouseDown(e:MouseEvent):void{			if(_toggle){				this.highlighted = !this.highlighted;			}else{				stage.addEventListener(MouseEvent.MOUSE_UP,onMouseEvent);				this.highlighted = true;			}		}				/**		 * Triggerd when the Button instance resives a muse click event.		 */		private function onMouseClick(e:MouseEvent):void{			if(_callback != null){				_callback.length == 1 ? _callback(this) : _callback();							}		}				/**		 * Triggerd when the Button instance resives a mouse event.		 */		private function onMouseEvent(e:MouseEvent):void{			var type:String = e.type;			if(!_toggle && type == MouseEvent.MOUSE_UP){				stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseEvent);				if(!_toggle)					this.highlighted = false;				return;			}		}						//------------------------------------		// Configuring Button Title		//------------------------------------				/**		 * Specifies the default label of the button.		 * 		 * @default <code>null</code>		 */		public function set title(value:String):void{			titleView.text = value;			this.needsLayout();		}		//		public function get title():String{			return _titleView.text;		}				/**		 * Specifies the default label of the button.		 * 		 * @default <code>null</code>		 */		public function set titleColor(value:uint):void{			titleView.textColor = value;		}		//		public function get titleColor():uint{			return _titleView.textColor;		}				/**		 * 		 */		public function get titleView():UILabel{			if(!_titleView){				_titleView = new UILabel(this);				_titleView.align = "center";				_titleView.textColor = 0xCCCCCC;				_titleView.size = 16;				_titleView.y = 4;				_titleView.height = 18;				this.needsLayout();			}			return _titleView;		}				//------------------------------------		// Configuring Button Icon		//------------------------------------				/**		 * 		 * @param image		 * @param state		 */		public function setImage(image:BitmapData,state:int):void{			if(!_images){				_images = {};			}			_images[state] = image;			if(this.state == state){				this.needsDraw();				this.needsLayout();				}		}				/**		 * 		 * @param state		 */		public function image(state:int):BitmapData{			return _images ? _images[state] : null;		}				/**		 * 		 */		public function get imageView():UIImageView{			if(!_imageView){				_imageView = new UIImageView(this);				this.needsLayout();			}			return _imageView;		}				//------------------------------------		// Getting and Setting Attributes		//------------------------------------						/**		 * Specifies the callback function to be called when then the UIButton instance is clicked.		 * 		 * <p><h1>example</h1><code>button.callback = function(button:UIButton):void{}</code></p>		 * 		 * @default <code>null</code>		 */		public function set callback(value:Function):void{			_callback = value;		}		//		public function get callback():Function{			return _callback;		}								/**		 * Specifies if the button is a toggle button.		 * 		 * @default <code>false</code>		 */		public function set toggle(value:Boolean):void{			if(value != _toggle){				_toggle = value;				needs("draw",draw);			}		}		//		public function get toggle():Boolean{			return _toggle;		}				//------------------------------------		// Customize Button States		//------------------------------------						/**		 * 		 * @oaram image		 * @param state		 */		public function setBackground(image:BitmapData,state:int):void{			if(!_backgrounds){				_backgrounds = {};			}			_backgrounds[state] = image;			if(this.state == state)				this.needs("draw",draw);		}				/**		 * 		 * @param state		 * @return		 */		public function background(state:int):BitmapData{			return _backgrounds ? _backgrounds[state] : null;		}				//------------------------------------		// Updating Content Displayed.		//------------------------------------						/**		 * @inheritDoc		 */		override protected function draw(rect:Rectangle):void{			var w:int = rect.width;			var h:int = rect.height;						if(_images){				// Drawing button icon.				var image:BitmapData = _images[state] ? _images[state] : _images[UIControlState.Normal];				imageView.image = image;				rect.width = rect.width < image.width ? image.width : rect.width;				rect.height = rect.height < image.height ? image.height : rect.height;			}						if(_backgrounds){								// filling bitmap background with cap grid.				var background:BitmapData = !_backgrounds[state] && this.enabled ? _backgrounds[UIControlState.Normal] : _backgrounds[state];				var custom:UIImage;				if(background is UIImage){					custom = background as UIImage;					if(custom.topCap == -1){						rect.height = custom.height;					}					if(custom.leftCap == -1){						rect.width = custom.width;					}					this.graphics.clear();					var size:Rectangle = custom.drawOn(this.graphics,rect,false);				}else{										// filling bitmap background witout cap grid.					rect.height = background.height;					rect.width = background.width;					this.graphics.clear();					this.graphics.beginBitmapFill(background);					this.graphics.drawRect(0,0,rect.width,rect.height);					this.graphics.endFill();				}			}else{								// Filling temporary markup bounds.				this.graphics.clear();				this.graphics.beginFill(0xFF0000,0.1);				this.graphics.drawRect(0,0,rect.width,rect.height);				this.graphics.endFill();			}		}				/**		 * @inheritDoc		 */		override protected function layout(rect:Rectangle):void{			if(_titleView && _imageView){				trace("using both title and image are not supported yeat");				return;			}else{				// Laying out label.				if(_titleView){					_titleView.width = rect.width;					_titleView.height = rect.height;				}								if(_imageView){					_imageView.x = Math.round((rect.width-_imageView.height)*0.5);					_imageView.y = Math.round((rect.height-_imageView.height)*0.5);				}			}					}				//------------------------------------		// Deconstruction		//------------------------------------				/**		 * @inheritDoc		 */		override public function dispose():void{			// removing eventlistners.			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);			this.removeEventListener(MouseEvent.CLICK,onMouseClick);			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseEvent);			// destroying the super object.			super.dispose();		}			}}