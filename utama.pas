Program InterfaceXYZ;
// Program utama yang menangani berbagai masukan dari user

uses uload, ulogin, ulihatrek, banktype, uexit, sysutils, crt;
// u<str> : Unit yang memuat fungsi-fungsi yang berkaitan dengan <str> bank
// sysutils : Agar bisa memakai fungsi waktu yang disediakan Pascal
// crt : Untuk clrscr

// ALGORITMA UTAMA PROGRAM
begin
  // Inisialisasi berbagai variabel
  for i := 1 to 8 do
  begin
    loadedFile[i] := '';
  end;
  currentuser.nonasabah := '';
  attempt := 3;

  writeln('Selamat datang di sistem bank XYZ!');
  writeln('Tanggal dan waktu sekarang adalah ',FormatDateTime('DD-MM-YYYY',Now)); // Menampilkan tanggal sekarang
  repeat
    write('XYZ > ');readln(cmd); // Menanyakan perintah
    if (not(cmd = 'exit')) then
    begin
      case cmd of // Ketika kode-kode yang bersangkutan sudah selesai, gantilah blok kode dibawah dengan yang relevan
        'load' : load();
        'login' : login();
        'informasirekening' : lihatdatarek();
        'informasisaldo' : infosaldo();
        'lihattransaksi' : lihattransaksi();
        'bukarekening' : writeln('bukarekening launched');
        'setor' : writeln('setor launched!');
        'tarik' : writeln('tarik launched!');
        'transfer' : writeln('transfer launched!');
        'pembayaran' : writeln('pembayaran launched!');
        'pembelian' : writeln('pembelian launched!');
        'tutuprekening' : writeln('tutuprekening launched!');
        'editnasabah' : writeln('editnasabah launched!');
        'tambahautodebet' : writeln('tambahautodebet launched!');
        'man' : writeln('man launched!'); // Gak ada di spek, nanti kalo udah kelar semua baru bikin manual (gampang sih ini sebenarnya...)
        'clear' : clrscr();
        else writeln('Error : Perintah ',cmd,' tidak terdefinisi!');
      end;
    end;
  until(cmd = 'exit');
  exit();
  writeln('Goodbye...');
end.
