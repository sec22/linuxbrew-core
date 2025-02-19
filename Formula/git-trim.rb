class GitTrim < Formula
  desc "Trim your git remote tracking branches that are merged or gone"
  homepage "https://github.com/foriequal0/git-trim"
  url "https://github.com/foriequal0/git-trim/archive/v0.4.1.tar.gz"
  sha256 "c4b406daefb3753646314d967be99122dace2d5f7dbbceeb360ced9718961b36"
  license "MIT"

  bottle do
    cellar :any
    sha256 "3c0adf54c1a54070a401b7956b88140827d5a3cc1690e13ffa598cb0e9822066" => :catalina
    sha256 "919450813d77ebec55a1eca59848b0589e81d41208c1e116fcf9335c783ad3ea" => :mojave
    sha256 "1ebad3afdd2d3819c408395b01a70a9f2461c637f07feb59b8cddbf2eb1ee920" => :high_sierra
    sha256 "d064fa4f63a15c95851ed779a8de6e6c245906da4821179336b2a7747f74e04e" => :x86_64_linux
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/git-trim.man" => "git-trim.1"
  end

  test do
    system "git", "clone", "https://github.com/foriequal0/git-trim"
    Dir.chdir("git-trim")
    system "git", "branch", "brew-test"
    assert_match "brew-test", shell_output("git trim")
  end
end
