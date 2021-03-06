class IgnitionRendering1 < Formula
  desc "Rendering library for robotics applications"
  homepage "https://bitbucket.org/ignitionrobotics/ign-rendering"
  url "https://bitbucket.org/ignitionrobotics/ign-rendering/get/8cbb07bef149.tar.gz"
  version "0.999.999~20180720~8cbb07b"
  sha256 "d40c67b5e273720a9ec6f7e42d3ab674d464a20f0fcd5e512a2997375c22c6b1"

  # bottle do
  #   root_url "http://gazebosim.org/distributions/ign-rendering/releases"
  #   sha256 "8b8c253114e3c6af1d6978e79b02c3c10895a5fe276a21570e370eaa4252491d" => :high_sierra
  #   sha256 "520b171c51d0415f99ae7c8ecdd955249d166bad89edcad83879b85735c9a80f" => :sierra
  #   sha256 "42acd100d3187950a56ec3fde87349feb78368d7c3552a9a1344f0c031511f72" => :el_capitan
  # end

  depends_on "cmake" => :build

  depends_on "freeimage"
  depends_on "ignition-cmake2"
  depends_on "ignition-common3"
  depends_on "ignition-math6"
  depends_on "ogre1.9"
  depends_on "pkg-config"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <ignition/rendering/PixelFormat.hh>
      int main(int _argc, char** _argv)
      {
        ignition::rendering::PixelFormat pf = ignition::rendering::PF_UNKNOWN;
        return ignition::rendering::PixelUtil::IsValid(pf);
      }
    EOS
    ENV.append_path "PKG_CONFIG_PATH", "#{Formula["qt"].opt_lib}/pkgconfig"
    system "pkg-config", "ignition-rendering1"
    cflags   = `pkg-config --cflags ignition-rendering1`.split(" ")
    ldflags  = `pkg-config --libs ignition-rendering1`.split(" ")
    system ENV.cc, "test.cpp",
                   *cflags,
                   *ldflags,
                   "-lc++",
                   "-o", "test"
    system "./test"
  end
end
