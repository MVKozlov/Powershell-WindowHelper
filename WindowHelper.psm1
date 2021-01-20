Set-StrictMode -version 2.0

$definition = @'
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
namespace Utils {
	public enum WindowShowStyle : int
	{
		/// <summary>
		/// Hides the window and activates another window.
		/// </summary>
		Hide = 0,
		/// <summary>
		/// Activates and displays a window. If the window is minimized or 
		/// maximized, the system restores it to its original size and position.
		/// An application should specify this flag when displaying the window 
		/// for the first time.
		/// </summary>
		Normal = 1,
		/// <summary>
		/// Activates the window and displays it as a minimized window.
		/// </summary>
		ShowMinimized = 2,
		/// <summary>
		/// Maximizes the specified window.
		/// </summary>
		Maximize = 3, // is this the right value?
		/// <summary>
		/// Activates the window and displays it as a maximized window.
		/// </summary>       
		ShowMaximized = 3,
		/// <summary>
		/// Displays a window in its most recent size and position. This value 
		/// is similar to <see cref="Win32.WindowShowStyle.Normal"/>, except 
		/// the window is not actived.
		/// </summary>
		ShowNoActivate = 4,
		/// <summary>
		/// Activates the window and displays it in its current size and position. 
		/// </summary>
		Show = 5,
		/// <summary>
		/// Minimizes the specified window and activates the next top-level 
		/// window in the Z order.
		/// </summary>
		Minimize = 6,
		/// <summary>
		/// Displays the window as a minimized window. This value is similar to
		/// <see cref="Win32.WindowShowStyle.ShowMinimized"/>, except the 
		/// window is not activated.
		/// </summary>
		ShowMinNoActive = 7,
		/// <summary>
		/// Displays the window in its current size and position. This value is 
		/// similar to <see cref="Win32.WindowShowStyle.Show"/>, except the 
		/// window is not activated.
		/// </summary>
		ShowNA = 8,
		/// <summary>
		/// Activates and displays the window. If the window is minimized or 
		/// maximized, the system restores it to its original size and position. 
		/// An application should specify this flag when restoring a minimized window.
		/// </summary>
		Restore = 9,
		/// <summary>
		/// Sets the show state based on the SW_* value specified in the 
		/// STARTUPINFO structure passed to the CreateProcess function by the 
		/// program that started the application.
		/// </summary>
		ShowDefault = 10,
		/// <summary>
		///  <b>Windows 2000/XP:</b> Minimizes a window, even if the thread 
		/// that owns the window is not responding. This flag should only be 
		/// used when minimizing windows from a different thread.
		/// </summary>
		ForceMinimize = 11
	}
	public enum GetWindowCommand : int
	{
		GW_HWNDFIRST = 0,
		GW_HWNDLAST = 1,
		GW_HWNDNEXT = 2,
		GW_HWNDPREV = 3,
		GW_OWNER = 4,
		GW_CHILD = 5,
		GW_ENABLEDPOPUP = 6
	}

