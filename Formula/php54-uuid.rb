require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Uuid < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/uuid'
  url 'http://pecl.php.net/get/uuid-1.0.2.tgz'
  md5 'c45246bccdaf5e77934be47637627e7f'
  head 'https://svn.php.net/repository/pecl/uuid/trunk', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'php54' if ARGV.include?('--with-homebrew-php') && !Formula.factory('php54').installed?

  def patches
    # fixes build errors on OSX 10.6 and 10.7
    # https://bugs.php.net/bug.php?id=62009
    # https://bugs.php.net/bug.php?id=58311
    p = []

    if ARGV.build_head?
      p << "https://raw.github.com/gist/2902360/eb354918f0afff2b4fcd7869d5a49719a2b32312/uuid-trunk.patch"
    else
      p << "https://raw.github.com/gist/2891193/c538ae506aafd1d61f166fa3c1409dca61d100c6/uuid.patch"
    end

    return p
  end

  def install
    Dir.chdir "uuid-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/uuid.so"
    write_config_file unless ARGV.include? "--without-config-file"
  end
end
