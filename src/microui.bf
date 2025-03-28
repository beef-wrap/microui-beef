using System;
using System.Interop;

namespace microui_Beef;

// /* callbacks */
//   8 + // int (*text_width)(mu_Font font, const char *str, int len);
//   8 + // int (*text_height)(mu_Font font); // 8 | 16
//   8 + //void (*draw_frame)(mu_Context *ctx, mu_Rect rect, int colorid); // 8 | 24
//   /* core state */
//   96 + //mu_Style _style; // 96 | 120
//   8 + // mu_Style *style; // 8 | 128
//   4 + // mu_Id hover; // 4 | 132
//   4 + // mu_Id focus; // 4 | 136
//   4 + // mu_Id last_id; // 4 | 140
//   16 + // mu_Rect last_rect; // 16 | 156
//   4 + // int last_zindex; // 4 | 160
//   4 + // int updated_focus; // 4 | 164
//   4 + // int frame; // 4 | 168
//   8 + // mu_Container *hover_root; // 8 | 176
//   8 + // mu_Container *next_hover_root; // 8 | 184
//   8 + // mu_Container *scroll_target; //8 | 192
//   4 + // mu_Id number_edit; // 4 | 196 
//   8 + // mu_Vec2 mouse_pos; // 8 | 204
//   8 + // mu_Vec2 last_mouse_pos; // 8 | 212
//   8 + // mu_Vec2 mouse_delta; // 8 | 220
//   8 + // mu_Vec2 scroll_delta; // 8 | 228
//   4 + // int mouse_down; // 4 | 232
//   4 + // int mouse_pressed; // 4 | 236
//   4 + // int key_down; // 4 | 240
//   4 + // int key_pressed; // 4 | 244

  
//   /* stacks */
//   4 + (256 * 1024) + //mu_stack(char, MU_COMMANDLIST_SIZE) command_list; // 4 + 256 * 1024 = 262,148
//   4 + (32 * 8) + // mu_stack(mu_Container*, MU_ROOTLIST_SIZE) root_list; // 4 + 32 * 8 = 260
//   4 + (32 * 8) + // mu_stack(mu_Container*, MU_CONTAINERSTACK_SIZE) container_stack; // 4 + 32 * 8 = 260
//   4 + (32 * 16) + // mu_stack(mu_Rect, MU_CLIPSTACK_SIZE) clip_stack; // 4 + 32 * 16 = 516
//   4 + (32 * 4) + // mu_stack(mu_Id, MU_IDSTACK_SIZE) id_stack; // 4 + 32 * 4 = 132
//   4 + (16 * 140) + // mu_stack(mu_Layout, MU_LAYOUTSTACK_SIZE) layout_stack; // 4 + 16 * 140 = 2,244
//   /* retained state pools */
//   4 + (48 * 8) + // mu_PoolItem container_pool[MU_CONTAINERPOOL_SIZE]; // 48 * 8 = 384
//   4 + (48 * 72) + // mu_Container containers[MU_CONTAINERPOOL_SIZE]; // 48 * 72 = 3,456
//   4 + (48 * 8) + // mu_PoolItem treenode_pool[MU_TREENODEPOOL_SIZE]; // 48 * 8 = 384
//   /* input state */
//   32 + //char input_text[32]; // 32
//   127 // char number_edit_buf[MU_MAX_FMT]; //127

public static class microui
{
	typealias char = c_char;
	
	const char* MU_VERSION 				= "2.02";

	const c_int MU_COMMANDLIST_SIZE     = (256 * 1024);
	const c_int MU_ROOTLIST_SIZE        = 32;
	const c_int MU_CONTAINERSTACK_SIZE  = 32;
	const c_int MU_CLIPSTACK_SIZE       = 32;
	const c_int MU_IDSTACK_SIZE         = 32;
	const c_int MU_LAYOUTSTACK_SIZE     = 16;
	const c_int MU_CONTAINERPOOL_SIZE   = 48;
	const c_int MU_TREENODEPOOL_SIZE    = 48;
	const c_int MU_MAX_WIDTHS           = 16;
	const char* MU_REAL_FMT           	= "%.3g";
	const char* MU_SLIDER_FMT         	= "%.2f";
	const c_int MU_MAX_FMT              = 127;