	[Flags()]
	public enum SetWindowPosFlags : uint
	{
		/// <summary>If the calling thread and the thread that owns the window are attached to different input queues, 
		/// the system posts the request to the thread that owns the window. This prevents the calling thread from 
		/// blocking its execution while other threads process the request.</summary>
		/// <remarks>SWP_ASYNCWINDOWPOS</remarks>
		AsynchronousWindowPosition = 0x4000,
		/// <summary>Prevents generation of the WM_SYNCPAINT message.</summary>
		/// <remarks>SWP_DEFERERASE</remarks>
		DeferErase = 0x2000,
		/// <summary>Draws a frame (defined in the window's class description) around the window.</summary>
		/// <remarks>SWP_DRAWFRAME</remarks>
		DrawFrame = 0x0020,
		/// <summary>Applies new frame styles set using the SetWindowLong function. Sends a WM_NCCALCSIZE message to 
		/// the window, even if the window's size is not being changed. If this flag is not specified, WM_NCCALCSIZE 
		/// is sent only when the window's size is being changed.</summary>
		/// <remarks>SWP_FRAMECHANGED</remarks>
		FrameChanged = 0x0020,
		/// <summary>Hides the window.</summary>
		/// <remarks>SWP_HIDEWINDOW</remarks>
		HideWindow = 0x0080,
		/// <summary>Does not activate the window. If this flag is not set, the window is activated and moved to the 
		/// top of either the topmost or non-topmost group (depending on the setting of the hWndInsertAfter 
		/// parameter).</summary>
		/// <remarks>SWP_NOACTIVATE</remarks>
		DoNotActivate = 0x0010,
		/// <summary>Discards the entire contents of the client area. If this flag is not specified, the valid 
		/// contents of the client area are saved and copied back into the client area after the window is sized or 
		/// repositioned.</summary>
		/// <remarks>SWP_NOCOPYBITS</remarks>
		DoNotCopyBits = 0x0100,
		/// <summary>Retains the current position (ignores X and Y parameters).</summary>
		/// <remarks>SWP_NOMOVE</remarks>
		IgnoreMove = 0x0002,
		/// <summary>Does not change the owner window's position in the Z order.</summary>
		/// <remarks>SWP_NOOWNERZORDER</remarks>
		DoNotChangeOwnerZOrder = 0x0200,
		/// <summary>Does not redraw changes. If this flag is set, no repainting of any kind occurs. This applies to 
		/// the client area, the nonclient area (including the title bar and scroll bars), and any part of the parent 
		/// window uncovered as a result of the window being moved. When this flag is set, the application must 
		/// explicitly invalidate or redraw any parts of the window and parent window that need redrawing.</summary>
		/// <remarks>SWP_NOREDRAW</remarks>
		DoNotRedraw = 0x0008,
		/// <summary>Same as the SWP_NOOWNERZORDER flag.</summary>
		/// <remarks>SWP_NOREPOSITION</remarks>
		DoNotReposition = 0x0200,
		/// <summary>Prevents the window from receiving the WM_WINDOWPOSCHANGING message.</summary>
		/// <remarks>SWP_NOSENDCHANGING</remarks>
		DoNotSendChangingEvent = 0x0400,
		/// <summary>Retains the current size (ignores the cx and cy parameters).</summary>
		/// <remarks>SWP_NOSIZE</remarks>
		IgnoreResize = 0x0001,
		/// <summary>Retains the current Z order (ignores the hWndInsertAfter parameter).</summary>
		/// <remarks>SWP_NOZORDER</remarks>
		IgnoreZOrder = 0x0004,
		/// <summary>Displays the window.</summary>
		/// <remarks>SWP_SHOWWINDOW</remarks>
		ShowWindow = 0x0040,
	}

	[Flags]
	public enum MouseEventFlags : uint
	{
		LeftDown	= 0x00000002,
		LeftUp		= 0x00000004,
		MiddleDown	= 0x00000020,
		MiddleUp	= 0x00000040,
		Move		= 0x00000001,
		Absolute	= 0x00008000,
		RightDown	= 0x00000008,
		RightUp		= 0x00000010,
		Wheel		= 0x00000800,
		XDown		= 0x00000080,
		XUp			= 0x00000100
	}
	
	//Use the values of this enum for the 'dwData' parameter
	//to specify an X button when using MouseEventFlags.XDOWN or
	//MouseEventFlags.XUP for the dwFlags parameter.
	public enum MouseEventDataXButtons : uint
	{
		XButton1   = 0x00000001,
		XButton2   = 0x00000002
	}

	[StructLayout(LayoutKind.Sequential)]
	public struct RECT
	{
		public int Left;
		public int Top;
		public int Right;
		public int Bottom;
	}
	[StructLayout(LayoutKind.Sequential)]
	public struct Point
	{
		public int x;
		public int y;
	}

	[Serializable]
	[StructLayout(LayoutKind.Sequential)]
	public struct WINDOWPLACEMENT
	{
	    public int length;
	    public int flags;
		public WindowShowStyle showCmd;
		public Point ptMinPosition;
		public Point ptMaxPosition;
		public RECT rcNormalPosition;
	}

	public enum WindowLongFlags
	{
		GWL_EXSTYLE = -20,
		GWL_HINSTANCE = -6,
		GWL_HWNDPARENT = -8,
		GWL_ID = -12,
		GWL_STYLE = -16,
		GWL_USERDATA = -21,
		GWL_WNDPROC = -4,
		DWL_USER = 0x8,
		DWL_MSGRESULT = 0x0,
		DWL_DLGPROC = 0x4
	}

	/// <summary>
	/// Window Styles.
	/// The following styles can be specified wherever a window style is required. After the control has been created, these styles cannot be modified, except as noted.
	/// </summary>
	[Flags()]
	public enum WindowStyles : uint
	{
		/// <summary>The window has a thin-line border.</summary>
		WS_BORDER = 0x800000,

		/// <summary>The window has a title bar (includes the WS_BORDER style).</summary>
		WS_CAPTION = 0xc00000,

		/// <summary>The window is a child window. A window with this style cannot have a menu bar. This style cannot be used with the WS_POPUP style.</summary>
		WS_CHILD = 0x40000000,

		/// <summary>Excludes the area occupied by child windows when drawing occurs within the parent window. This style is used when creating the parent window.</summary>
		WS_CLIPCHILDREN = 0x2000000,

