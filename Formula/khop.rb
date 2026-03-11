class Khop < Formula
  desc "Fast Kubernetes context and namespace switcher"
  homepage "https://github.com/ikchifo/kubehop"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ikchifo/kubehop/releases/download/v0.2.0/khop-aarch64-apple-darwin.tar.xz"
      sha256 "636f75ff0144cea81366a6e189bd43a91225f4cb32095ab0decde29419c352cc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ikchifo/kubehop/releases/download/v0.2.0/khop-x86_64-apple-darwin.tar.xz"
      sha256 "345e56460268c3a42b65d582d9a810d7276c10cd4db53589c848912997d68f36"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ikchifo/kubehop/releases/download/v0.2.0/khop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7ef082e133eff9f7cf13318567899edcbecccb39b54db38f828713c045090fab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ikchifo/kubehop/releases/download/v0.2.0/khop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7f2088e033003c6d638d45d1f80c28f2561d7373cb0aa7a11d7d8c8569bd65b6"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "khop" if OS.mac? && Hardware::CPU.arm?
    bin.install "khop" if OS.mac? && Hardware::CPU.intel?
    bin.install "khop" if OS.linux? && Hardware::CPU.arm?
    bin.install "khop" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
