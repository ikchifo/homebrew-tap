class Khop < Formula
  desc "Fast Kubernetes context and namespace switcher"
  homepage "https://github.com/ikchifo/kubehop"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ikchifo/kubehop/releases/download/v0.1.0/khop-aarch64-apple-darwin.tar.xz"
      sha256 "c3361251d6f5a32e2ad0e2c2fae69fa6b036522b24d924f4807ff76946f51c9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ikchifo/kubehop/releases/download/v0.1.0/khop-x86_64-apple-darwin.tar.xz"
      sha256 "91a74aa4f06cfbb8c431f8d0b9710b4b626b8def0a47a7b32de4fe66dfa7d859"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ikchifo/kubehop/releases/download/v0.1.0/khop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9a9e77e956254e22788d9f3e896429728527fb7ee5e97fbda58fd8c7dec68bd1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ikchifo/kubehop/releases/download/v0.1.0/khop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fc2ce25397893169bcc573b751e5cc5cdc8c0eab7d4266b2ddd9339f14705524"
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