	public typealias mu_Id = c_uint;
	public typealias mu_Real = float;
	public typealias mu_Font = void*;

	public enum mu_clip : c_int
	{
		MU_CLIP_PART = 1,
		MU_CLIP_ALL
	}

	public enum mu_command : c_int
	{
		MU_COMMAND_JUMP = 1,
		MU_COMMAND_CLIP,
		MU_COMMAND_RECT,
		MU_COMMAND_TEXT,
		MU_COMMAND_ICON,
		MU_COMMAND_MAX
	}

	public enum mu_color : c_int
	{
		MU_COLOR_TEXT,
		MU_COLOR_BORDER,
		MU_COLOR_WINDOWBG,
		MU_COLOR_TITLEBG,
		MU_COLOR_TITLETEXT,
		MU_COLOR_PANELBG,
		MU_COLOR_BUTTON,
		MU_COLOR_BUTTONHOVER,
		MU_COLOR_BUTTONFOCUS,
		MU_COLOR_BASE,
		MU_COLOR_BASEHOVER,
		MU_COLOR_BASEFOCUS,
		MU_COLOR_SCROLLBASE,
		MU_COLOR_SCROLLTHUMB,
		MU_COLOR_MAX
	}

	//const int MU_COLOR_MAX = (.)mu_color.MU_COLOR_SCROLLTHUMB + 1;

	public enum mu_icon : c_int
	{
		MU_ICON_CLOSE = 1,
		MU_ICON_CHECK,
		MU_ICON_COLLAPSED,
		MU_ICON_EXPANDED,
		MU_ICON_MAX
	}

	public enum mu_result : c_int
	{
		MU_RES_ACTIVE       = 0,
		MU_RES_SUBMIT       = 1,
		MU_RES_CHANGE       = _ * 2
	}

	public enum mu_option : c_int
	{
		MU_OPT_ALIGNCENTER  = 1,
		MU_OPT_ALIGNRIGHT   = _ * 2,
		MU_OPT_NOINTERACT   = _ * 2,
		MU_OPT_NOFRAME      = _ * 2,
		MU_OPT_NORESIZE     = _ * 2,
		MU_OPT_NOSCROLL     = _ * 2,
		MU_OPT_NOCLOSE      = _ * 2,
		MU_OPT_NOTITLE      = _ * 2,
		MU_OPT_HOLDFOCUS    = _ * 2,
		MU_OPT_AUTOSIZE     = _ * 2,
		MU_OPT_POPUP        = _ * 2,
		MU_OPT_CLOSED       = _ * 2,
		MU_OPT_EXPANDED     = _ * 2
	}

	public enum mu_mouse_button : c_int
	{
		MU_MOUSE_LEFT       = 1,
		MU_MOUSE_RIGHT      = _ * 2,
		MU_MOUSE_MIDDLE     = _ * 2
	}

	public enum mu_key_modifier : c_int
	{
		MU_KEY_SHIFT        = 1,
		MU_KEY_CTRL         = _ * 2,
		MU_KEY_ALT          = _ * 2,
		MU_KEY_BACKSPACE    = _ * 2,
		MU_KEY_RETURN       = _ * 2
	}

	[CRepr]
	public struct mu_Vec2
	{
		public c_int x, y;
	}

	[CRepr]
	public struct mu_Rect
	{
		public c_int x, y, w, h;
	}

	[CRepr]
	public struct mu_Color
	{
		public c_uchar r, g, b, a;
	}

	[CRepr]
	public struct mu_PoolItem
	{
		public mu_Id id;
		public c_int last_update;
	}

	[CRepr]
	public struct mu_BaseCommand
	{
		public c_int type, size;
	}

	[CRepr]
	public struct mu_JumpCommand
	{
		public mu_BaseCommand base_cmd;
		public void* dst;
	}

	[CRepr]
	public struct mu_ClipCommand
	{
		public mu_BaseCommand base_cmd;
		public mu_Rect rect;
	}

