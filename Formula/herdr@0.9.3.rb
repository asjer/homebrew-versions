class HerdrAT093 < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  license "Apache-2.0"

  livecheck do
    skip "Pinned upstream release"
  end

  keg_only :versioned_formula

  on_macos do
    on_arm do
      url "https://github.com/herdrdev/herdr/releases/download/v0.9.3/herdr-macos-aarch64"
      sha256 "5173a3e0ae42d5d1ab7ebfa5d5e6329f7c3d23f8e1a3677c7ce3231da2884157"
    end
    on_intel do
      url "https://github.com/herdrdev/herdr/releases/download/v0.9.3/herdr-macos-x86_64"
      sha256 "db62d548ff3e832b087a96b1894a08d26be3905f1830309cd556783f215d4054"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/herdrdev/herdr/releases/download/v0.9.3/herdr-linux-aarch64"
      sha256 "4de7aa3e25678812e92960de64f7c2aaa1bca1f0f80a3c5e559837e231e1f5c0"
    end
    on_intel do
      url "https://github.com/herdrdev/herdr/releases/download/v0.9.3/herdr-linux-x86_64"
      sha256 "18a8dc65f1c2fa485884344356dea1cfd911c6f06cf46fa78e193f4087f4dba7"
    end
  end

  def install
    os = OS.mac? ? "macos" : "linux"
    arch = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    bin.install "herdr-#{os}-#{arch}" => "herdr"
    (bin/"herdr").chmod 0755
    generate_completions_from_executable(bin/"herdr", "completion")
  end

  test do
    ENV["HOME"] = testpath.to_s
    ENV["XDG_CONFIG_HOME"] = (testpath/"config").to_s
    ENV["XDG_STATE_HOME"] = (testpath/"state").to_s
    ENV["HERDR_CONFIG_PATH"] = (testpath/"config.toml").to_s
    ENV["HERDR_SOCKET_PATH"] = (testpath/"herdr.sock").to_s
    (testpath/"config.toml").write "# Isolated formula test.\n"
    assert_equal "herdr #{version}", shell_output("#{bin}/herdr --version").strip
    assert_match "config: ok", shell_output("#{bin}/herdr config check")
  end
end