		/// <summary>
		/// Clips child windows relative to each other; that is, when a particular child window receives a WM_PAINT message, the WS_CLIPSIBLINGS style clips all other overlapping child windows out of the region of the child window to be updated.
		/// If WS_CLIPSIBLINGS is not specified and child windows overlap, it is possible, when drawing within the client area of a child window, to draw within the client area of a neighboring child window.
		/// </summary>
		WS_CLIPSIBLINGS = 0x4000000,

		/// <summary>The window is initially disabled. A disabled window cannot receive input from the user. To change this after a window has been created, use the EnableWindow function.</summary>
		WS_DISABLED = 0x8000000,

		/// <summary>The window has a border of a style typically used with dialog boxes. A window with this style cannot have a title bar.</summary>
		WS_DLGFRAME = 0x400000,

		/// <summary>
		/// The window is the first control of a group of controls. The group consists of this first control and all controls defined after it, up to the next control with the WS_GROUP style.
		/// The first control in each group usually has the WS_TABSTOP style so that the user can move from group to group. The user can subsequently change the keyboard focus from one control in the group to the next control in the group by using the direction keys.
		/// You can turn this style on and off to change dialog box navigation. To change this style after a window has been created, use the SetWindowLong function.
		/// </summary>
		WS_GROUP = 0x20000,

		/// <summary>The window has a horizontal scroll bar.</summary>
		WS_HSCROLL = 0x100000,

		/// <summary>The window is initially maximized.</summary> 
		WS_MAXIMIZE = 0x1000000,

		/// <summary>The window has a maximize button. Cannot be combined with the WS_EX_CONTEXTHELP style. The WS_SYSMENU style must also be specified.</summary> 
		WS_MAXIMIZEBOX = 0x10000,

		/// <summary>The window is initially minimized.</summary>
		WS_MINIMIZE = 0x20000000,

		/// <summary>The window has a minimize button. Cannot be combined with the WS_EX_CONTEXTHELP style. The WS_SYSMENU style must also be specified.</summary>
		WS_MINIMIZEBOX = 0x20000,

		/// <summary>The window is an overlapped window. An overlapped window has a title bar and a border.</summary>
		WS_OVERLAPPED = 0x0,

		/// <summary>The window is an overlapped window.</summary>
		WS_OVERLAPPEDWINDOW = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_SIZEFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX,

		/// <summary>The window is a pop-up window. This style cannot be used with the WS_CHILD style.</summary>
		WS_POPUP = 0x80000000u,

		/// <summary>The window is a pop-up window. The WS_CAPTION and WS_POPUPWINDOW styles must be combined to make the window menu visible.</summary>
		WS_POPUPWINDOW = WS_POPUP | WS_BORDER | WS_SYSMENU,

		/// <summary>The window has a sizing border.</summary>
		WS_SIZEFRAME = 0x40000,

		/// <summary>The window has a window menu on its title bar. The WS_CAPTION style must also be specified.</summary>
		WS_SYSMENU = 0x80000,

		/// <summary>
		/// The window is a control that can receive the keyboard focus when the user presses the TAB key.
		/// Pressing the TAB key changes the keyboard focus to the next control with the WS_TABSTOP style.  
		/// You can turn this style on and off to change dialog box navigation. To change this style after a window has been created, use the SetWindowLong function.
		/// For user-created windows and modeless dialogs to work with tab stops, alter the message loop to call the IsDialogMessage function.
		/// </summary>
		WS_TABSTOP = 0x10000,

		/// <summary>The window is initially visible. This style can be turned on and off by using the ShowWindow or SetWindowPos function.</summary>
		WS_VISIBLE = 0x10000000,

		/// <summary>The window has a vertical scroll bar.</summary>
		WS_VSCROLL = 0x200000
	}

	[Flags]
	public enum WindowStylesEx : uint
	{
		/// <summary>Specifies a window that accepts drag-drop files.</summary>
		WS_EX_ACCEPTFILES = 0x00000010,

		/// <summary>Forces a top-level window onto the taskbar when the window is visible.</summary>
		WS_EX_APPWINDOW = 0x00040000,

		/// <summary>Specifies a window that has a border with a sunken edge.</summary>
		WS_EX_CLIENTEDGE = 0x00000200,

		/// <summary>
		/// Specifies a window that paints all descendants in bottom-to-top painting order using double-buffering.
		/// This cannot be used if the window has a class style of either CS_OWNDC or CS_CLASSDC. This style is not supported in Windows 2000.
		/// </summary>
		/// <remarks>
		/// With WS_EX_COMPOSITED set, all descendants of a window get bottom-to-top painting order using double-buffering.
		/// Bottom-to-top painting order allows a descendent window to have translucency (alpha) and transparency (color-key) effects,
		/// but only if the descendent window also has the WS_EX_TRANSPARENT bit set.
		/// Double-buffering allows the window and its descendents to be painted without flicker.
		/// </remarks>
		WS_EX_COMPOSITED = 0x02000000,