	[CRepr]
	public struct mu_RectCommand
	{
		public mu_BaseCommand base_cmd;
		public mu_Rect rect;
		public mu_Color color;
	}

	[CRepr]
	public struct mu_TextCommand
	{
		public mu_BaseCommand base_cmd;
		public void* font;
		public mu_Vec2 pos;
		public mu_Color color;
		public char[1] str;
	}

	[CRepr]
	public struct mu_IconCommand
	{
		public mu_BaseCommand base_cmd;
		public mu_Rect rect;
		public c_int id;
		public mu_Color color;
	}

	[CRepr, Union]
	public struct mu_Command
	{
		public c_int type;
		public mu_BaseCommand base_cmd;
		public mu_JumpCommand jump;
		public mu_ClipCommand clip;
		public mu_RectCommand rect;
		public mu_TextCommand text;
		public mu_IconCommand icon;
	}

	[CRepr]
	public struct mu_Layout
	{
		public mu_Rect body;
		public mu_Rect next;
		public mu_Vec2 position;
		public mu_Vec2 size;
		public mu_Vec2 max;
		public c_int[MU_MAX_WIDTHS] widths;
		public c_int items;
		public c_int item_index;
		public c_int next_row;
		public c_int next_type;
		public c_int indent;
	}

	[CRepr]
	public struct mu_Container
	{
		public mu_Command* head, tail;
		public mu_Rect rect;
		public mu_Rect body;
		public mu_Vec2 content_size;
		public mu_Vec2 scroll;
		public c_int zindex;
		public c_int open;
	}

	[CRepr]
	public struct mu_Style
	{
		public mu_Font font;
		public mu_Vec2 size;
		public c_int padding;
		public c_int spacing;
		public c_int indent;
		public c_int title_height;
		public c_int scrollbar_size;
		public c_int thumb_size;
		public mu_Color[(.)mu_color.MU_COLOR_MAX] colors;
	}
	
	[CRepr]
	public struct mu_Context
	{
		/* callbacks */
		public function c_int(mu_Font font, char* str, c_int len) text_width;
		public function c_int(mu_Font font) text_height;
		public function void(mu_Context* ctx, mu_Rect rect, c_int colorid) draw_frame;
		/* core state */
		public mu_Style _style;
		public mu_Style* style;
		public mu_Id hover;
		public mu_Id focus;
		public mu_Id last_id;
		public mu_Rect last_rect;
		public c_int last_zindex;
		public c_int updated_focus;
		public c_int frame;
		public mu_Container* hover_root;
		public mu_Container* next_hover_root;
		public mu_Container* scroll_target;
		public char8[MU_MAX_FMT] number_edit_buf;
		public mu_Id number_edit;
		/* stacks */
		public struct { c_int idx; char[MU_COMMANDLIST_SIZE] items; } command_list;
		public struct { c_int idx; mu_Container*[MU_ROOTLIST_SIZE] items;} root_list; // TODO figure out why sizeof(mu_Context) is off when mu_RootList/mu_Container are an inline anonymous structs. Something to do with ptrs? Interestingly only the last one affects this
		public struct { c_int idx; mu_Container*[MU_CONTAINERSTACK_SIZE] items;	} container_stack;
		public struct { c_int idx; mu_Rect[MU_CLIPSTACK_SIZE] items; } clip_stack;
		public struct { c_int idx; mu_Id[MU_IDSTACK_SIZE] items; } id_stack;
		public struct { c_int idx; mu_Layout[MU_LAYOUTSTACK_SIZE] items; } layout_stack;
		/* retained state pools */
		public mu_PoolItem[MU_CONTAINERPOOL_SIZE] container_pool;
		public mu_Container[MU_CONTAINERPOOL_SIZE] containers;
		public mu_PoolItem[MU_TREENODEPOOL_SIZE] treenode_pool;
		/* input state */
		public mu_Vec2 mouse_pos;
		public mu_Vec2 last_mouse_pos;
		public mu_Vec2 mouse_delta;
		public mu_Vec2 scroll_delta;
		public c_int mouse_down;
		public c_int mouse_pressed;
		public c_int key_down;
		public c_int key_pressed;
		public char[32] input_text;
	}

