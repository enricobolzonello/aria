class Aria < Formula
  desc "The Aria Programming Language"
  homepage "https://egranata.github.io/aria/"
  url "https://github.com/enricobolzonello/aria/raw/issue-39-macos-pkg/aria.tar.gz"
  version "0.9.0"
  sha256 "6b106e8df401b954af5f3411a972673aea0e7d1e5a061a2bfd897243fc76edce"
  license "Apache-2.0"

  def install
    # Install the pre-built binary
    bin.install "aria"

    # Install libraries if present
    (share/"aria/lib").install Dir["lib/*"] if Dir.exist?("lib")
    (share/"aria/lib-test").install Dir["lib-test/*"] if Dir.exist?("lib-test")

    # Create a wrapper script to set ARIA_LIB_DIR
    (bin/"aria").write <<~EOS
      #!/bin/sh
      export ARIA_LIB_DIR="#{share}/aria/lib:#{share}/aria/lib-test"
      exec "#{bin}/aria" "$@"
    EOS
    chmod 0755, bin/"aria"
  end

  test do
    # Check that the wrapper script runs and reports version
    output = shell_output("#{bin}/aria --version")
    assert_match version.to_s, output
  end
end
