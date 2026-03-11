class Khop < Formula
  desc "Fast Kubernetes context and namespace switcher"
  homepage "https://github.com/ikchifo/kubehop"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ikchifo/kubehop/releases/download/v0.2.1/khop-aarch64-apple-darwin.tar.xz"
      sha256 "96537e925c27adb1112d43dd0bc57e4c60face6e6041162682ff4775ac3a4923"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ikchifo/kubehop/releases/download/v0.2.1/khop-x86_64-apple-darwin.tar.xz"
      sha256 "44b8b1b610301da7c3c85cb057d036e128fe145924c8114e59c0d0aebbc75bba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ikchifo/kubehop/releases/download/v0.2.1/khop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "817a3e384582e66f7f938b7ed77dffa8e6c9130fd28410f1906fa047a380e712"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ikchifo/kubehop/releases/download/v0.2.1/khop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "73c5d190bc66ab9729b97d76b9fc0af5f39c71c46a52b264bcb5d76ab57ea988"
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