		/// <summary>
		/// Specifies a window that includes a question mark in the title bar. When the user clicks the question mark,
		/// the cursor changes to a question mark with a pointer. If the user then clicks a child window, the child receives a WM_HELP message.
		/// The child window should pass the message to the parent window procedure, which should call the WinHelp function using the HELP_WM_HELP command.
		/// The Help application displays a pop-up window that typically contains help for the child window.
		/// WS_EX_CONTEXTHELP cannot be used with the WS_MAXIMIZEBOX or WS_MINIMIZEBOX styles.
		/// </summary>
		WS_EX_CONTEXTHELP = 0x00000400,

		/// <summary>
		/// Specifies a window which contains child windows that should take part in dialog box navigation.
		/// If this style is specified, the dialog manager recurses into children of this window when performing navigation operations
		/// such as handling the TAB key, an arrow key, or a keyboard mnemonic.
		/// </summary>
		WS_EX_CONTROLPARENT = 0x00010000,

		/// <summary>Specifies a window that has a double border.</summary>
		WS_EX_DLGMODALFRAME = 0x00000001,

		/// <summary>
		/// Specifies a window that is a layered window.
		/// This cannot be used for child windows or if the window has a class style of either CS_OWNDC or CS_CLASSDC.
		/// </summary>
		WS_EX_LAYERED = 0x00080000,

		/// <summary>
		/// Specifies a window with the horizontal origin on the right edge. Increasing horizontal values advance to the left.
		/// The shell language must support reading-order alignment for this to take effect.
		/// </summary>
		WS_EX_LAYOUTRTL = 0x00400000,

		/// <summary>Specifies a window that has generic left-aligned properties. This is the default.</summary>
		WS_EX_LEFT = 0x00000000,

		/// <summary>
		/// Specifies a window with the vertical scroll bar (if present) to the left of the client area.
		/// The shell language must support reading-order alignment for this to take effect.
		/// </summary>
		WS_EX_LEFTSCROLLBAR = 0x00004000,

		/// <summary>
		/// Specifies a window that displays text using left-to-right reading-order properties. This is the default.
		/// </summary>
		WS_EX_LTRREADING = 0x00000000,

		/// <summary>
		/// Specifies a multiple-document interface (MDI) child window.
		/// </summary>
		WS_EX_MDICHILD = 0x00000040,

		/// <summary>
		/// Specifies a top-level window created with this style does not become the foreground window when the user clicks it.
		/// The system does not bring this window to the foreground when the user minimizes or closes the foreground window.
		/// The window does not appear on the taskbar by default. To force the window to appear on the taskbar, use the WS_EX_APPWINDOW style.
		/// To activate the window, use the SetActiveWindow or SetForegroundWindow function.
		/// </summary>
		WS_EX_NOACTIVATE = 0x08000000,

		/// <summary>
		/// Specifies a window which does not pass its window layout to its child windows.
		/// </summary>
		WS_EX_NOINHERITLAYOUT = 0x00100000,

		/// <summary>
		/// Specifies that a child window created with this style does not send the WM_PARENTNOTIFY message to its parent window when it is created or destroyed.
		/// </summary>
		WS_EX_NOPARENTNOTIFY = 0x00000004,

		/// <summary>Specifies an overlapped window.</summary>
		WS_EX_OVERLAPPEDWINDOW = WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE,

		/// <summary>Specifies a palette window, which is a modeless dialog box that presents an array of commands.</summary>
		WS_EX_PALETTEWINDOW = WS_EX_WINDOWEDGE | WS_EX_TOOLWINDOW | WS_EX_TOPMOST,

		/// <summary>
		/// Specifies a window that has generic "right-aligned" properties. This depends on the window class.
		/// The shell language must support reading-order alignment for this to take effect.
		/// Using the WS_EX_RIGHT style has the same effect as using the SS_RIGHT (static), ES_RIGHT (edit), and BS_RIGHT/BS_RIGHTBUTTON (button) control styles.
		/// </summary>
		WS_EX_RIGHT = 0x00001000,

		/// <summary>Specifies a window with the vertical scroll bar (if present) to the right of the client area. This is the default.</summary>
		WS_EX_RIGHTSCROLLBAR = 0x00000000,

		/// <summary>
		/// Specifies a window that displays text using right-to-left reading-order properties.
		/// The shell language must support reading-order alignment for this to take effect.
		/// </summary>
		WS_EX_RTLREADING = 0x00002000,

		/// <summary>Specifies a window with a three-dimensional border style intended to be used for items that do not accept user input.</summary>
		WS_EX_STATICEDGE = 0x00020000,

