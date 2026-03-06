{
  description = "My Markdown environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Linting & formatting
            markdownlint-cli # Lint markdown files
            nodePackages.prettier # Format markdown consistently

            # Previewing
            mdbook # Build & serve markdown as a book/site
            glow # Terminal markdown renderer

            # Conversion
            pandoc # Convert markdown to PDF, DOCX, HTML, etc.

            # Writing aids
            vale # Prose linter (style, grammar checks)
            aspell # Spell checking
            aspellDicts.en # English dictionary

            # Optional: LSP for editors (e.g. Neovim/VSCode)
            marksman # Markdown LSP (links, references)
          ];

          shellHook = ''
            echo "📝 Markdown editing environment ready"
            echo ""
            echo "Tools available:"
            echo "  markdownlint-cli  → markdownlint '**/*.md'"
            echo "  prettier          → prettier --write '**/*.md'"
            echo "  glow              → glow README.md"
            echo "  mdbook            → mdbook serve"
            echo "  pandoc            → pandoc input.md -o output.pdf"
            echo "  vale              → vale document.md"
          '';
        };
      }
    );
}
