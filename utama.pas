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
  pil, attempt, i : integer;
  // Variabel dibawah adalah variabel pendukung data internal bank
  arrnasabah : lnasabah;
  arrrekonline : lrekonline;
  arrtransaksi : ltrans;
  arrtransfer : ltrf;
  arrbayar : lpembayaran;
  arrbeli : lpembelian;
  arrkurs : lkurs;
  arrbarang : lbarang;

  // Array untuk menampung nama file apa saja yang sudah dimuat ke array internal
  // 1 : file nasabah, 2 : file rekening online, dst... (lihat urutan array diatas)
  loadedFile : array[1..8] of string;
  // Variabel menampung user yang sedang login sekarang
  currentuser : nasabah;

begin
  // Inisialisasi berbagai variabel
  for i := 1 to 8 do
  begin
    loadedFile[i] := '';
  end;
  currentuser.nonasabah := '';
  attempt := 3;

  writeln('Selamat datang di sistem bank XYZ!');
  writeln('Tanggal dan waktu sekarang adalah ',DateTimeToStr(Now));
  repeat
    write('XYZ > ');readln(cmd); // Menanyakan perintah
    if (not(cmd = 'exit')) then
    begin
      case cmd of // Ketika kode-kode yang bersangkutan sudah selesai, gantilah blok kode dibawah dengan yang relevan
        'load' : begin
                  write('Load file : ');readln(fname); // Menanyakan file yang ingin dimuat
                  if(FileExists(fname)) then // Pengecekan apakah file memang ada
                    begin
                      assign(ft,fname);
                      reset(ft);
                      // Menanyakan file ini jenis apa
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
                      case pil of // Memuat file sesuai masukan diatas. Belum ada validasi format file
                      1 : begin
                            loadallnasabah(ft, arrnasabah);
                            loadedFile[1] := fname; // Marker bahwa data suatu file telah dimuat ke dalam array
                          end;
                      2 : begin
                            loadallrekonline(ft, arrrekonline);
                            loadedFile[2] := fname;
                          end;
                      3 : begin
                            loadalltransaksi(ft, arrtransaksi);
                            loadedFile[3] := fname;
                          end;
                      4 : begin
                            loadalltransfer(ft, arrtransfer);
                            loadedFile[4] := fname;
                          end;
                      5 : begin
                            loadallbayar(ft, arrbayar);
                            loadedFile[5] := fname;
                          end;
                      6 : begin
                            loadallbeli(ft, arrbeli);
                            loadedFile[6] := fname;
                          end;
                      7 : begin
                            loadallkurs(ft, arrkurs);
                            loadedFile[7] := fname;
                          end;
                      8 : begin
                            loadallbarang(ft, arrbarang);
                            loadedFile[8] := fname;
                          end;
                      0 : writeln('Batal load file.');
                      end;
                      close(ft);
                    end
                  else { File tidak ada/ditemukan } writeln('Error : File ',fname,' tidak ditemukan!');
                 end;
        'login' : begin
                    if(loadedFile[1] <> '') then // Mengecek apakah data nasabah sudah dimuat atau belum.
                    begin
                      if(currentuser.nonasabah = '') then // Mengecek apakah pengguna sudah login sebelumnya
                      begin
                        write('Username : ');readln(user);
                        write('Password : ');readln(pass);
                        i := login(user,pass,arrnasabah);
                        if (i <> 0) then
                        begin
                          currentuser := arrnasabah.list[i];
                          writeln('Login berhasil. Selamat datang ',user,'!');
                        end
                        else
                        begin
                          attempt := attempt - 1;
                          if (attempt = 0) then
                          begin
                            writeln('Anda telah salah login 3 kali berturut-turut!');
                            writeln('Program akan keluar...');
                            if (i <> 0) then arrnasabah.list[i].stat := 'inaktif';
                            cmd := 'exit';
                          end else
                          begin
                            writeln('Username/password salah. Coba lagi!');
                            writeln('Anda hanya memiliki ',attempt,' kesempatan lagi!');
                          end;
                        end;
                      end else { Sudah ada yang login, karena currentuser.nonasabah tidak kosong/''}
                      begin
                        writeln('Anda sudah login!');
                      end;
                    end else { File data nasabah belum diload }
                    begin
                      writeln('Data nasabah belum dimuat!');
                      writeln('Masukkan data nasabah terlebih dahulu dengan menggunakan perintah "load".');
                    end;
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
        else writeln('Error : Perintah ',cmd,' tidak terdefinisi!');
      end;
    end;
  until(cmd = 'exit');
  // exit(); Nanti kalau sudah diimplementasikan
  writeln('Goodbye...');
end.
