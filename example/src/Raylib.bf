using System;
using System.Diagnostics;
using static RaylibBeef.Raylib;
using static microui_Beef.microui;

namespace example;

static class ExampleRaylib
{
	static mu_Context* ctx = new .() ~ delete ctx;
	//static RaylibBeef.Font font;
	static String win_title = "My Window";


#if BF_PLATFORM_WASM
	[CLink, CallingConvention(.Stdcall)]
	private static extern void emscripten_set_main_loop(function void() func, int32 fps, int32 simulateInfinteLoop);

	[CLink, CallingConvention(.Stdcall)]
	private static extern int32 emscripten_set_main_loop_timing(int32 mode, int32 value);

	[CLink, CallingConvention(.Stdcall)]
	private static extern double emscripten_get_now();

	private static void EmscriptenMainLoop()
	{
		Render();
	}
#endif

	public static void Init()
	{
		mu_init(ctx);
		SetTargetFPS(60);
		SetConfigFlags(RaylibBeef.ConfigFlags.FlagMsaa4XHint);
		InitWindow(640, 480, scope $"microui-raylib-beef");
		SetWindowState(.FlagWindowResizable);

#if BF_PLATFORM_WASM
		emscripten_set_main_loop(=> EmscriptenMainLoop, 0, 1);
#else
		while (!WindowShouldClose())
		{
			Render();
		}
#endif
	}

	static void Render()
	{
		BeginDrawing();

		ClearBackground(BLACK);

		let mousePos = GetMousePosition();
		let mouseWheel = GetMouseWheelMoveV();

		ctx.text_width = (font, str, len) => 10;
		ctx.text_height = (font) => 10;

		mu_input_mousemove(ctx, (.)mousePos.x, (.)mousePos.y);

		mu_input_scroll(ctx, (.)GetMouseWheelMoveV().x, (.)GetMouseWheelMoveV().x);

		if (IsMouseButtonPressed(.MouseButtonLeft))
		{
			mu_input_mousedown(ctx, (.)mousePos.x, (.)mousePos.y, (.)mu_mouse_button.MU_MOUSE_LEFT);
		}
		if (IsMouseButtonUp(.MouseButtonLeft))
		{
			mu_input_mouseup(ctx, (.)mousePos.x, (.)mousePos.y, (.)mu_mouse_button.MU_MOUSE_LEFT);
		}

		mu_begin(ctx);

		if (mu_begin_window_ex(ctx, "Style Editor", mu_rect(10, 10, 140, 86), 0) != 0)
		{
			if (mu_button_ex(ctx, "Button1", 0, (.)mu_option.MU_OPT_ALIGNCENTER) != 0)
			{
				Debug.WriteLine("Button1 pressed\n");
			}

			mu_end_window(ctx);
		}

		mu_end(ctx);

		mu_Command* cmd = null;

		while (mu_next_command(ctx, &cmd) != 0)
		{
			switch ((mu_command)cmd.type) {
			case .MU_COMMAND_TEXT:
				let sv = StringView(&cmd.text.str, cmd.base_cmd.size - sizeof(microui_Beef.microui.mu_TextCommand));
				let pos = cmd.text.pos;
				let color = cmd.text.color;

				DrawText(sv.Ptr, pos.x, pos.y, 12, .(color.r, color.g, color.b, color.a));
				break;
			case .MU_COMMAND_RECT:
				let r = cmd.rect.rect;
				let c = cmd.rect.color;
				DrawRectangle(r.x, r.y, r.w, r.h, RaylibBeef.Color(c.r, c.g, c.b, c.a));
				break;
			case .MU_COMMAND_ICON:
				break;
			case .MU_COMMAND_CLIP:
				break;
			default:

			}
		}

		EndDrawing();
	}
}