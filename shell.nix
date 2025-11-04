{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    ruby_3_2
    bundler
    git
    
    # System dependencies for fontist
    zlib
    expat
    openssl
  ];

  shellHook = ''
    export GEM_HOME="$PWD/.gems"
    export GEM_PATH="$GEM_HOME:$GEM_PATH"
    export PATH="$GEM_HOME/bin:$PATH"
    
    echo "Fontist development environment"
    echo "Run 'bundle install' to install dependencies"
    echo "Run 'bundle exec fontist' to run fontist"
  '';
}
