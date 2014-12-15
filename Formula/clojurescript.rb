require "formula"

class Clojurescript < Formula
  homepage "https://github.com/clojure/clojurescript"
  head "https://github.com/clojure/clojurescript.git"
  url "https://github.com/clojure/clojurescript/archive/r2411.tar.gz"
  sha1 "99022cf050aa5f712b295e74aa8e845ad6cdb4b8"

  bottle do
    cellar :any
    sha1 "05a29dcf4e9c92b0a0eee7045c25e7265d10241c" => :mavericks
    sha1 "dc804f7b868c8ca634fdc8793608c1730c50cbc6" => :mountain_lion
    sha1 "d2ff39cccff549ebf65b230b09b99f81b8ec6a36" => :lion
  end

  def install
    system "./script/bootstrap"
    inreplace %w(bin/cljsc script/repl script/repljs script/browser-repl),
      "#!/bin/sh", "#!/bin/sh\nCLOJURESCRIPT_HOME=#{libexec}"
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/cljsc"
  end

  def caveats; <<-EOS.undent
    This formula is useful if you need to use the ClojureScript compiler directly.
    For a more integrated workflow, Leiningen with lein-cljsbuild is recommended.
    EOS
  end

  test do
    (testpath/"t.cljs").write <<-EOF.undent
    (ns hello)
    (defn ^:export greet [n]
      (str "Hello " n))
    EOF

    system "#{bin}/cljsc", testpath/"t.cljs"
  end
end
