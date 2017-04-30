unit ulogin;


interface
  uses banktype;

// List semua fungsi/prosedur yang tersedia di unit ini
  procedure login();
  { Bagian utama yang menangani berbagai kondisi yang mungkin dialami saat akan login }
  function login_do(user, pass : string; T : lnasabah) : integer;
  { I.S. : user, pass, T terdefinisi
  F.S. : login bernilai 0 jika user/pass salah, atau integer positif yang menyatakan posisi data tersebut dalam array T.list
  Menggunakan fungsi isUserExists dalam implementasinya }
  function isUserExists(user : string; T : lnasabah) : integer;
  { I.S. : user, T terdefinisi
  F.S. : isUserExists bernilai 0 jika user ada dalam array T.list, atau integer positif
  yang menyatakan posisi data tersebut dalam array T.list jika user ditemukan }

implementation

procedure login();

  begin
    if(loadedFile[1] <> '') then // Mengecek apakah data nasabah sudah dimuat atau belum.
    begin
      if(currentuser.nonasabah = '') then // Mengecek apakah pengguna sudah login sebelumnya
      begin
        write('Username : ');readln(user);
        write('Password : ');readln(pass);
        i := login_do(user,pass,arrnasabah); // Memanggil fungsi untuk memproses login
        if (i <> 0) then // Login berhasil
        begin
          currentuser := arrnasabah.list[i];
          writeln('Login berhasil. Selamat datang ',user,'!');
        end
        else // Login gagal
        begin
          attempt := attempt - 1;
          if (attempt = 0) then // Jika attempt sudah habis
          begin
              writeln('Anda telah salah login 3 kali berturut-turut!');
              writeln('Program akan keluar...');
              if (i <> 0) then arrnasabah.list[i].stat := 'inaktif';
              cmd := 'exit';
          end else // Jika attempt masih ada
          begin
            writeln('Username/password salah. Coba lagi!');
            writeln('Anda hanya memiliki ',attempt,' kesempatan lagi!');
          end;
        end;
      end else { Sudah ada yang login, karena currentuser.nonasabah tidak kosong/'' }
      begin
        writeln('Anda sudah login!');
      end;
    end else { File data nasabah belum diload }
    begin
      writeln('Data nasabah belum dimuat!');
      writeln('Masukkan data nasabah terlebih dahulu dengan menggunakan perintah "load".');
    end;
  end;

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
