# quarto.rb
# Personal tap formula: installs Quarto CLI v1.7.32
class QuartoCli < Formula
  desc "Scientific and technical publishing system built on Pandoc"
  homepage "https://www.quarto.org/"
  version "1.7.32"
  license "MIT"

  # --------------------------
  # Platform-specific source & SHA256
  # --------------------------
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

  # --------------------------
  # Livecheck against GitHub releases
  # --------------------------
  livecheck do
    url "https://github.com/quarto-dev/quarto-cli"
    strategy :github_latest
  end

  # --------------------------
  # Installation
  # --------------------------
  def install
    # The tarball already contains a top-level 'quarto-*/' directory
    # Copy everything verbatim into libexec/
    libexec.install Dir["*"]

    # Expose the CLI entrypoint
    bin.install_symlink libexec/"bin/quarto"
  end

  # --------------------------
  # Test
  # --------------------------
  test do
    assert_match version.to_s, shell_output("#{bin}/quarto --version")
  end
end
