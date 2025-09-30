class QuartoCli < Formula
  desc "Scientific and technical publishing system built on Pandoc"
  homepage "https://quarto.org/"
  url "https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.25/quarto-1.8.25-linux-amd64.tar.gz"
  version "1.8.25"
  sha256 "13d443028a0a827b21757b37f9eb52dbaf8f0623ebfcac44162fbea3ad9fc1ff"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # This tap's formula is intentionally Linux-only. macOS users should use the official cask.
  if OS.mac?
    odie "This formula is Linux-only. On macOS install the official Quarto cask:\n  brew install --cask quarto"
  end

  on_linux do
    on_intel do
      url "https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.25/quarto-1.8.25-linux-amd64.tar.gz"
      sha256 "13d443028a0a827b21757b37f9eb52dbaf8f0623ebfcac44162fbea3ad9fc1ff"
    end

    on_arm do
      url "https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.24/quarto-1.8.24-linux-arm64.tar.gz"
      sha256 "89a97a65a242a5b9b010a9f9978928c1d8e4ac02a558c9cd91a110c3f2611fdd"
    end
  end

  def install
    # Install all files preserving directory structure
    libexec.install Dir["*"]

    # Symlink main executable
    bin.install_symlink libexec/"bin/quarto"

    # Man pages
    man1.install_symlink Dir[libexec/"share/man/man1/*"] if (libexec/"share/man/man1").exist?

    # Shell completions
    if (libexec/"share/bash-completion/completions").exist?
      bash_completion.install_symlink libexec/"share/bash-completion/completions/quarto"
    end
    if (libexec/"share/zsh/site-functions").exist?
      zsh_completion.install_symlink libexec/"share/zsh/site-functions/_quarto"
    end
    if (libexec/"share/fish/vendor_completions.d").exist?
      fish_completion.install_symlink libexec/"share/fish/vendor_completions.d/quarto.fish"
    end
  end

  # Avoid network activity in post_install (no TinyTeX auto-install here).
  def caveats
    <<~EOS
      Quarto (Linux binary) installed.

      Optional tools you may want to install separately (all optional in this formula):
        brew install pandoc deno esbuild node python@3.12 r julia typst sass/sass/sass

      For LaTeX/PDF rendering install a TeX distribution or run:
        quarto install tinytex
      (This performs a network install outside Homebrew.)

      On macOS use the official cask instead:
        brew install --cask quarto

      Check installation:
        quarto check

      Docs: https://quarto.org/docs/
    EOS
  end

  test do
    assert_match "Quarto #{version}", shell_output("#{bin}/quarto --version").strip
    assert_match "Usage:", shell_output("#{bin}/quarto --help")
    system bin/"quarto", "check"

    (testpath/"test.qmd").write <<~EOS
      ---
      title: "Test Document"
      format: html
      ---

      # Hello Quarto

      This is a test document.
    EOS
    system bin/"quarto", "render", "test.qmd", "--to", "html", "--no-execute"
    assert_path_exists testpath/"test.html"
  end
end
