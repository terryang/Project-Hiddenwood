﻿package se.raweden.ui.view{	import flash.geom.Rectangle;	/**	 * A <code>UICollectionViewCell</code>	 *	 * Copyright 2011, Raweden. All Rights Reserved.	 *	 * @author Raweden	 */	public class UIGridViewCell extends UITableViewCell{				/**		 * Constructor.		 */		public function UIGridViewCell(identifier:String){			super(identifier);		}				//------------------------------------		// Updating Visual Apperance		//------------------------------------				/**		 * @inheritDoc		 */		override protected function layout(rect:Rectangle):void{			var y:int = rect.height;			if(this._imageView){				var size:int = 100; //Math.floor(rect.height*0.75);				_imageView.resize(size,size);				_imageView.x = (rect.width-_imageView.width)*0.5;			}			if(this._labelView){				this._labelView.width = rect.width;				this._labelView.y = _imageView ? _imageView.y+_imageView.height : y-_labelView.height;			}			if(this._detailLabel){				this._detailLabel.width = rect.width;				this._detailLabel.y = _labelView ? _labelView.y+_labelView.height+2 : rect.height-this._detailLabel.height;			}		}				/**		 * @inheritDoc		 */		override protected function draw(rect:Rectangle):void{			this.graphics.clear();			if(this.selected){				this.graphics.beginFill(0x2D2D2D,0.25);				this.graphics.drawRoundRect(3,3,rect.width-6,rect.height-6,12,12);				this.graphics.endFill();			}		}				//------------------------------------		// Deconstruction		//------------------------------------				/**		 * @inheritDoc		 */		override public function dispose():void{			// destoying the super implemenation.			super.dispose();		}			}}