cask "font-fira-math" do
  version "0.3.4"
  sha256 "2028cbd3dd4d8c0cf1608520eb4759956a83a67931d7b6d8e7c313520186e35b"

  url "https://github.com/firamath/firamath/releases/download/v#{version}/FiraMath-Regular.otf"
  name "FiraMath"
  desc "Sans-serif font with Unicode math support"
  homepage "https://github.com/firamath/firamath"

  font "FiraMath-Regular.otf"

  # No zap stanza required
end
