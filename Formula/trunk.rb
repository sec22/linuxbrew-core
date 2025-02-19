class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.7.3.tar.gz"
  sha256 "5847947d13491af835482019452970f2d0f9276afdaeb361a222bb17af0c3187"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1d19b1b84c80eff7f298e3ffda7765d7dd95fa6cd4d1320b7fc28fcbd0dcd49" => :catalina
    sha256 "269360fc9e6f348b79c79f02281afe9d8ce321601ac7e3031042f58e55972cb3" => :mojave
    sha256 "882301f19abbd26aafa6d8587072a9703f9a751942cb34a36e1963e7ae49568c" => :high_sierra
    sha256 "cd5ebdd04d1e13f5765243587ecd1620fc7f8cbf0714f7226dbcad94db106143" => :x86_64_linux
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
