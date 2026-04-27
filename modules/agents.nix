{pkgs, ...}: {
  # AI Agents and autonomous coding tools
  home.packages = with pkgs; [
    github-copilot-cli
  ];

  programs.gemini-cli = {
    enable = true;
    settings = {
      theme = "Default";
      selectedAuthType = "oauth-personal";
      checkpointing = true;
      experimental = {enableAgents = true;};
      security.auth.selectedType = "oauth-personal";
      ui = {
        footer = {
          items = [
            "workspace"
            "git-branch"
            "sandbox"
            "model-name"
            "quota"
            "context-used"
            "code-changes"
            "token-count"
          ];
        };
        theme = "Default";
      };
    };
  };

  programs.opencode = {
    enable = true;
    settings = {
      provider = {
        openai = {
          options = {
            reasoningEffort = "medium";
            reasoningSummary = "auto";
            textVerbosity = "medium";
            include = ["reasoning.encrypted_content"];
            store = false;
          };
        };
      };
    };
  };

  programs.codex = {
    enable = true;
    settings = {
      personality = "pragmatic";
      model = "gpt-5.3-codex";
      model_reasoning_effort = "medium";

      plugins."github@openai-curated".enabled = true;

      tui.status_line = [
        "model-with-reasoning"
        "current-dir"
        "git-branch"
        "context-usage"
        "five-hour-limit"
        "weekly-limit"
        "context-window-size"
      ];
    };
  };
}
