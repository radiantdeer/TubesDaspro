Program InterfaceXYZ;
// Program utama yang menangani berbagai masukan dari user

uses uload, ulogin, banktype, sysutils, crt;
// u<str> : Unit yang memuat fungs-fungsi yang berkaitan dengan <str> bank
// sysutils : Agar bisa memakai fungsi waktu yang disediakan Pascal
// crt : Untuk clrscr

{ KAMUS }
var
  cmd, fname, user, pass : string;
  ft : text;
  pil : integer;
  // Variabel dibawah adalah variabel pendukung data internal bank
  arrnasabah : lnasabah;
  arrrekonline : lrekonline;
  arrtransaksi : ltrans;
  arrtransfer : ltrf;
  arrbayar : lpembayaran;
  arrbeli : lpembelian;
  arrkurs : lkurs;
  arrbarang : lbarang;

begin
  writeln('Selamat datang di sistem bank XYZ!');
  writeln('Tanggal dan waktu sekarang adalah ',DateTimeToStr(Now));
  repeat
    write('XYZ > ');readln(cmd);
    if (not(cmd = 'exit')) then
    begin
      case cmd of // Ketika kode-kode yang bersangkutan sudah selesai, gantilah blok kode dibawah dengan yang relevan
        'load' : begin
                  write('Load file : ');readln(fname);
                  if(FileExists(fname)) then
                    begin
                      assign(ft,fname);
                      reset(ft);
                      writeln('Jenis file apa ini?');
                      writeln('1. Data Nasabah');
                      writeln('2. Data Rekening Online');
                      writeln('3. Data Histori Transaksi');
                      writeln('4. Data Histori Transfer');
                      writeln('5. Data Histori Pembayaran');
                      writeln('6. Data Histori Pembelian');
                      writeln('7. Data Kurs Mata Uang');
                      writeln('8. Data Barang');
                      writeln('----------------------------------------------------');
                      repeat
                        write('Pilihan Anda (masukkan nomor pilihan, 0 untuk batal): ');readln(pil);
                        if ((pil > 8) OR (pil < 0)) then writeln('Pilihan Anda salah!');
                      until (not((pil > 8) OR (pil < 0)));
                      case pil of
                      1 : loadallnasabah(ft, arrnasabah);
                      2 : loadallrekonline(ft, arrrekonline);
                      3 : loadalltransaksi(ft, arrtransaksi);
                      4 : loadalltransfer(ft, arrtransfer);
                      5 : loadallbayar(ft, arrbayar);
                      6 : loadallbeli(ft, arrbeli);
                      7 : loadallkurs(ft, arrkurs);
                      8 : loadallbarang(ft, arrbarang);
                      0 : writeln('Batal load file.');
                      end;
                      close(ft);
                    end
                  else writeln('Error : File ',fname,' tidak ditemukan!');
                 end;
        'login' : begin
                    write('Username : ');readln(user);
                    write('Password : ');readln(pass);
                    login(user,pass);
                  end;
        'informasirekening' : writeln('informasirekening launched!');
        'informasisaldo' : writeln('informasisaldo launched!');
        'lihattransaksi' : writeln('lihattransaksi launched!');
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
        else writeln('Error : Command ',cmd,' not defined! See man for list of available commands');
      end;
    end;
  until(cmd = 'exit');
  writeln('Goodbye...');
end.
