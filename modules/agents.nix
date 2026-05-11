{ pkgs, ... }:
{
  # AI Agents and autonomous coding tools
  home.packages = with pkgs; [
    github-copilot-cli
    pi-coding-agent
  ];

  programs.gemini-cli.enable = true;
  programs.opencode.enable = true;
  programs.codex.enable = true;
}
