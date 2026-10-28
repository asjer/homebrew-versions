# frozen_string_literal: true

require "formulary"
require "simulate_system"

formula_path = Pathname(__dir__).parent/"Formula/herdr@0.9.3.rb"
assets = {
  [:macos, :arm]   => [
    "macos-aarch64",
    "5173a3e0ae42d5d1ab7ebfa5d5e6329f7c3d23f8e1a3677c7ce3231da2884157",
  ],
  [:macos, :intel] => [
    "macos-x86_64",
    "db62d548ff3e832b087a96b1894a08d26be3905f1830309cd556783f215d4054",
  ],
  [:linux, :arm]   => [
    "linux-aarch64",
    "4de7aa3e25678812e92960de64f7c2aaa1bca1f0f80a3c5e559837e231e1f5c0",
  ],
  [:linux, :intel] => [
    "linux-x86_64",
    "18a8dc65f1c2fa485884344356dea1cfd911c6f06cf46fa78e193f4087f4dba7",
  ],
}

assets.each do |(os, arch), (asset, checksum)|
  Homebrew::SimulateSystem.with(os:, arch:) do
    formula = Formulary.from_contents(
      "herdr@0.9.3", formula_path, formula_path.read, tap: Tap.fetch("asjer/versions"),
    )
    expected_url = "https://github.com/herdrdev/herdr/releases/download/v0.9.3/herdr-#{asset}"
    raise "Wrong version for #{os}/#{arch}" unless formula.version.to_s == "0.9.3"
    raise "Wrong release asset for #{os}/#{arch}" unless formula.stable.url == expected_url
    raise "Wrong checksum for #{os}/#{arch}" unless formula.stable.checksum.to_s == checksum
    raise "Formula must remain keg-only" unless formula.keg_only?
    raise "Pinned formula must not offer HEAD" if formula.head
    raise "Unexpected dependency" unless formula.deps.empty?

    puts "PASS: #{os}/#{arch} selects the pinned 0.9.3 asset and checksum"
  end
end