	[CLink] public static extern mu_Vec2 mu_vec2(c_int x, c_int y);
	[CLink] public static extern mu_Rect mu_rect(c_int x, c_int y, c_int w, c_int h);
	[CLink] public static extern mu_Color mu_color(c_int r, c_int g, c_int b, c_int a);

	[CLink] public static extern void mu_init(mu_Context* ctx);
	[CLink] public static extern void mu_begin(mu_Context* ctx);
	[CLink] public static extern void mu_end(mu_Context* ctx);
	[CLink] public static extern void mu_set_focus(mu_Context* ctx, mu_Id id);
	[CLink] public static extern mu_Id mu_get_id(mu_Context* ctx, void* data, c_int size);
	[CLink] public static extern void mu_push_id(mu_Context* ctx, void* data, c_int size);
	[CLink] public static extern void mu_pop_id(mu_Context* ctx);
	[CLink] public static extern void mu_push_clip_rect(mu_Context* ctx, mu_Rect rect);
	[CLink] public static extern void mu_pop_clip_rect(mu_Context* ctx);
	[CLink] public static extern mu_Rect mu_get_clip_rect(mu_Context* ctx);
	[CLink] public static extern c_int mu_check_clip(mu_Context* ctx, mu_Rect r);
	[CLink] public static extern mu_Container* mu_get_current_container(mu_Context* ctx);
	[CLink] public static extern mu_Container* mu_get_container(mu_Context* ctx, char* name);
	[CLink] public static extern void mu_bring_to_front(mu_Context* ctx, mu_Container* cnt);

	[CLink] public static extern c_int mu_pool_init(mu_Context* ctx, mu_PoolItem* items, c_int len, mu_Id id);
	[CLink] public static extern c_int mu_pool_get(mu_Context* ctx, mu_PoolItem* items, c_int len, mu_Id id);
	[CLink] public static extern void mu_pool_update(mu_Context* ctx, mu_PoolItem* items, c_int idx);

	[CLink] public static extern void mu_input_mousemove(mu_Context* ctx, c_int x, c_int y);
	[CLink] public static extern void mu_input_mousedown(mu_Context* ctx, c_int x, c_int y, c_int btn);
	[CLink] public static extern void mu_input_mouseup(mu_Context* ctx, c_int x, c_int y, c_int btn);
	[CLink] public static extern void mu_input_scroll(mu_Context* ctx, c_int x, c_int y);
	[CLink] public static extern void mu_input_keydown(mu_Context* ctx, c_int key);
	[CLink] public static extern void mu_input_keyup(mu_Context* ctx, c_int key);
	[CLink] public static extern void mu_input_text(mu_Context* ctx, char* text);

	[CLink] public static extern mu_Command* mu_push_command(mu_Context* ctx, c_int type, c_int size);
	[CLink] public static extern c_int mu_next_command(mu_Context* ctx, mu_Command** cmd);
	[CLink] public static extern void mu_set_clip(mu_Context* ctx, mu_Rect rect);
	[CLink] public static extern void mu_draw_rect(mu_Context* ctx, mu_Rect rect, mu_Color color);
	[CLink] public static extern void mu_draw_box(mu_Context* ctx, mu_Rect rect, mu_Color color);
	[CLink] public static extern void mu_draw_text(mu_Context* ctx, mu_Font font, char* str, c_int len, mu_Vec2 pos, mu_Color color);
	[CLink] public static extern void mu_draw_icon(mu_Context* ctx, c_int id, mu_Rect rect, mu_Color color);

	[CLink] public static extern void mu_layout_row(mu_Context* ctx, c_int items, c_int* widths, c_int height);
	[CLink] public static extern void mu_layout_width(mu_Context* ctx, c_int width);
	[CLink] public static extern void mu_layout_height(mu_Context* ctx, c_int height);
	[CLink] public static extern void mu_layout_begin_column(mu_Context* ctx);
	[CLink] public static extern void mu_layout_end_column(mu_Context* ctx);
	[CLink] public static extern void mu_layout_set_next(mu_Context* ctx, mu_Rect r, c_int relative);
	[CLink] public static extern mu_Rect mu_layout_next(mu_Context* ctx);

