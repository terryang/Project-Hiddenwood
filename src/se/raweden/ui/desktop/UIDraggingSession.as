﻿////	UIDraggingSession.as//	Core UI Framework////	Created by Raweden on 2011-07-27//	Copyright 2011 Raweden. All rights reserved.//package se.raweden.ui.desktop{	import flash.display.InteractiveObject;	import flash.events.MouseEvent;	import flash.geom.Point;
	/**	 * 	 */	public class UIDraggingSession{				private static var m_currentSequence:uint = 0;				private var m_pasteboard:UIPasteboard;		private var m_event:MouseEvent;		private var m_items:Array;		private var m_offset:Point;		private var m_sequence:uint;		private var m_location:Point;		// public vars.		public var slideBack:Boolean = false;				public function UIDraggingSession(pasteboard:UIPasteboard,items:Array){			m_pasteboard = pasteboard;			// getting the sequence id.			m_sequence = m_currentSequence;			m_currentSequence++;			m_items = items;		}				//------------------------------------		// Dragging Pasteboard.		//------------------------------------				/**		 * The pasteboard provided with this dragging session.		 */		public function get pasteboard():UIPasteboard{			return m_pasteboard;		}				//------------------------------------		// Dragging Session's Visual Representation.		//------------------------------------				/**		 * 		 */		public final function get items():Array{			return m_items;		}				//------------------------------------		// Identifying the Dragging Session.		//------------------------------------				/**		 * Indicates the sequence number for this dragging session.		 */		public final function get sequence():uint{			return m_sequence;		}				//------------------------------------		// Dragging Session Localtion Attributes.		//------------------------------------		public final function set draggingOffset(value:Point):void{			m_offset = value;		}				public final function get draggingOffset():Point{			return m_offset;		}				/**		 * The current dragging trackpoint location in stage coordinates.		 */		public final function get location():Point{			return UIDragging.session == this ? UIDragging.location : null;		}				public static function beginDragging(session:UIDraggingSession,event:MouseEvent):void{				UIDragging.beginDragging(session,event);					session.m_event = event;		}				public static function enumerateDraggingItems(view:InteractiveObject,callback:Function):void{					}			}}import flash.display.InteractiveObject;import flash.display.Stage;import flash.events.Event;import flash.events.MouseEvent;import flash.geom.Point;import se.raweden.ui.desktop.IDraggingDestination;import se.raweden.ui.desktop.UIDraggingSession;
class UIDragging{		private static var m_session:UIDraggingSession;	private static var m_startLocation:Point;	private static var m_location:Point = new Point();	private static var vx:int;	private static var vy:int;	private static var m_slideBack:Boolean;	// destination vars.	private static var m_destination:IDraggingDestination;		public static function beginDragging(session:UIDraggingSession,event:MouseEvent):void{	}		//------------------------------------	// Responding to User Interaction.	//------------------------------------		private static function onDragUpdate(e:Event):void{	}		private static function onDragEnter(e:MouseEvent):void{	}		private static function onDragExit(e:MouseEvent):void{	}		private static function onDragEnd(e:MouseEvent):void{	}		private static function completeDragEnd():void{	}		//------------------------------------	// Delays the update of the dragging items.	//------------------------------------		private static function onPosibleDestination():void{	}		//------------------------------------	// Getting Attributes.	//------------------------------------		public static function get session():UIDraggingSession{		return m_session;	}	public static function get location():Point{		return m_location;	}	}