class Khop < Formula
  desc "Fast Kubernetes context and namespace switcher"
  homepage "https://github.com/ikchifo/kubehop"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ikchifo/kubehop/releases/download/v0.3.0/khop-aarch64-apple-darwin.tar.xz"
      sha256 "08c8fa3b52b01aefb8273f310d2bb5105bc247fb4713b9f085781d5a8e9d2e58"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ikchifo/kubehop/releases/download/v0.3.0/khop-x86_64-apple-darwin.tar.xz"
      sha256 "3506f2f4ef287d17e370d1f2416e04dcef2a1ced86ed69422c39834c03dbb8f6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ikchifo/kubehop/releases/download/v0.3.0/khop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b0d0569c838350c4074bffc98059392d3e52034a4816f40f065f046d6b154585"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ikchifo/kubehop/releases/download/v0.3.0/khop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "78d5599b7aae472a7963de40d01a937883f061653263fce995a531075a5792c7"
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
