{ lib
, bundlerApp
, makeWrapper
, zlib
, expat
, openssl
}:

bundlerApp {
  pname = "fontist";
  gemdir = ./.;
  exes = [ "fontist" ];

  buildInputs = [ zlib expat openssl ];

  postBuild = ''
    # Ensure the fontist executable can find required system libraries
    wrapProgram $out/bin/fontist \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ zlib expat openssl ]}"
  '';

  meta = with lib; {
    description = "Install openly-licensed fonts on Windows, Linux and Mac";
    longDescription = ''
      Fontist is a simple library to find and download fonts for Windows, Linux and Mac.
      It helps you install openly-licensed fonts on your system easily.
    '';
    homepage = "https://github.com/fontist/fontist";
    license = licenses.bsd2;
    maintainers = [ ];
    platforms = platforms.unix;
    mainProgram = "fontist";
  };
}