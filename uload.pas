unit uload;

interface

  uses sysutils, banktype; // banktype mengandung deklarasi tipe-tipe yang akan dipakai

// Variabel pendukung data internal
  var
    arrnasabah : lnasabah;

// Daftar semua fungsi dan prosedur yang tersedia di unit ini
procedure loadFile(fname : string);
procedure loadallnasabah(var f : text);

implementation

  procedure loadFile(fname : string);
  var
    ft : text;

  begin
    if(FileExists(fname)) then
    begin
      assign(ft,fname);
      reset(ft);
      if (fname = 'nasabah.txt') then
      begin
          loadallnasabah(ft);
      end;
      close(ft);
      writeln('File berhasil dimuat!');
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
          end;
        end;
        i := i + 1;
        write('+');
        s := '';
      end;
      writeln();
      arrnasabah.Neff := i-1;
    end;

end.