		/// <summary>
		/// Specifies a window that is intended to be used as a floating toolbar.
		/// A tool window has a title bar that is shorter than a normal title bar, and the window title is drawn using a smaller font.
		/// A tool window does not appear in the taskbar or in the dialog that appears when the user presses ALT+TAB.
		/// If a tool window has a system menu, its icon is not displayed on the title bar.
		/// However, you can display the system menu by right-clicking or by typing ALT+SPACE. 
		/// </summary>
		WS_EX_TOOLWINDOW = 0x00000080,

		/// <summary>
		/// Specifies a window that should be placed above all non-topmost windows and should stay above them, even when the window is deactivated.
		/// To add or remove this style, use the SetWindowPos function.
		/// </summary>
		WS_EX_TOPMOST = 0x00000008,

		/// <summary>
		/// Specifies a window that should not be painted until siblings beneath the window (that were created by the same thread) have been painted.
		/// The window appears transparent because the bits of underlying sibling windows have already been painted.
		/// To achieve transparency without these restrictions, use the SetWindowRgn function.
		/// </summary>
		WS_EX_TRANSPARENT = 0x00000020,

		/// <summary>Specifies a window that has a border with a raised edge.</summary>
		WS_EX_WINDOWEDGE = 0x00000100
	}

	public delegate bool Win32Callback(IntPtr hwnd, IntPtr lParam);

	public class WindowHelper {
		[DllImport("user32.dll", SetLastError = true)]
		[return: MarshalAs(UnmanagedType.Bool)]
		public static extern bool ShowWindow(IntPtr hWnd, Utils.WindowShowStyle nCmdShow);

		// Places (posts) a message in the message queue associated with the thread that created the specified window and returns without waiting for the thread to process the message.
		// http://msdn.microsoft.com/en-us/library/ms644944(VS.85).aspx
		[return: MarshalAs(UnmanagedType.Bool)]
		[DllImport("user32.dll", SetLastError = true)]
		//public static extern bool PostMessage(HandleRef hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
		public static extern bool PostMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);

		// Determines which pop-up window owned by the specified window was most recently active. 
		// http://msdn.microsoft.com/en-us/library/ms633507(v=vs.85).aspx
		[DllImport("user32.dll")]
		public static extern IntPtr GetLastActivePopup(IntPtr hWnd);

		// a handle to a window that has the specified relationship (Z-Order or owner) to the specified window.
		// http://msdn.microsoft.com/en-us/library/ms633515(v=vs.85).aspx
		// GW_CHILD 5, GW_ENABLEDPOPUP 6, GW_HWNDFIRST 0, GW_HWNDLAST 1, GW_HWNDNEXT 2, GW_HWNDPREV 3, GW_OWNER 4
		[DllImport("user32", CharSet=CharSet.Auto, SetLastError=true, ExactSpelling=true)]
		public static extern IntPtr GetWindow(IntPtr hwnd, int wFlag);

