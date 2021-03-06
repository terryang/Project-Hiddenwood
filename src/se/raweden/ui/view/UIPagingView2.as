package se.raweden.ui.view
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	
	import se.raweden.motion.Tween;

	public class UIPagingView2 extends UIView{
		
		// Constants 
		
		private static const DEFAULT_SHADOW:DropShadowFilter = new DropShadowFilter(10,90,0x000000,0.45,20,20,1,3);
		
		public static const SPACING:Number = 10;
		public static const SCALE:Number = 0.6;
		
		public static const DECK_SPACING:Number = 90;
		
		// Instance Variables.
		
		private var _continuous:Boolean = false;
		private var _mode:String = UIPagingViewMode.PAGE;
		private var _index:int = 0;
		private var _pages:Array = [];
		
		// Data source delegation.
		private var _getPageViewFunction:Function;
		private var _getLengthFunction:Function
		private var _getTitleFunction:Function;
		private var _getDetailsFunction:Function;
		private var _getHeaderViewFunction:Function;
		
		// Realated Views.
		private var _mask:Shape;
		private var _background:Sprite;
		private var _content:Sprite;
		private var _pageControl:UIPageControl;
		private var _labelView:UILabel;
		private var _detailsView:UILabel;


		public function UIPagingView2(){
			super();
		}
		
		/**
		 * 
		 */
		private function addChildren():void{
			// Adding background Container.
			_background = new Sprite();
			_background.name = "background";
			this.addChild(_background);
			
			// Adding page content container.
			_content = new Sprite();
			_content.name = "content";
			this.addChild(_content);
			
			// Adding page control to background container.
			_pageControl = new UIPageControl(_background);
			
			// TODO: add masking
		}
		
		/**
		 * 
		 */
		private function init():void{
			_pages = [];
			// setting default size.
			resize(640,360);
		}
		
		
		//------------------------------------------------------------------------
		// DataSource reference
		// these function pointers bellow allow other object to implement
		// the model and provide the paging view with data when needed.
		
		
		/**
		 * Required. <code>function(pagingView:UIPagingView,index:int):UIView</code>
		 */
		public function get getPageViewFunction():Function{
			return _getPageViewFunction;
		}
		
		public function set getPageViewFunction(value:Function):void{
			_getPageViewFunction = value;
		}
		

		/**
		 * Required. <code>function(pagingView:UIPagingView):int</code>
		 */
		public function get getLengthFunction():Function{
			return _getLengthFunction;
		}
		
		public function set getLengthFunction(value:Function):void{
			_getLengthFunction = value;
		}
		
		/**
		 * Optional. <code>function(pagingView:UIPagingView,index:int):String</code>
		 */
		public function get getTitleFunction():Function{
			return _getTitleFunction;
		}
		
		public function set getTitleFunction(value:Function):void{
			_getTitleFunction = value;
		}
		
		
		/**
		 * Optional. <code>function(pagingView:UIPagingView,index:int):String</code>
		 */
		public function get getDetailsFunction():Function{
			return _getDetailsFunction;
		}
		
		public function set getDetailsFunction(value:Function):void{
			_getDetailsFunction = value;
		}
		
		
		/**
		 * Optional. <code>function(pagingView:UIPagingView,index:int):UIView</code>
		 */
		public function get getHeaderViewFunction():Function{
			return _getHeaderViewFunction;
		}
		
		public function set getHeaderViewFunction(value:Function):void{
			_getHeaderViewFunction = value;
		}
		
		
		//------------------------------------------------------------------------
		// Setting and Getting properties.
		
		
		/**
		 * A <code>Boolean</code> value that determine whether the <code>UIPagingView</code>
		 * should continuous paging.
		 */
		public function set continuous(value:Boolean):void{
			if(value != _continuous){
				_continuous = value;
				// TODO: implement the continous property
			}
		}
		// return a boolean value that determine whether the paging is continuous.
		public function get continuous():Boolean{
			return _continuous;
		}
		
		
		/**
		 * Determines the current selected index.
		 */
		public function set currentPage(value:uint):void{
			if(value < _pages.length){
				scrollToPageAt(value,stage != null);
			}
		}
		// Returns the current page index.
		public function get currentPage():uint{
			return _index;
		}
		
		
		/**
		 * A value from the UIPagingViewMode class that specifies which determine the view mode.
		 * 
		 * The following are valid values:
		 * <li><code>"deck"</code> or <code>UIPagingViewMode.DECK</code>
		 * <li><code>"page"</code> or <code>UIPagingViewMode.PAGE</code>
		 * 
		 * @default <code>UIPagingViewMode.PAGE</code>
		 * 
		 * @see UIPagingViewMode
		 */
		public function set mode(value:String):void{
			setMode(value,stage != null);
		}
		// returns the current mode.
		public function get mode():String{
			return _mode;
		}
		
		
		/**
		 * Determines the number of pages in this paging view.
		 */
		public function get numberOfPages():int{
			return _pages.length;
		}
		
		
		/**
		 * A <code>Array</code> containing all visible pages.
		 */
		public function get visiblePages():Array{
			var pages:Array = [];
			for(var i:int = 0;i<_pages.length;i++){
				if(_pages[i] != null){
					pages.push(_pages[i]);
				}
			}
			return pages.length > 0 ? pages : null;
		}
		
		
		//------------------------------------------------------------------------
		// Managing View mode.
		
		
		/**
		 * 
		 * @param mode
		 * @param animated A Boolean value that determine whether the transition should be animated
		 */
		public function setMode(mode:String,animated:Boolean = true):void{
			switch(mode){
				case UIPagingViewMode.DECK: deckMode(animated);break;
				case UIPagingViewMode.PAGE: pageMode(animated);break;
			}
		}
		
		
		/**
		 * 
		 * 
		 * @param animated A Boolean value that determine whether the transition should be animated
		 */
		private function deckMode(animated:Boolean):void{
			var rect:Rectangle = new Rectangle(0,0,this.width*SCALE,this.height*SCALE);
			var width:Object = {};
			var height:Object = {};
			var page:UIView;
			var mx:Number = Math.floor((this.width+SPACING)*_index);
			var my:Number = 0;
			var tx:Number = mx;
			var ty:Number;
			//
			mouseEnabled = false;
			//
			mx = Math.round(mx+ ((this.width-rect.width) * 0.5));
			my = Math.round((this.height-rect.height)*0.5);
			ty = my;
			
			trace("asign page:",page = loadPage(_index+1));
			
			// Prepares the page before current one.
			if(_index > 0){
				page = loadPage(_index-1);
				if(page){
					trace("adding page in deck-mode before current one");
					prepareForDeck(page);
					page.x = tx-rect.width;
					page.y = ty;
					_content.addChild(page);
					Tween.to(page,0.3,{x:Math.round(mx-(rect.width+DECK_SPACING))},{transition:"sineOut",delay:0.1});
				}
			}
			
			// Prepares the page after current one.
			if(_index < _pages.length){
				page = loadPage(_index+1);
				if(page){
					trace("adding page in deck-mode after current one");
					prepareForDeck(page);
					page.x = tx+this.width;
					page.y = ty;
					_content.addChild(page);
					Tween.to(page,0.3,{x:Math.round(mx+(rect.width+DECK_SPACING))},{transition:"sineOut",delay:0.1});
				}
			}
			trace("content.x",_content.x);
			trace("tx:",tx);
			trace("page.x",mx);
			
			// Prepares the current page.
			page = pageAt(_index);
			
			page.tabEnabled = false;
			page.mouseChildren = false;
			page.addEventListener(MouseEvent.CLICK,onClick);
			page.filters = [DEFAULT_SHADOW];
			page.cacheAsBitmap = true;
			_content.setChildIndex(page,_content.numChildren-1);
			Tween.to(page,0.3,{scaleX:SCALE,scaleY:SCALE,x:mx,y:my},{transition:"none",onComplete:modeAnimationComplete});
			
			// Prepares the background UI.
			if(_background.parent != this){
				this.addChildAt(_background,0);
			}
			
			// 
			needs("draw",draw);
			_mode = UIPagingViewMode.DECK;
			
			// Prepares the title and detailed text for the current page.
			_labelView.text = getTitleFunction != null ? getTitleFunction(_index) || "" : "";
			_labelView.text = getDetailsFunction != null ? getDetailsFunction(_index) || "" : "";
		}
		
		
		/**
		 * 
		 * 
		 * @param animated A Boolean value that determine whether the transition should be animated
		 */
		private function pageMode(animated:Boolean):void{
			var rect:Rectangle = new Rectangle(0,0,this.width*SCALE,this.height*SCALE);
			var page:UIView;
			var tx:Number = Math.floor((width+SPACING)*_index);
			var ty:Number = 0;
			//
			this.mouseEnabled = false;
			//
			//tx = Math.round(tx+((width-rect.width)*0.5));
			
			// Brings the current page as the front most.
			page = pageAt(_index);
			
			page.tabEnabled = true;
			page.mouseChildren = true;
			page.removeEventListener(MouseEvent.CLICK,onClick);
			
			//prepareForPage(page);
			_content.setChildIndex(page,_content.numChildren-1);	// sineOut
			
			// Starting animation to mode.
			Tween.to(page,0.33,{scaleX:1,scaleY:1,x:tx,y:ty},{transition:"none",onComplete:modeAnimationComplete});
			
			// Updates the mode reference value.
			_mode = UIPagingViewMode.PAGE;
		}
		
		
		/**
		 * Scrolls to the page at a specified index.
		 *
		 * @param index The index 
		 * @param animated A Boolean value that determine whether the transition should be animated.
		 */
		public function scrollToPageAt(index:int,animated:Boolean = true):void{
			if(index == _index){
				return;
			}else if(index < 0 && index >= _pages.length-1){
				throw new RangeError("index is out of range");
			}
			
			var tx:Number;	
			if(_mode == UIPagingViewMode.DECK){
				
				// TODO: think through a better way to determine the cordinate to scroll to.
				
				/*
				// Getting center of view.
				var rect:Rectangle = DisplayObject(_pages[index]).getBounds(_content);
				tx = -Math.floor((width+SPACING)*_index);
				// Updating the label and detailed text for the final page.
				labelView.text =  _dataSource.titleForPageAt(index);
				detailsView.text = _dataSource.subtitleForPageAt(index);
				// Animating the transition to the new current page.
				if(animated){
				Tween.to(_content,0.3,{x:tx},{transition:"sineInOut",onUpdate:onScroll,onComplete:onScrollComplete});
				}else{
				_content.x = tx;
				onScrollComplete();
				}
				*/
			}else if(_mode == UIPagingViewMode.PAGE){
				tx = -(width+SPACING)*index;
				if(animated){
					Tween.to(_content,0.3,{x:tx},{transition:"sineInOut",onUpdate:onScroll,onComplete:onScrollComplete});
				}else{
					_content.x = tx;
					onScrollComplete();
				}
			}
			_index = index;
		}

		
		//------------------------------------------------------------------------
		// Managing Pages.
		
		
		/**
		 * Determine the index of a specific page and returns the index or <code><-1/code> 
		 * if page isn't currently visible.
		 * 
		 * @param index
		 * @return
		 */
		public function indexForPage(page:UIView):int{
			return page ? _pages.indexOf(page) : -1;
		}	
		
		
		/**
		 * Returns the page view at index, or a value of <code>null</code> if page isn't currently visible.
		 */
		public function pageAt(index:int):UIView{
			if(index >= 0 && index < _pages.length){
				return _pages[index];
			}
			return null;
		}
		
		
		/**
		 * Inserts one page into the <code>UIPagingView</code> instance.
		 * 
		 * <p>This method validates the insertion by checking the new length against the
		 * <code>numberOfPages</code> property on the dataSource. The length of the property
		 * should be equal to the previous number of pages plus the page inserted.<p>
		 * 
		 * @param index An integer that specifies the index where the page will be inserted.
		 * @param animated A <code>Boolean</code> value that determine whether the insertion 
		 * should be animated if visible.
		 */
		public function insertPageAt(index:int, animated:Boolean = true):void{
			var len:int = getLengthFunction(this);
			// Determine if insertion is valid.
			if(_pages.length+1 != len){
				return;
			}
			var tx:Number = 0;
			// Prepares insertion of page.
			var current:UIView = _pages[index];
			_pages.splice(index,0,null);
			
			// Loading the page from data source.
			var page:UIView = loadPage(index);
			tx = Math.floor((width+SPACING)*index);
			if(_mode == UIPagingViewMode.DECK){
				prepareForDeck(page);
			}else{
				prepareForPage(page);
			}
			
			page.x = tx;
			page.resize(width,height);
			page.render();
			page.alpha = 0.0;
			
			// TEMP!
			trace("inserting page at index:",_index,", page:",page);
			
			// Animates all pages right of the insertion to make room for the new.
			for(var i:int = 0;i<_pages.length;i++){
				var existingPage:UIView = _pages[i];
				if(existingPage && existingPage != page){
					if(index <= i){
						tx = existingPage.x+width+SPACING;
						Tween.to(existingPage,0.33,{x:tx},{transition:"sineInOut"});
					}
				}
			}
			
			// Adding new page to display-list.
			if(current){
				// adding the new page just below the current one.
				_content.addChildAt(page,_content.getChildIndex(current));
			}else{
				_content.addChild(page);
			}
			
			// Animates the opacity of the new page.
			Tween.to(page,0.4,{alpha:1},{delay:0.33});
			_index = index;
			
			// Updating page indicator.
			_pageControl.numPages = len;
			_pageControl.updateCurrentPageDisplay();
			
			// TODO: Determine whether the insert page should replace any visible (done??).
		}
		
		
		/**
		 * Delete one page from the <code>UIPagingView</code> instance.
		 * 
		 * <p>This method validates the removal by checking the new length against the
		 * <code>numberOfPages</code> property on the dataSource. The length of the property
		 * should be equal to the previous number of pages minus the page removed.<p>
		 * 
		 * @param index An integer that specifies the index of the page to be removed.
		 * @param animated A <code>Boolean</code> value that determine whether the removal
		 * should be animated if visible.
		 */
		public function deletePageAt(index:int, animated:Boolean = true):void{
			var len:int = getLengthFunction(this);
			if(_pages.length-1 == len){
				// Prepares to delete the page.
				var page:UIView = pageAt(index);
				
				_pages.splice(index,1);
				//trace("paging-view::page "+page+" will be deleted at "+index);
				if(index == _index){
					//trace("paging-view::current page will be deleted and should now scroll to the next/previous page");
				}
				_pageControl.numPages = len;
				_pageControl.updateCurrentPageDisplay();
				throw new Error("delete is not implemented yeat");
				// TODO: implement removal of pages.
			}
		}
		
		
		/**
		 * Reload all or one specific page in the <code>UIPagingView</code> instance.
		 * 
		 * @param index An integer that specifies the index that will be reload or <code>-1</code> to reload the <code>UIPagingView</code> instance.
		 * @param animated A <code>Boolean</code> value that determine whether the reloading
		 * should be animated if visible.
		 */
		public function reload(index:int = -1, animated:Boolean = true):void{
			
			// Reload a single page if index is specified.
			if(index != -1)
				return reloadIndex(index,animated);
			
			// Reload the content of the view.
			var page:UIView;
			// removes all current pages.
			while(_pages.length > 0){
				page = _pages.shift();
				if(page){
					prepareForReuse(page);
				}
			}
			// storing properties.
			var index:int = _index;
			var len:int = this.getLengthFunction();
			// resolving previous current page.
			page = this.getPageViewFunction(index);
			index = index > len-1 ? len-1 : index;
			// managing the current active page.
			page = this.getPageViewFunction(index);
			page.y = 0;
			page.x = Math.floor((width+SPACING)*index);
			page.resize(width,height);
			_content.addChild(page);
			_pages.length = len;
			_pages[index] = page;
			// Scrolls to the current Index.
			if(_index != index){
				scrollToPageAt(index,true);
			}
			_index = index;
			// Updating paging Indicator.
			_pageControl.currentPage = index;
			_pageControl.numPages = len;
			_pageControl.updateCurrentPageDisplay();
		}
		
		/**
		 * Reloads the page at the specified index.
		 * 
		 * @param index The index of the page to be reloaded.
		 * @param animated A Boolean value that determine whether the reloading should be animated.
		 */
		private function reloadIndex(index:int,animated:Boolean = true):void{
			if(_pages[index] == null)
				return;
			
			var a:UIView = _pages[index];
			var b:UIView = this.getPageViewFunction(index);
			// 
			if(a == b){
				return;
			}
			//
			if(animated){				
				// TODO: save the old page+index in memorary to insert the new view at that index.
				Tween.to(a,0.25,{alpha:0},{onComplete:_reloadPage,onCompleteParams:[a,b,true]});
			}else{
				_reloadPage(a,b,false);
			}
			
		}
		
		private function _reloadPage(a:UIView,b:UIView,animated:Boolean = true):void{
			var index:int = _pages.indexOf(a);
			if(index == -1){
				// dispose the action here.
				return;
			}
			_pages[index] = b;
			b.resize(a.width,a.height);
			b.x = a.x;
			b.y = a.y;
			b.scaleX = a.scaleX;
			b.scaleY = a.scaleY;
			
			if(animated){
				b.alpha = 0;
				_content.addChild(b);
				Tween.to(b,0.25,{alpha:1});
			}
			_content.removeChild(a);
			prepareForReuse(a);
			
		}

		
		// 
		
		/**
		 * 
		 * @param index
		 * @return 
		 */
		private function loadPage(index:int):UIView{
			if(getPageViewFunction == null){
				throw new Error("No datesource specified");
			}
			//
			var page:UIView = getPageViewFunction(index);
			if(page){
				_pages[index] = page;
				
				// insert more logic code here.
				
				return page;
			}
			return null;
		}
		
		
		/**
		 * Reverts most changes applied by the paging view.
		 * 
		 * @param page
		 */
		private function prepareForReuse(page:UIView):void{
			// Removes the page from displaylist.
			if(_content.contains(page)){
				_content.removeChild(page);
			}
			page.tabEnabled = true;
			page.mouseChildren = true;
			page.scaleX = 1;
			page.scaleY = 1;
			page.filters = null;
			page.removeEventListener(MouseEvent.CLICK,onClick);
		}
		
		/**
		 * 
		 * 
		 * @param page
		 */
		private function prepareForDeck(page:UIView):void{
			page.tabEnabled = false;
			page.mouseChildren = false;
			page.addEventListener(MouseEvent.CLICK,onClick);
			// from legacy prepareViewAt
			page.scaleX = page.scaleY = SCALE;
			page.resize(width,height);
			page.filters = [DEFAULT_SHADOW];
		}
		
		/**
		 * 
		 * 
		 * @param page
		 */
		private function prepareForPage(page:UIView):void{
			page.tabEnabled = true;
			page.mouseChildren = true;
			page.removeEventListener(MouseEvent.CLICK,onClick);
			// from legacy prepareViewAt
			page.scaleX = page.scaleY = 1.0;
			page.resize(width,height);
		}
		
		
		//------------------------------------
		// Updating Visual Apperance
		//------------------------------------
		
		
		/**
		 * @inheritDoc
		 */
		override protected function draw(rect:Rectangle):void{
			this.graphics.clear();
			if(_mode == UIPagingViewMode.DECK){
				this.graphics.beginFill(0xF5F5F5);
			}else{
				this.graphics.beginFill(0x000000);
			}
			this.graphics.drawRect(0,0,rect.width,rect.height);
			this.graphics.endFill();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function layout(rect:Rectangle):void{
			// Rearranges the Paging indicator.
			_pageControl.width = rect.width;
			_pageControl.y = rect.height-_pageControl.height;
			// Layouts the label text view.
			_labelView.x = Math.round((width-_labelView.width)*0.5);
			// Layouts the details text view.
			_detailsView.x = Math.round((width-_detailsView.width)*0.5);
			_detailsView.y = Math.round(_labelView.height+10);
			// Layouts the current visible pages.
			layoutView(rect);
			
		}
		
		/**
		 * @private
		 */
		protected function layoutView(rect:Rectangle):void{
			// Layouts the current visible pages.
			for(var i:int = 0;i<_pages.length;i++){
				var page:UIView = _pages[i];
				if(page)
					page.resize(rect.width,rect.height);
			}
		}
		
		
		//------------------------------------
		// Getting Related Views.
		//------------------------------------
		
		
		/**
		 * Returns the <code>Sprite</code> layer that contains the background in deck mode.
		 */
		public function get background():Sprite{
			return _background;
		}
		
		/**
		 *  Return the <code>UILabel</code> component used to render the label text in deck mode.
		 */
		public function get labelView():UILabel{
			if(!_labelView){
				_labelView = new UILabel(_background);
				_labelView.width = 200;
				_labelView.align = "center";
				_labelView.size = 24;
			}
			return _labelView;
		}
		
		/**
		 * Return the <code>UILabel</code> component used to render the detailed text in deck mode.
		 */
		public function get detailsView():UILabel{
			if(!_detailsView){
				_detailsView = new UILabel(_background);
				_detailsView.width = 200;
				_detailsView.align = "center";
				_detailsView.size = 18;
			}
			return _detailsView
		}
		
		/**
		 * Return the <code>UIPageControl</code> used to indicate the index of the current page in deck mode.
		 */
		public function get pageControl():UIPageControl{
			return _pageControl;
		}
		
		
		//------------------------------------
		// Responding To User Interaction 
		//------------------------------------
		
		
		/**
		 * Invoked when the user cliks on the page thumbnail in deck mode.
		 */
		private function onClick(e:MouseEvent):void{
			var target:UIView = e.currentTarget as UIView;
			var index:int = _pages.indexOf(target);
			if(index == _index){
				setMode(UIPagingViewMode.PAGE);
			}else if(index != -1){
				scrollToPageAt(index,true);
			}
			// TODO: REMOVE THE LINE BELLOW
			trace("page ( "+target.toString()+" ) at index "+index+" where clicked");
		}
		
		
		//------------------------------------
		// Responding to Animation Changes.
		//------------------------------------
		
		
		/**
		 * Invoked when a mode transition is completed.
		 */
		private function modeAnimationComplete():void{
			mouseEnabled = true;
			
			if(_mode == UIPagingViewMode.PAGE){
				
				// Removes the background container from display list.
				if(_background.parent != null){
					_background.parent.removeChild(_background);
				}
				needs("draw",draw);
				// Prepares the views for reuse.
				for(var i:int = 0;i<_pages.length;i++){
					var page:UIView = _pages[i];
					if(i != _index && page != null){
						prepareForReuse(page);
						_pages[i] = null;
					}
				}
				pageAt(_index).filters = null;
			}else{
				
			}			
		}
		
		/**
		 * Invoked when a page animation is updated.
		 */
		private function onScroll():void{
			var i:int;
			var page:UIView;
			if(_mode == UIPagingViewMode.DECK){
				
				// TODO: determine the current actual index.
				
				var offset:Number = (-_content.x%width);
				trace("offset:",offset);
				// TODO: determine whether a new page should be loded in deck mode.
				
			}else if(_mode == UIPagingViewMode.PAGE){
				var viewRect:Rectangle = new Rectangle(-_content.x,0,width,height);
				var pageRect:Rectangle = new Rectangle(0,0,width,height);
				for(i = 0;i<_pages.length;i++){
					page = _pages[i];
					if(viewRect.intersects(pageRect)){
						if(!page){
							page = loadPage(i);
							prepareForPage(page);
							page.x = pageRect.x;
							page.y = 0;
							_content.addChild(page);
							trace("added page @ "+i);
						}
					}else{
						if(page){
							prepareForReuse(page);
							_pages[i] = null;
							trace("removed page @ "+i);
						}
					}
					pageRect.x += (width+SPACING);
				}
			}
		}
		
		/**
		 * Invoked when a page animation is completed.
		 */
		private function onScrollComplete():void{
			this.mouseEnabled = true;
			if(_mode == UIPagingViewMode.DECK){
				/*
				var tx:Number = Math.floor((width+SPACING)*_index);
				tx = Math.round(tx+((width-w)*0.5));
				
				var ty:Number = Math.round((height-(height*SCALE))*0.5);
				
				var w:Number = Math.round(width*SCALE);
				
				// Sets the positon of the view before the current one.
				var page:UIView = pageAt(_index-1);
				if(page != null){
				page.x = Math.round(tx-(w+DECK_SPACING));
				}else if(_index > 0){
				page = loadPage(_index-1);
				prepareForDeck(page);
				if(page){
				page.x = Math.round(tx-(width+DECK_SPACING));
				page.y = Math.round((height-(height*SCALE))*0.5);
				_content.addChild(page);
				}
				}
				
				// Sets the position of the current one.
				page = pageAt(_index);
				if(page == null){
				page = pageAt(_index-1) || loadPage(_index-1);
				prepareForDeck(page);
				page.y = ty;
				}
				page.x = tx;
				
				// Sets the position of the page after the current one.
				page = pageAt(_index+1);
				if(page != null){
				page.x = Math.round(tx+(w+DECK_SPACING));
				}else if(_index < _pages.length){
				page = pageAt(_index-1) || loadPage(_index-1);
				prepareForDeck(page);
				if(page){
				page.x = Math.round(tx+(w+DECK_SPACING));
				page.y = ty;
				_content.addChild(page);
				}
				}
				_content.x = -Math.floor((width+SPACING)*_index);
				*/
			}else if(_mode == UIPagingViewMode.PAGE){
				
			}			
			_pageControl.currentPage = currentPage;
			_pageControl.updateCurrentPageDisplay();
		}
		
		
		//------------------------------------
		// Deconstruction
		//------------------------------------
		
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void{
			
			// TODO: implement dispose method
			
			// destoying the super implemenation.
			super.dispose()
		}
	
	}
}