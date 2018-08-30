{ stdenv
, fetchFromGitHub
}:

rec {
  version = "2.3.1";

  src = fetchFromGitHub {
    owner  = "openrazer";
    repo   = "openrazer";
    rev    = "v${version}";
    sha256 = "0f8f4z89c16swfzhx73369rw097zgw7f1j1v84hnzqhwlzj256x2";
  };

  meta = with stdenv.lib; {
    description = "An entirely open source driver and user-space daemon that allows you to manage your Razer peripherals on GNU/Linux";
    homepage    = https://openrazer.github.io/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lezed1 ];
    platforms   = platforms.linux;
  };
}
