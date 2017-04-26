Program InterfaceXYZ;
// Program utama yang menangani berbagai masukan dari user

uses uload, ulogin, banktype, uexit, sysutils, crt;
// u<str> : Unit yang memuat fungsi-fungsi yang berkaitan dengan <str> bank
// sysutils : Agar bisa memakai fungsi waktu yang disediakan Pascal
// crt : Untuk clrscr

{ KAMUS }
var
  cmd, fname, user, pass : string;
  { cmd : penampung masukan perintah dari user }
  ft : text;
  pil, attempt, i : integer; { attempt : menampung jumlah 'retries' yang tersisa jika user salah memasukan data saat login }
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
  // 1 : nama file nasabah, 2 : nama file rekening online, dst... (lihat urutan array diatas)
  loadedFile : array[1..8] of string;
  // Variabel menampung user yang sedang login sekarang
  currentuser : nasabah;

  procedure load();
    { Bagian utama yang menangani loading file, dengan memanggil subprogram yang sesuai untuk file tertentu }

    begin
      write('Load file : ');readln(fname); // Menanyakan file yang ingin dimuat
      if(FileExists(fname)) then // Pengecekan apakah file memang ada
        begin
          assign(ft,fname);
          reset(ft);
          // Menanyakan konten dari file ini
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
          repeat // Validasi input sampai benar
            write('Pilihan Anda (masukkan nomor pilihan, 0 untuk batal): ');readln(pil);
            if ((pil > 8) OR (pil < 0)) then writeln('Pilihan Anda salah!');
          until (not((pil > 8) OR (pil < 0)));
          case pil of // Memuat file sesuai masukan diatas.
          1 : begin
                loadallnasabah(ft, arrnasabah); // Pemanggilan subprogram yang sesuai
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
          if (pil <> 0) then writeln('Pembacaan file berhasil');
        end
      else { File tidak ada/ditemukan } writeln('Error : File ',fname,' tidak ditemukan!');
    end;

  procedure login();
    { Bagian utama yang menangani berbagai kondisi yang mungkin dialami saat akan login }

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

  procedure exit();
     { Pengecekan apakah suatu file telah diload sebelum program exit
       Jika file belum dimuat, maka tidak akan dipanggil fungsi untuk menyimpan kembali data }
    begin
      if(loadedFile[1] <> '') then // Jika ada, maka akan menyimpan data file nasabah
      begin
        writeln('Menyimpan data ke file ',loadedFile[1]);
        savefilenasabah(loadedFile[1],arrnasabah);
      end;
      if(loadedFile[2] <> '') then // Jika ada, maka akan menyimpan data file rekening online
      begin
        writeln('Menyimpan data ke file ',loadedFile[2]);
        savefilerekening(loadedFile[2],arrrekonline);
      end;
      if(loadedFile[3] <> '') then // Jika ada, maka akan menyimpan data file histori transaksi
      begin
        writeln('Menyimpan data ke file ',loadedFile[3]);
        savefiletrans(loadedFile[3],arrtransaksi);
      end;
      if(loadedFile[4] <> '') then // Jika ada, maka akan menyimpan data file histori transfer
      begin
        writeln('Menyimpan data ke file ',loadedFile[4]);
        savefiletrf(loadedFile[4],arrtransfer);
      end;
      if(loadedFile[5] <> '') then // Jika ada, maka akan menyimpan data file histori pembayaran
      begin
        writeln('Menyimpan data ke file ',loadedFile[5]);
        savefilepembayaran(loadedFile[5],arrbayar);
      end;
      if(loadedFile[6] <> '') then // Jika ada, maka akan menyimpan data file histori pembelian
      begin
        writeln('Menyimpan data ke file ',loadedFile[6]);
        savefilepembelian(loadedFile[6],arrbeli);
      end;
      if(loadedFile[7] <> '') then // Jika ada, maka akan menyimpan data file kurs
      begin
        writeln('Menyimpan data ke file ',loadedFile[7]);
        savefilekurs(loadedFile[7],arrkurs);
      end;
      if(loadedFile[8] <> '') then // Jika ada, maka akan menyimpan data file daftar barang yang tersedia
      begin
        writeln('Menyimpan data ke file ',loadedFile[8]);
        savefilebarang(loadedFile[8],arrbarang);
      end;
    end;

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
  exit();
  writeln('Goodbye...');
end.
