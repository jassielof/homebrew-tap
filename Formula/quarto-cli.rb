class QuartoCli < Formula
  desc "Scientific and technical publishing system built on Pandoc"
  homepage "https://quarto.org/"
  url "https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.24/quarto-1.8.24-linux-amd64.tar.gz"
  sha256 "6b83c1c9b6f2ce6454798b42260bd2ee184551d74debe817b8aaf28b09ac22d0"
  license "GPL-2.0-or-later"

  depends_on macos: :big_sur if OS.mac?
  depends_on "deno" => :recommended
  depends_on "esbuild" => :recommended
  depends_on "pandoc" => :recommended
  depends_on "sass/sass/sass" => :recommended
  depends_on "julia" => :optional
  depends_on "node" => :optional
  depends_on "python@3.12" => :optional
  depends_on "r" => :optional
  depends_on "typst" => :optional

  on_macos do
    on_intel do
      url "https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.24/quarto-1.8.24-macos.tar.gz"
      sha256 "8f3be3719e8332c4583bd03aeb541b7c5aebc4f24c1799502c97051bbaa88c63"
    end

    on_arm do
      url "https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.24/quarto-1.8.24-macos.tar.gz"
      sha256 "8f3be3719e8332c4583bd03aeb541b7c5aebc4f24c1799502c97051bbaa88c63"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.24/quarto-1.8.24-linux-amd64.tar.gz"
      sha256 "6b83c1c9b6f2ce6454798b42260bd2ee184551d74debe817b8aaf28b09ac22d0"
    end

    on_arm do
      url "https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.24/quarto-1.8.24-linux-arm64.tar.gz"
      sha256 "89a97a65a242a5b9b010a9f9978928c1d8e4ac02a558c9cd91a110c3f2611fdd"
    end
  end

  def install
    # Install all files preserving directory structure
    libexec.install Dir["*"]

    # Create symlink for the main executable
    bin.install_symlink libexec/"bin/quarto"

    # Install man pages if they exist
    man1.install_symlink Dir[libexec/"share/man/man1/*"] if (libexec/"share/man").exist?

    # Set up completion scripts if they exist
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

  def post_install
    # Create necessary directories and setup
    (var/"quarto").mkpath

    # Initialize quarto tools if needed
    system bin/"quarto", "tools", "install", "tinytex", "--quiet" if which("pdflatex").nil?
  end

  def caveats
    <<~EOS
      Quarto has been installed successfully.

      For optimal functionality, consider installing optional dependencies:
        - Python: brew install python@3.12
        - R: brew install --cask r
        - Julia: brew install julia
        - Node.js: brew install node
        - Typst: brew install typst
        - Sass: brew install sass/sass/sass

      To render PDFs, you'll need a LaTeX distribution.
      Quarto can install TinyTeX automatically:
        quarto install tinytex

      To check your Quarto installation:
        quarto check

      Documentation is available at: https://quarto.org/docs/
    EOS
  end

  test do
    # Test basic functionality
    assert_match "Quarto #{version}", shell_output("#{bin}/quarto --version").strip

    # Test help command
    assert_match "Usage:", shell_output("#{bin}/quarto --help")

    # Test check command
    system bin/"quarto", "check"

    # Test creating a basic document
    (testpath/"test.qmd").write <<~EOS
      ---
      title: "Test Document"
      format: html
      ---

      # Hello Quarto

      This is a test document.

      ```{python}
      print("Hello from Python!")
      ```
    EOS

    # Test rendering (basic functionality without requiring all engines)
    system bin/"quarto", "render", "test.qmd", "--to", "html", "--no-execute"
    assert_path_exists testpath/"test.html"
  end
end
