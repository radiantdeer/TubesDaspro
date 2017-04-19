unit uload;

interface

  uses sysutils, banktype; // banktype mengandung deklarasi tipe-tipe yang akan dipakai

// Variabel pendukung data internal
  var
    arrnasabah : lnasabah;
    arrrekonline : lrekonline;
    arrtransaksi : ltrans;
    arrtransfer : ltrf;
    arrbayar : lpembayaran;
    arrbeli : lpembelian;
    arrkurs : lkurs;
    arrbarang : lbarang;

// Daftar semua fungsi dan prosedur yang tersedia di unit ini
procedure loadFile(fname : string);
procedure loadallnasabah(var f : text);
procedure loadallrekonline(var f : text);
procedure loadalltransaksi(var f : text);
procedure loadalltransfer(var f : text);
procedure loadallbayar(var f : text);
procedure loadallbeli(var f : text);
procedure loadallkurs(var f : text);
procedure loadallbarang(var f : text);
procedure testTulis(); // Prosedur hanya untuk debugging saja

implementation

  procedure loadFile(fname : string);
  var
    ft : text;
    pil : integer;

  begin
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
      1 : loadallnasabah(ft);
      2 : loadallrekonline(ft);
      3 : loadalltransaksi(ft);
      4 : loadalltransfer(ft);
      5 : loadallbayar(ft);
      6 : loadallbeli(ft);
      7 : loadallkurs(ft);
      8 : loadallbarang(ft);
      0 : writeln('Batal load file.');
      end;
      close(ft);
    end else writeln('Error : File ',fname,' tidak ditemukan!');
  end;

  procedure loadallnasabah(var f : text);
    var
      s : string;
      c : char;
      i, j : integer;

    begin
      s := '';
      i := 1;
      j := 1;
      writeln('Loading data to memory...');
      while (not(EOF(f))) do
      begin
        read(f,c);
        while ((c <> Chr(10)) AND (not(EOF(f)))) do // Chr(10) converts the ASCII code of 10 to the line ending/ENTER
        begin
          if (c = '|') then
          begin
            if ((j mod 9) = 1) then delete(s,length(s),1)
            else
            begin
              delete(s,length(s),1);
              delete(s,1,1);
            end;
            case (j mod 9) of
            1 : arrnasabah.list[i].nonasabah := s;
            2 : arrnasabah.list[i].nama := s;
            3 : arrnasabah.list[i].alamat := s;
            4 : arrnasabah.list[i].kota := s;
            5 : arrnasabah.list[i].email := s;
            6 : arrnasabah.list[i].telp := s;
            7 : arrnasabah.list[i].user := s;
            8 : arrnasabah.list[i].pass := s;
            // Kasus j mod 9 = 0 tidak akan pernah masuk ke bagian if ini, karena tidak pernah bertemu '|'.
            end;
            s := '';
            j := j + 1;
          end else s := s + c;
          read(f,c);
          if (c = Chr(10)) then // Catching the last element of the data
          begin
            delete(s,1,1);
            arrnasabah.list[i].stat := s;
            s := '';
            j := j + 1;
          end;
          if (EOF(f)) then // This will fix the issue that the last character always get cut
          begin
            delete(s,1,1);
            arrnasabah.list[i].stat := s + c;
            s := '';
            j := j + 1;
          end;
        end;
        i := i + 1;
        write('+');
        s := '';
      end;
      writeln();
      arrnasabah.Neff := i-1;
    end;

  procedure loadallrekonline(var f : text);
    var
        s : string;
        c : char;
        i, j : integer;

    begin
        s := '';
        i := 1;
        j := 1;
        writeln('Loading data to memory...');
        while (not(EOF(f))) do
        begin
          read(f,c);
          while ((c <> Chr(10)) AND (not(EOF(f)))) do // Chr(10) converts the ASCII code of 10 to the line ending/ENTER
          begin
            if (c = '|') then
            begin
              if ((j mod 9) = 1) then delete(s,length(s),1)
              else
              begin
                delete(s,length(s),1);
                delete(s,1,1);
              end;
              case (j mod 9) of
              1 : arrrekonline.list[i].noakun := s;
              2 : arrrekonline.list[i].nonasabah := s;
              3 : arrrekonline.list[i].jenis := s;
              4 : arrrekonline.list[i].uang := s;
              5 : arrrekonline.list[i].saldo := StrToFloat(s);
              6 : arrrekonline.list[i].setrutin := StrToFloat(s);
              7 : arrrekonline.list[i].autodebet := s;
              8 : arrrekonline.list[i].waktu := s;
              // Kasus j mod 9 = 0 tidak akan pernah masuk ke bagian if ini, karena tidak pernah bertemu '|'.
              end;
              s := '';
              j := j + 1;
            end else s := s + c;
            read(f,c);
            if (c = Chr(10)) then // Catching the last element of the data
            begin
              delete(s,1,1);
              arrrekonline.list[i].tglmulai := s;
              s := '';
              j := j + 1;
            end;
            if (EOF(f)) then // This will fix the issue that the last character always get cut
            begin
              delete(s,1,1);
              arrrekonline.list[i].tglmulai := s + c;
              s := '';
            end;
          end;
          i := i + 1;
          write('+');
          s := '';
        end;
        writeln();
        arrrekonline.Neff := i-1;
    end;

  procedure loadalltransaksi(var f : text);
    var
        i, j : integer;
        s : string;
        c : char;

    begin
        s := '';
        i := 1;
        j := 1;
        writeln('Loading data to memory...');
        while (not(EOF(f))) do
        begin
          read(f,c);
          while ((c <> Chr(10)) AND (not(EOF(f)))) do // Chr(10) converts the ASCII code of 10 to the line ending/ENTER
          begin
            if (c = '|') then
            begin
              if ((j mod 6) = 1) then delete(s,length(s),1)
              else
              begin
                delete(s,length(s),1);
                delete(s,1,1);
              end;
              case (j mod 6) of
              1 : arrtransaksi.list[i].noakun := s;
              2 : arrtransaksi.list[i].jenis := s;
              3 : arrtransaksi.list[i].uang := s;
              4 : arrtransaksi.list[i].jumlah := StrToFloat(s);
              5 : arrtransaksi.list[i].saldoakhir := StrToFloat(s);
              // Kasus j mod 6 = 0 tidak akan pernah masuk ke bagian analisis kasus ini, karena tidak pernah bertemu '|'.
              end;
              s := '';
              j := j + 1;
            end else s := s + c;
            read(f,c);
            if (c = Chr(10)) then // Catching the last element of the data
            begin
              delete(s,1,1);
              arrtransaksi.list[i].tgl := s;
              s := '';
              j := j + 1;
            end;
            if (EOF(f)) then // This will fix the issue that the last character always get cut
            begin
              delete(s,1,1);
              arrtransaksi.list[i].tgl := s + c;
              s := '';
            end;
          end;
          i := i + 1;
          write('+');
          s := '';
        end;
        writeln();
        arrtransaksi.Neff := i-1;
        testTulis();
    end;

  procedure loadalltransfer(var f : text);
    var
        i, j : integer;
        s : string;
        c : char;

    begin
        s := '';
        i := 1;
        j := 1;
        writeln('Loading data to memory...');
        while (not(EOF(f))) do
        begin
          read(f,c);
          while ((c <> Chr(10)) AND (not(EOF(f)))) do // Chr(10) converts the ASCII code of 10 to the line ending/ENTER
          begin
            if (c = '|') then
            begin
              if ((j mod 8) = 1) then delete(s,length(s),1)
              else
              begin
                delete(s,length(s),1);
                delete(s,1,1);
              end;
              case (j mod 8) of
              1 : arrtransfer.list[i].asal := s;
              2 : arrtransfer.list[i].tujuan := s;
              3 : arrtransfer.list[i].jenis := s;
              4 : arrtransfer.list[i].bank:= s;
              5 : arrtransfer.list[i].uang := s;
              6 : arrtransfer.list[i].jumlah := StrToFloat(s);
              7 : arrtransfer.list[i].saldoakhir := StrToFloat(s);
              // Kasus j mod 8 = 0 tidak akan pernah masuk ke bagian analisis kasus ini, karena tidak pernah bertemu '|'.
              end;
              s := '';
              j := j + 1;
            end else s := s + c;
            read(f,c);
            if (c = Chr(10)) then // Catching the last element of the data
            begin
              delete(s,1,1);
              arrtransfer.list[i].tgl := s;
              s := '';
              j := j + 1;
            end;
            if (EOF(f)) then // This will fix the issue that the last character always get cut
            begin
              delete(s,1,1);
              arrtransfer.list[i].tgl := s + c;
              s := '';
            end;
          end;
          i := i + 1;
          write('+');
          s := '';
        end;
        writeln();
        arrtransfer.Neff := i-1;
    end;

  procedure loadallbayar(var f : text);
    var
        i, j : integer;
        s : string;
        c : char;

    begin
        s := '';
        i := 1;
        j := 1;
        writeln('Loading data to memory...');
        while (not(EOF(f))) do
        begin
          read(f,c);
          while ((c <> Chr(10)) AND (not(EOF(f)))) do // Chr(10) converts the ASCII code of 10 to the line ending/ENTER
          begin
            if (c = '|') then
            begin
              if ((j mod 7) = 1) then delete(s,length(s),1)
              else
              begin
                delete(s,length(s),1);
                delete(s,1,1);
              end;
              case (j mod 7) of
              1 : arrbayar.list[i].noakun := s;
              2 : arrbayar.list[i].jenis := s;
              3 : arrbayar.list[i].nomorbayar := s;
              4 : arrbayar.list[i].uang := s;
              5 : arrbayar.list[i].jumlah := StrToFloat(s);
              6 : arrbayar.list[i].saldoakhir := StrToFloat(s);
              // Kasus j mod 7 = 0 tidak akan pernah masuk ke bagian analisis kasus ini, karena tidak pernah bertemu '|'.
              end;
              s := '';
              j := j + 1;
            end else s := s + c;
            read(f,c);
            if (c = Chr(10)) then // Catching the last element of the data
            begin
              delete(s,1,1);
              arrbayar.list[i].tgl := s;
              s := '';
              j := j + 1;
            end;
            if (EOF(f)) then // This will fix the issue that the last character always get cut
            begin
              delete(s,1,1);
              arrbayar.list[i].tgl := s + c;
              s := '';
            end;
          end;
          i := i + 1;
          write('+');
          s := '';
        end;
        writeln();
        arrbayar.Neff := i-1;
    end;

  procedure loadallbeli(var f : text);
    var
        i, j : integer;
        s : string;
        c : char;

    begin
        s := '';
        i := 1;
        j := 1;
        writeln('Loading data to memory...');
        while (not(EOF(f))) do
        begin
          read(f,c);
          while ((c <> Chr(10)) AND (not(EOF(f)))) do // Chr(10) converts the ASCII code of 10 to the line ending/ENTER
          begin
            if (c = '|') then
            begin
              if ((j mod 8) = 1) then delete(s,length(s),1)
              else
              begin
                delete(s,length(s),1);
                delete(s,1,1);
              end;
              case (j mod 8) of
              1 : arrbeli.list[i].noakun := s;
              2 : arrbeli.list[i].jenis := s;
              3 : arrbeli.list[i].penyedia := s;
              4 : arrbeli.list[i].nomortujuan := s;
              5 : arrbeli.list[i].uang := s;
              6 : arrbeli.list[i].jumlah := StrToFloat(s);
              7 : arrbeli.list[i].saldoakhir := StrToFloat(s);
              // Kasus j mod 7 = 0 tidak akan pernah masuk ke bagian analisis kasus ini, karena tidak pernah bertemu '|'.
              end;
              s := '';
              j := j + 1;
            end else s := s + c;
            read(f,c);
            if (c = Chr(10)) then // Catching the last element of the data
            begin
              delete(s,1,1);
              arrbeli.list[i].tgl := s;
              s := '';
              j := j + 1;
            end;
            if (EOF(f)) then // This will fix the issue that the last character always get cut
            begin
              delete(s,1,1);
              arrbeli.list[i].tgl := s + c;
              s := '';
            end;
          end;
          i := i + 1;
          write('+');
          s := '';
        end;
        writeln();
        arrbeli.Neff := i-1;
    end;

  procedure loadallkurs(var f : text);
    var
        i, j : integer;
        s : string;
        c : char;

    begin
        s := '';
        i := 1;
        j := 1;
        writeln('Loading data to memory...');
        while (not(EOF(f))) do
        begin
          read(f,c);
          while ((c <> Chr(10)) AND (not(EOF(f)))) do // Chr(10) converts the ASCII code of 10 to the line ending/ENTER
          begin
            if (c = '|') then
            begin
              if ((j mod 4) = 1) then delete(s,length(s),1)
              else
              begin
                delete(s,length(s),1);
                delete(s,1,1);
              end;
              case (j mod 4) of
              1 : arrkurs.list[i].nawal := StrToFloat(s);
              2 : arrkurs.list[i].awal := s;
              3 : arrkurs.list[i].nakhir := StrToFloat(s);
              // Kasus j mod 7 = 0 tidak akan pernah masuk ke bagian analisis kasus ini, karena tidak pernah bertemu '|'.
              end;
              s := '';
              j := j + 1;
            end else s := s + c;
            read(f,c);
            if (c = Chr(10)) then // Catching the last element of the data
            begin
              delete(s,1,1);
              arrkurs.list[i].akhir := s;
              s := '';
              j := j + 1;
            end;
            if (EOF(f)) then // This will fix the issue that the last character always get cut
            begin
              delete(s,1,1);
              arrkurs.list[i].akhir := s + c;
              s := '';
            end;
          end;
          i := i + 1;
          write('+');
          s := '';
        end;
        writeln();
        arrkurs.Neff := i-1;
    end;

  procedure loadallbarang(var f : text);
    var
        i, j : integer;
        s : string;
        c : char;

    begin
        s := '';
        i := 1;
        j := 1;
        writeln('Loading data to memory...');
        while (not(EOF(f))) do
        begin
          read(f,c);
          while ((c <> Chr(10)) AND (not(EOF(f)))) do // Chr(10) converts the ASCII code of 10 to the line ending/ENTER
          begin
            if (c = '|') then
            begin
              if ((j mod 3) = 1) then delete(s,length(s),1)
              else
              begin
                delete(s,length(s),1);
                delete(s,1,1);
              end;
              case (j mod 3) of
              1 : arrbarang.list[i].jenis := s;
              2 : arrbarang.list[i].penyedia := s;
              // Kasus j mod 7 = 0 tidak akan pernah masuk ke bagian analisis kasus ini, karena tidak pernah bertemu '|'.
              end;
              s := '';
              j := j + 1;
            end else s := s + c;
            read(f,c);
            if (c = Chr(10)) then // Catching the last element of the data
            begin
              delete(s,1,1);
              arrbarang.list[i].harga := StrToFloat(s);
              s := '';
              j := j + 1;
            end;
            if (EOF(f)) then // This will fix the issue that the last character always get cut
            begin
              delete(s,1,1);
              arrbarang.list[i].harga := StrToFloat(s + c);
              s := '';
            end;
          end;
          i := i + 1;
          write('+');
          s := '';
        end;
        writeln();
        arrbarang.Neff := i-1;
        testTulis();
    end;

  procedure testTulis(); // Fungsi ini hanya untuk debugging saja
    var
        i : integer;

    begin
        for i := 1 to arrbarang.Neff do
        begin
          writeln(arrbarang.list[i].jenis);
          writeln(arrbarang.list[i].penyedia);
          writeln(arrbarang.list[i].harga:0:2);
          writeln();
        end;
    end;
end.
