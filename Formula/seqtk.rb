class Seqtk < Formula
  desc "Toolkit for processing sequences in FASTA/Q formats"
  homepage "https://github.com/lh3/seqtk"
  url "https://github.com/lh3/seqtk/archive/v1.3.tar.gz"
  sha256 "5a1687d65690f2f7fa3f998d47c3c5037e792f17ce119dab52fff3cfdca1e563"

  depends_on "zlib" unless OS.mac?

  bottle do
    cellar :any_skip_relocation
    sha256 "4f377caf93e5d334e739375a5dcf06782f1d85516988a26df3f8f53d172b1e6f" => :high_sierra
    sha256 "fd3ecced5ba8f5a9eab13f8f2184f6a69d08b58c1ef53ad6e74bb45cab9324f4" => :sierra
    sha256 "55541e7e9249ef15bd4423ad9a45903918c2b4b54f632bc0472fb24aee683701" => :el_capitan
    sha256 "209ca284bed07359cdc9a934f9892bb3e61d0eeb8368b93c500fb6dda55128c1" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "seqtk"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCT
      CTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    assert_match "TCTCTG", shell_output("#{bin}/seqtk seq test.fasta")
  end
end