		[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
		public static extern int GetWindowTextLength(IntPtr hWnd); 

		[DllImport("user32", CharSet=CharSet.Auto, SetLastError=true)]
		public static extern int GetWindowText(IntPtr hWnd, [Out, MarshalAs(UnmanagedType.LPTStr)] StringBuilder lpString, int nMaxCount);

		[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
		public static extern bool SetWindowText(IntPtr hwnd, String lpString);

		[DllImport("user32.dll")]
		[return: MarshalAs(UnmanagedType.Bool)]
		public static extern bool SetForegroundWindow(IntPtr hWnd);

		[DllImport("user32.dll")]
		public static extern IntPtr GetForegroundWindow();

		[DllImport("user32.dll", EntryPoint = "SetWindowPos")]
		public static extern bool SetWindowPos(
		      int hWnd,           // window handle
		      int hWndInsertAfter,    // placement-order handle
		      int X,          // horizontal position
		      int Y,          // vertical position
		      int cx,         // width
		      int cy,         // height
		      SetWindowPosFlags uFlags);       // window positioning flags
	  
		[DllImport("user32.dll")]
		[return: MarshalAs(UnmanagedType.Bool)]
		public static extern bool EnumChildWindows(IntPtr parentHandle, Win32Callback callback, IntPtr lParam);
		[DllImport("user32.dll")]
		[return: MarshalAs(UnmanagedType.Bool)]
		public static extern bool EnumThreadWindows(uint dwThreadId, Win32Callback callback, IntPtr lParam);
		[DllImport("user32.dll")]
        private static extern int EnumWindows(Win32Callback callPtr, IntPtr lParam);
		
        // When you don't want the ProcessId, use this overload and pass IntPtr.Zero for the second parameter
        [DllImport("user32.dll")]
		public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);

		public static uint[] GetWindowThreadProcessIdEx(IntPtr hWnd) {
			uint ProcessId = 0;
			uint ThreadId = GetWindowThreadProcessId(hWnd, out ProcessId);
			return new uint[]{ ProcessId, ThreadId };
		}

	    private static bool CollectWindowsProc(IntPtr handle, IntPtr pointer)
	    {
	        GCHandle gch = GCHandle.FromIntPtr(pointer);
	        List<IntPtr> list = gch.Target as List<IntPtr>;
	        if (list == null)
	            throw new InvalidCastException("GCHandle Target could not be cast as List<IntPtr>");

	        list.Add(handle);            
	        return true;
	    }
		public static List<IntPtr> GetChildWindows(IntPtr parent)
	    {
	        List<IntPtr> result = new List<IntPtr>();
	        GCHandle listHandle = GCHandle.Alloc(result);
	        try
	        {
				EnumChildWindows(parent, CollectWindowsProc, GCHandle.ToIntPtr(listHandle));
	        }
	        finally
	        {
	            if (listHandle.IsAllocated)
	                listHandle.Free();
	        }
	        return result;
    	}
		public static List<IntPtr> GetThreadWindows(uint dwThreadId)
	    {
	        List<IntPtr> result = new List<IntPtr>();
	        GCHandle listHandle = GCHandle.Alloc(result);
	        try
	        {
				EnumThreadWindows(dwThreadId, CollectWindowsProc, GCHandle.ToIntPtr(listHandle));
	        }
	        finally
	        {
	            if (listHandle.IsAllocated)
	                listHandle.Free();
	        }
	        return result;
    	}

		private static IntPtr mainProcessHwnd = IntPtr.Zero;
		private static bool FindWindowOfProcess(IntPtr hwnd, IntPtr lParam)
		{
			uint ProcessID = 0;
			uint ThreadID = GetWindowThreadProcessId(hwnd, out ProcessID);
			if (ProcessID == (uint)lParam)
			{
				mainProcessHwnd = hwnd;
				return false;
			}
			return true;
		}
		public static IEnumerable<long> FindMainProcessesWindows(string processName) {
			System.Diagnostics.Process[] Processes = System.Diagnostics.Process.GetProcessesByName(processName);
			foreach (System.Diagnostics.Process p in Processes)
			{
				mainProcessHwnd = IntPtr.Zero;
				if (p.MainWindowHandle != IntPtr.Zero) mainProcessHwnd = p.MainWindowHandle;
				else EnumWindows(FindWindowOfProcess, (IntPtr)(long)p.Id);
				yield return (long)mainProcessHwnd;
			}
		}
		public static long FindMainProcessWindow(int ProcessID) {
			System.Diagnostics.Process p = System.Diagnostics.Process.GetProcessById(ProcessID);
			mainProcessHwnd = IntPtr.Zero;
			if (p.MainWindowHandle != IntPtr.Zero) mainProcessHwnd = p.MainWindowHandle;
			else EnumWindows(FindWindowOfProcess, (IntPtr)(long)p.Id);
			return (long)mainProcessHwnd;
		}

		[DllImport("kernel32")]
		public static extern int FormatMessage (
			int dwFlags, 
			IntPtr lpSource, 
			int dwMessageId, 
			int dwLanguageId, 
			string lpBuffer,
			uint nSize, 
			int argumentsLong);

		[DllImport("kernel32")]
		public extern static int GetLastError();

		[DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
		public static extern void mouse_event(uint dwFlags, int dx, int dy, uint cButtons, uint dwExtraInfo);
                //  http://msdn.microsoft.com/en-us/library/windows/desktop/ms646260(v=vs.85).aspx

		[DllImport("user32.dll", SetLastError = true)]
		[return: MarshalAs(UnmanagedType.Bool)]
		public static extern bool GetWindowRect(IntPtr hWnd, ref RECT lpRect);

		[DllImport("user32.dll", SetLastError = true)]
		[return: MarshalAs(UnmanagedType.Bool)]
		public static extern bool GetWindowPlacement(
			IntPtr hWnd, ref WINDOWPLACEMENT lpwndpl);

		[DllImport("user32.dll")]
		[return: MarshalAs(UnmanagedType.Bool)]
		public static extern bool IsIconic(IntPtr hWnd);

		[DllImport("user32.dll")]
		[return: MarshalAs(UnmanagedType.Bool)]
		public static extern bool IsZoomed(IntPtr hWnd);

		[DllImport("user32.dll", EntryPoint="GetWindowLong")]
		private static extern IntPtr GetWindowLongPtr32(IntPtr hWnd, int nIndex);

		[DllImport("user32.dll", EntryPoint="GetWindowLongPtr")]
		private static extern IntPtr GetWindowLongPtr64(IntPtr hWnd, int nIndex);

		// This static method is required because Win32 does not support
		// GetWindowLongPtr directly
		public static IntPtr GetWindowLongPtr(IntPtr hWnd, int nIndex)
		{
			if (IntPtr.Size == 8)
				return GetWindowLongPtr64(hWnd, nIndex);
			else
				return GetWindowLongPtr32(hWnd, nIndex);
		}
	}
}
'@

$type = Add-Type -TypeDefinition $definition -PassThru

function Get-WindowInfo {
	Param(
		[Alias('hWnd', 'MainWindowHandle')]
		[Parameter(Mandatory=$false, ValueFromPipeline=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
		[int]$Handle=0
	)
	BEGIN {
		$sb = new-object system.text.stringbuilder
	}
	PROCESS {
		$ids = [Utils.WindowHelper]::GetWindowThreadProcessIdEx($Handle);
		$sb.Length = 0
		$len = [Utils.WindowHelper]::GetWindowTextLength($Handle)
		if ($len) {
			$sb.Length = if ($len -ge 128) { 128 } else { $len + 1 }
			$len = [Utils.WindowHelper]::GetWindowText($Handle, $sb, $sb.Length)
		}
	    '' | Select-Object @{n='Handle'; e={$Handle}},
				@{n='ProcessId';e={$ids[0]}},
				@{n='ThreadId';e={$ids[1]}},
				@{n='Text'; e={$sb.tostring()}}
	}
}
function Get-ThreadWindows {
	Param(
		[Alias('hWnd', 'MainWindowHandle')]
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
		[int]$ThreadId
	)
	PROCESS{
		[Utils.WindowHelper]::GetThreadWindows($ThreadId) | Get-WindowInfo
	}
}
function Get-ChildWindows {
	Param(
		[Alias('hWnd', 'MainWindowHandle')]
		[Parameter(Mandatory=$false, ValueFromPipeline=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
		[int]$Handle=0
	)
	PROCESS{
		[Utils.WindowHelper]::GetChildWindows($Handle) | Get-WindowInfo
	}
}

function Get-WindowText {
	Param(
		[Alias('hWnd', 'MainWindowHandle')]
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
		[int]$Handle
	)
	PROCESS {
		$sb = new-object system.text.stringbuilder
		$len = [Utils.WindowHelper]::GetWindowTextLength($Handle)
		if ($len) {
			$sb.Length = if ($len -ge 128) { 128 } else { $len + 1 }
			$len = [Utils.WindowHelper]::GetWindowText($Handle, $sb, $sb.Length)
			#Write-Host (" >$h: "+$sb.tostring())
		}
        $sb.ToString()
	}
}

function Set-WindowText {
	Param(
		[Alias('hWnd', 'MainWindowHandle')]
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
		[int]$Handle,
		[Parameter(Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
		[string]$Text
	)
	PROCESS {
		[Utils.WindowHelper]::SetWindowText($Handle,$Text)
	}
}

function Set-ForegroundWindow {
	Param(
		[Alias('hWnd', 'MainWindowHandle')]
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
		[int]$Handle
	)
	PROCESS {
		[Utils.WindowHelper]::SetForegroundWindow($Handle)
	}
}
function Get-ForegroundWindow {
	[Utils.WindowHelper]::GetForegroundWindow()
}

function Get-LastActivePopup {
	Param(
		[Alias('hWnd', 'MainWindowHandle')]
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
		[int]$Handle
	)
	PROCESS {
		[Utils.WindowHelper]::GetLastActivePopup($Handle)
	}
}

function Send-WindowMessage {
	Param(
		[Alias('hWnd', 'MainWindowHandle')]
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
		[int]$Handle,
		[Parameter(Mandatory=$true, ValueFromPipeline=$false, Position=1)]
		[uint32]$Msg,
		[Parameter(Mandatory=$true, ValueFromPipeline=$false, Position=2)]
		[System.IntPtr]$wParam,
		[Parameter(Mandatory=$true, ValueFromPipeline=$false, Position=3)]
		[System.IntPtr]$lParam
	)
	PROCESS {
		[Utils.WindowHelper]::PostMessage($Handle, $Msg, $wParam, $lParam)
	}
}

function Send-CloseWindowMessage {
	Param(
		[Alias('hWnd', 'MainWindowHandle')]
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
		[int]$Handle
	)
	PROCESS {
		[Utils.WindowHelper]::PostMessage($Handle, 0x113, 1, 0)
	}
}

function Get-Window {
	Param(
		[Alias('hWnd', 'MainWindowHandle')]
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
		[int]$Handle,
		[Alias('GetWindowCommandFlag')]
		[Parameter(Mandatory=$true, ValueFromPipeline=$false, Position=1)]
		[Utils.GetWindowCommand]$wFlag
	)
	PROCESS {
		[Utils.WindowHelper]::GetWindow($Handle, $wFlag)
	}
}

function Get-MainWindow {
	[CmdletBinding(DefaultParameterSetName='ID')]
	Param(
		[Parameter(Mandatory=$true, Position=0,
				ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true,
				ParameterSetName='ID')]
		[int]$Id,
		[Parameter(Mandatory=$true, Position=0,
				ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true,
				ParameterSetName='Name')]
		[string]$Name
	)
	PROCESS {
		if ($Id) {
			$hWnd = [Utils.WindowHelper]::FindMainProcessWindow($Id)
		}
		elseif ($Name) {
			$hWnd = [Utils.WindowHelper]::FindMainProcessesWindows($Name)
		}
		$hWnd | Where-Object { $_ -ne 0 }
	}
}

function Show-Window {
	Param(
		[Alias('hWnd', 'MainWindowHandle')]
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
		[int]$Handle,
		[Alias('ShowStyle', 'Style')]
		[Parameter(Mandatory=$true, ValueFromPipeline=$false, Position=1)]
		[Utils.WindowShowStyle]$WindowShowStyle
	)
	PROCESS {
		#[Utils.WindowHelper]::ShowWindow($Handle, 10)
		[Utils.WindowHelper]::ShowWindow($Handle, $WindowShowStyle)
	}
}

function Get-WindowRect {
	param(
		[Alias('hWnd', 'MainWindowHandle')]
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
		[int]$Handle
	)
	PROCESS {
		$rect = New-Object Utils.RECT
		[void][Utils.WindowHelper]::GetWindowRect($Handle, [ref]$rect)
        '' | Select-Object @{n='Handle'; e={$Handle}},
							@{n='Left'; e={$rect.Left}}, @{n='Top'; e={$rect.Top}},
							@{n='Right'; e={$rect.Right}}, @{n='Bottom'; e={$rect.Bottom}}
	}
}

function Get-WindowPlacement {
	param(
		[Alias('hWnd', 'MainWindowHandle')]
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
		[int]$Handle
	)
	PROCESS {
		$placement = New-Object Utils.WINDOWPLACEMENT
		[void][Utils.WindowHelper]::GetWindowPlacement($Handle, [ref]$placement)
		$placement
	}
}
function Get-WindowStyle {
	param(
		[Alias('hWnd', 'MainWindowHandle')]
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
		[int]$Handle,
		[switch]$Extended
	)
	PROCESS {
		if ($Extended) {
			[Utils.WindowStylesEx][int64][Utils.WindowHelper]::GetWindowLongPtr($Handle, [Utils.WindowLongFlags]::GWL_EXSTYLE)
		}
		else {
			[Utils.WindowStyles][int64][Utils.WindowHelper]::GetWindowLongPtr($Handle, [Utils.WindowLongFlags]::GWL_STYLE)
		}
	}
}

function Get-WindowParent {
	param(
		[Alias('hWnd', 'MainWindowHandle')]
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
		[int]$Handle
	)
	PROCESS {
		[Utils.WindowHelper]::GetWindowLongPtr($Handle, [Utils.WindowLongFlags]::GWL_HWNDPARENT)
	}
}

function Invoke-MouseEvent {
[CmdletBinding(DefaultParameterSetName='Full')]
param(
	[Parameter(Mandatory=$true, Position=0, ParameterSetName='Full')]
	[Utils.MouseEventFlags]$Event,
	[int]$X = 0,
	[int]$Y = 0,
	[Parameter(ParameterSetName='Full')]
	[UInt32]$Data = 0,
	[Parameter(ParameterSetName='Full')]
	[UInt32]$ExtraInfo = 0,
	[Parameter(Mandatory=$true, Position=0, ParameterSetName='Click')]
	[ValidateSet('LeftDown','LeftUp','RightDown','RightUp','MiddleDown','MiddleUp')]
	[string]$Button,
	[Parameter(ParameterSetName='Click')]
	[switch]$AbsoluteCoordinates
)
	if ($PSCmdlet.ParameterSetName -eq 'Full') {
		[Utils.WindowHelper]::mouse_event($Event,$X,$Y,$Data,$ExtraInfo)
	}
	else {
		$Event = [Utils.MouseEventFlags]$Button
		if ($X -ne 0 -or $Y -ne 0) { $Event |= [UInt32]([Utils.MouseEventFlags]::Move) }
		if ($AbsoluteCoordinates) { $Event |= [UInt32]([Utils.MouseEventFlags]::Absolute) }
		[Utils.WindowHelper]::mouse_event($Event,$X,$Y,0,0)
	}
}

Export-ModuleMember -Function Get-WindowInfo, Get-ThreadWindows, Get-ChildWindows,
			Get-Window, Get-MainWindow, Get-WindowText, Set-WindowText,
			Get-ForegroundWindow, Set-ForegroundWindow,  Show-Window,  Get-LastActivePopup,
			Send-WindowMessage, Send-CloseWindowMessage,
			Get-WindowRect, Get-WindowPlacement, Get-WindowStyle, Get-WindowParent,
			Invoke-MouseEvent