	[CLink] public static extern void mu_draw_control_frame(mu_Context* ctx, mu_Id id, mu_Rect rect, c_int colorid, c_int opt);
	[CLink] public static extern void mu_draw_control_text(mu_Context* ctx, char* str, mu_Rect rect, c_int colorid, c_int opt);
	[CLink] public static extern c_int mu_mouse_over(mu_Context* ctx, mu_Rect rect);
	[CLink] public static extern void mu_update_control(mu_Context* ctx, mu_Id id, mu_Rect rect, c_int opt);

	public static mixin mu_button(mu_Context* ctx, char* label)
	{
		mu_button_ex(ctx, label, 0, (.)mu_option.MU_OPT_ALIGNCENTER);
	}

	public static mixin mu_textbox(mu_Context* ctx, char* buf, c_int bufsz)
	{
		mu_textbox_ex(ctx, buf, bufsz, 0);
	}

	public static mixin mu_slider(mu_Context* ctx, mu_Real* value, mu_Real lo, mu_Real hi)
	{
		mu_slider_ex(ctx, value, lo, hi, 0, MU_SLIDER_FMT, (.)mu_option.MU_OPT_ALIGNCENTER);
	}

	public static mixin mu_number(mu_Context* ctx, mu_Real* value, mu_Real step)
	{
		mu_number_ex(ctx, value, step, MU_SLIDER_FMT, (.)mu_option.MU_OPT_ALIGNCENTER);
	}

	public static mixin mu_header(mu_Context* ctx, char* label)
	{
		mu_header_ex(ctx, label, 0);
	}

	public static mixin mu_begin_treenode(mu_Context* ctx, char* label)
	{
		mu_begin_treenode_ex(ctx, label, 0);
	}

	public static mixin mu_begin_window(mu_Context* ctx, char* title, mu_Rect rect)
	{
		mu_begin_window_ex(ctx, title, rect, 0);
	}

	public static mixin mu_begin_panel(mu_Context* ctx, char* name)
	{
		mu_begin_panel_ex(ctx, name, 0);
	}

	[CLink] public static extern void mu_text(mu_Context* ctx, char* text);
	[CLink] public static extern void mu_label(mu_Context* ctx, char* text);
	[CLink] public static extern c_int mu_button_ex(mu_Context* ctx, char* label, c_int icon, c_int opt);
	[CLink] public static extern c_int mu_checkbox(mu_Context* ctx, char* label, c_int* state);
	[CLink] public static extern c_int mu_textbox_raw(mu_Context* ctx, char* buf, c_int bufsz, mu_Id id, mu_Rect r, c_int opt);
	[CLink] public static extern c_int mu_textbox_ex(mu_Context* ctx, char* buf, c_int bufsz, c_int opt);
	[CLink] public static extern c_int mu_slider_ex(mu_Context* ctx, mu_Real* value, mu_Real low, mu_Real high, mu_Real step, char* fmt, c_int opt);
	[CLink] public static extern c_int mu_number_ex(mu_Context* ctx, mu_Real* value, mu_Real step, char* fmt, c_int opt);
	[CLink] public static extern c_int mu_header_ex(mu_Context* ctx, char* label, c_int opt);
	[CLink] public static extern c_int mu_begin_treenode_ex(mu_Context* ctx, char* label, c_int opt);
	[CLink] public static extern void mu_end_treenode(mu_Context* ctx);
	[CLink] public static extern c_int mu_begin_window_ex(mu_Context* ctx, char* title, mu_Rect rect, c_int opt);
	[CLink] public static extern void mu_end_window(mu_Context* ctx);
	[CLink] public static extern void mu_open_popup(mu_Context* ctx, char* name);
	[CLink] public static extern c_int mu_begin_popup(mu_Context* ctx, char* name);
	[CLink] public static extern void mu_end_popup(mu_Context* ctx);
	[CLink] public static extern void mu_begin_panel_ex(mu_Context* ctx, char* name, c_int opt);
	[CLink] public static extern void mu_end_panel(mu_Context* ctx);
}