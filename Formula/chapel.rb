class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.23.0/chapel-1.23.0.tar.gz"
  sha256 "7ae2c8f17a7b98ac68378e94a842cf16d4ab0bcfeabc0fee5ab4aaa07b205661"
  license "Apache-2.0"

  bottle do
    sha256 "5aa5b6a7e03ed702530959c1983e8989be5f1ba4494af6d9da044e38ef62bfcb" => :catalina
    sha256 "123c5824b82621b4984e1afbf4f01f5c20af8cbc03e7b1266af396f8eaa80f79" => :mojave
    sha256 "101b6a940e07d3e86ec809b3f7737950e0ef12c61daf43ef92c00e95047333c5" => :high_sierra
    sha256 "4f2b7dd75b8f89c3318c857d66fe2d3507ae6ab46b4937ef037e0eaca0773cea" => :x86_64_linux
  end

  depends_on "python@3.8" unless OS.mac?

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin" unless OS.mac?

    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    # This is for mason
    ENV["CHPL_REGEXP"] = "re2"

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://github.com/Homebrew/legacy-homebrew/pull/35166
    cd libexec do
      system "make"
      system "make", "chpldoc"
      system "make", "mason"
      system "make", "cleanall"
    end

    prefix.install_metafiles

    # Install chpl and other binaries (e.g. chpldoc) into bin/ as exec scripts.
    platform = if OS.mac?
      "darwin-x86_64"
    else
      Hardware::CPU.is_64_bit? ? "linux64-x86_64" : "linux-x86_64"
    end
    bin.install Dir[libexec/"bin/#{platform}/*"]
    bin.env_script_all_files libexec/"bin/#{platform}/", CHPL_HOME: libexec
    man1.install_symlink Dir["#{libexec}/man/man1/*.1"]
  end

  test do
    # Fix [Fail] chpl not found. Make sure it available in the current PATH.
    # Makefile:203: recipe for target 'check' failed
    ENV.prepend_path "PATH", bin unless OS.mac?
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin" unless OS.mac?

    ENV["CHPL_HOME"] = libexec
    cd libexec do
      system "util/test/checkChplInstall"
    end
  end
end
