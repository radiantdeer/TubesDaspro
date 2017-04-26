unit ulogin;


interface
  uses banktype;

// List semua fungsi/prosedur yang tersedia di unit ini
  function login_do(user, pass : string; T : lnasabah) : integer;
  { I.S. : user, pass, T terdefinisi
  F.S. : login bernilai 0 jika user/pass salah, atau integer positif yang menyatakan posisi data tersebut dalam array T.list
  Menggunakan fungsi isUserExists dalam implementasinya }
  function isUserExists(user : string; T : lnasabah) : integer;
  { I.S. : user, T terdefinisi
  F.S. : isUserExists bernilai 0 jika user ada dalam array T.list, atau integer positif
  yang menyatakan posisi data tersebut dalam array T.list jika user ditemukan }

implementation
  function login_do(user, pass : string; T : lnasabah) : integer;

  // KAMUS LOKAL
  var
    loc : integer;

  // ALGORITMA FUNGSI
  begin
    loc := isUserExists(user, T);
    if (loc <> 0) then
    begin
      if (pass = T.list[loc].pass) then login_do := loc
      else login_do := 0;
    end else login_do := 0;
  end;

  function isUserExists(user : string; T : lnasabah) : integer;

  // KAMUS LOKAL
  var
    i : integer;
    found : boolean;

  // ALGORITMA FUNGSI
  begin
    // Inisialisasi Variabel
    i := 1;
    found := false;
    while((i <= T.Neff) AND NOT(found)) do // Bagian pencarian user
    begin
      if (T.list[i].user = user) then found := true
      else i := i + 1;
    end;
    if (found) then isUserExists := i // User ditemukan
    else isUserExists := 0; // User tidak ditemukan
  end;

end.
