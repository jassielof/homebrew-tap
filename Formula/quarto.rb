class Quarto < Formula
  desc "Open-source scientific and technical publishing system built on Pandoc"
  homepage "https://quarto.org/"
  version "1.7.32"
  license "MIT"
  on_macos do
    on_arm do
      url "https://github.com/quarto-dev/quarto-cli/releases/download/v#{version}/quarto-#{version}-macos.tar.gz"
      sha256 "b49912bbe2b507f03d0bac9089f0e97437a87226c59a371e4eff8712557b16e8"
    end
    on_intel do
      url "https://github.com/quarto-dev/quarto-cli/releases/download/v#{version}/quarto-#{version}-macos.tar.gz"
      sha256 "b49912bbe2b507f03d0bac9089f0e97437a87226c59a371e4eff8712557b16e8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/quarto-dev/quarto-cli/releases/download/v#{version}/quarto-#{version}-linux-arm64.tar.gz"
      sha256 "87835e6ed965d865ee1cda367ff0316c7d52104c114f5f1962fdc9fe5da46cd0"
    end
    on_intel do
      url "https://github.com/quarto-dev/quarto-cli/releases/download/v#{version}/quarto-#{version}-linux-amd64.tar.gz"
      sha256 "262505e3d26459c64e66efefd4b9240eb755ea20dd6fe876d6aa64c7a7b13d27"
    end
  end

  livecheck do
    url "https://github.com/quarto-dev/quarto-cli/releases/latest"
    strategy :github_latest
  end

  depends_on "pandoc"

  def install
    # The tarball extracts to a directory named after the package
    prefix.install Dir["*"]

    # Create symlinks for the main executables in bin
    bin.install_symlink prefix/"bin/quarto"

    # Install shell completions if they exist
    if (prefix/"share/bash-completion/completions/quarto").exist?
      bash_completion.install prefix/"share/bash-completion/completions/quarto"
    end

    if (prefix/"share/zsh/site-functions/_quarto").exist?
      zsh_completion.install prefix/"share/zsh/site-functions/_quarto"
    end

    if (prefix/"share/fish/vendor_completions.d/quarto.fish").exist?
      fish_completion.install prefix/"share/fish/vendor_completions.d/quarto.fish"
    end
  end

  test do
    system bin/"quarto", "--version"
    system bin/"quarto", "--help"

    # Test basic functionality
    (testpath/"test.qmd").write <<~EOS
      ---
      title: "Test Document"
      format: html
      ---

      # Hello Quarto

      This is a test document.
    EOS

    system bin/"quarto", "render", "test.qmd"
    assert_predicate testpath/"test.html", :exist?
  end
end
