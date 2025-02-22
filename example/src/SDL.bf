/*using System;
using System.Interop;
using System.Diagnostics;
using System.IO;
using System.Collections;
using SDL2;
using static microui_Beef.microui;

namespace example;


static
{
	public static GameApp gGameApp;
}

class GameApp : SDLApp
{
	public this()
	{
		gGameApp = this;
	}

	public static int text_width(mu_Font font, char8* text, int len)
	{
		return 1;
	}

	public static int text_height(mu_Font font)
	{
		return 1;
	}

	public static void Update()
	{
		var ctx = scope mu_Context();

		mu_init(ctx);

		ctx.text_width = (font, str, len) => 1;
		ctx.text_height = (font) => 1;

		mu_begin(ctx);

		if (mu_begin_window_ex(ctx, "My Window".Ptr, mu_rect(10, 10, 140, 86), 0) != 0)
		{
			int32[2] row = .(60, -1);

			/*mu_layout_row(ctx, 2, &row, 0);

			mu_label(ctx, "First:");
			if (mu_button_ex(ctx, "Button1", 0, (.)mu_option.MU_OPT_ALIGNCENTER) != 0)
			{
				Debug.WriteLine("Button1 pressed\n");
			}

			mu_label(ctx, "Second:");
			if (mu_button_ex(ctx, "Button2", 0, (.)mu_option.MU_OPT_ALIGNCENTER) != 0)
			{
				mu_open_popup(ctx, "My Popup");
			}

			if (mu_begin_popup(ctx, "My Popup") != 0)
			{
				mu_label(ctx, "Hello world!");
				mu_end_popup(ctx);
			}*/

			mu_end_window(ctx);
		}

		mu_end(ctx);
	}

	public void Run()
	{
		while (RunOneFrame()) { }
	}

	private bool RunOneFrame()
	{
		int32 waitTime = 1;
		SDL.Event event;

		while (SDL.PollEvent(out event) != 0)
		{
			switch (event.type)
			{
			case .Quit:
				return false;
			case .KeyDown:
				if (event.key.keysym.scancode == .Escape)
					return false;

				KeyDown(event.key);
			case .KeyUp:
				KeyUp(event.key);
			case .MouseButtonDown:
				MouseDown(event.button);
			case .MouseButtonUp:
				MouseUp(event.button);
			default:
			}

			HandleEvent(event);

			waitTime = 0;
		}

		Update();

		return true;
	}
}


class Program
{
	public static int Main(String[] args)
	{
		let gameApp = scope GameApp();
		gameApp.Init();
		gameApp.Run();

		return 0;
	}
}*/