class QuartoCli < Formula
  desc "Scientific and technical publishing system built on Pandoc"
  homepage "https://www.quarto.org/"
  version "1.7.34"
  license "MIT"

  livecheck do
    url "https://github.com/quarto-dev/quarto-cli"
    strategy :github_latest
  end

  on_linux do
    on_arm do
      url "https://github.com/quarto-dev/quarto-cli/releases/download/v#{version}/quarto-#{version}-linux-arm64.tar.gz"
      sha256 "6daf567c7a9eed2f72b6fef7c86ce9552ead5651dcde28fa5f70fa92729a10a8"
    end
    on_intel do
      url "https://github.com/quarto-dev/quarto-cli/releases/download/v#{version}/quarto-#{version}-linux-amd64.tar.gz"
      sha256 "dd6b030a44b963d01f94b9696bacba71afc3178eb6d51a9cc105332b77ea6b9a"
    end
  end

  def install
    libexec.install Dir["*"]

    bin.install_symlink libexec/"bin/quarto"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quarto --version")
  end
end
