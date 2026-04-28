{ ... }:
{
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";

    font = {
      name = "FantasqueSansM Nerd Font Mono";
      size = 14;
    };

    settings = {
      scrollback_lines = -1;
      copy_on_select = "yes";
      window_border_width = "1.0";
      window_padding_width = 10;
      placement_strategy = "top-left";
      hide_window_decorations = "titlebar-only";
      tab_bar_margin_width = "0.0";
      tab_bar_style = "powerline";
      tab_bar_min_tabs = 2;
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
      allow_remote_control = "yes";
      listen_on = "unix:$TMPDIR/kitty";
      macos_quit_when_last_window_closed = "yes";
    };

    keybindings = {
      "cmd+w" = "close_window";
      "kitty_mod+enter" = "new_window_with_cwd";
      "cmd+enter" = "new_window_with_cwd";
      "shift+cmd+t" = "new_tab_with_cwd";
      "cmd+1" = "goto_tab 1";
      "cmd+2" = "goto_tab 2";
      "cmd+3" = "goto_tab 3";
      "cmd+4" = "goto_tab 4";
      "cmd+5" = "goto_tab 5";
      "cmd+6" = "goto_tab 6";
      "cmd+7" = "goto_tab 7";
      "cmd+8" = "goto_tab 8";
      "cmd+9" = "goto_tab 9";
    };
  };
}
