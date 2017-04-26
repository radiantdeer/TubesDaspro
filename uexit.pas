unit uexit;
// Unit ini menyimpan semua fungsi dan prosedur yang berkaitan dengan penyimpanan file saat program keluar

interface

  uses banktype, sysutils;

  var
    ft : text;
    i : integer;

// List semua prosedur dan fungsi yang tersedia
  procedure savefilenasabah(fname : string; T : lnasabah);
  procedure savefilerekening(fname : string; T : lrekonline);
  procedure savefiletrans(fname : string; T : ltrans);
  procedure savefiletrf(fname : string; T : ltrf);
  procedure savefilepembayaran(fname : string; T : lpembayaran);
  procedure savefilepembelian(fname : string; T : lpembelian);
  procedure savefilekurs(fname : string; T : lkurs);
  procedure savefilebarang(fname : string; T : lbarang);
  { Untuk semua prosedur diatas, semuanya memliki spesifikasi yang hampir sama sebagai berikut :
    I.S. : Semua variabel parameter terdefinisi, T mungkin kosong, dan file fname sudah divalidasi di program utama
    F.S. : Jika T kosong, maka prosedur langsung keluar disertai pesan, jika T ada data, maka data akan dimasukkan ke file fname }

implementation

  procedure savefilenasabah(fname : string; T : lnasabah);

    begin
      if (T.Neff = 0) then writeln('Tidak ada data yang disimpan!') // Array kosong
      else
      begin
        assign(ft,fname);
        rewrite(ft);
        for i := 1 to T.Neff do // Bagian penulisan array ke file
        begin
          write(ft,T.list[i].nonasabah);
          write(ft,' | ');
          write(ft,T.list[i].nama);
          write(ft,' | ');
          write(ft,T.list[i].alamat);
          write(ft,' | ');
          write(ft,T.list[i].kota);
          write(ft,' | ');
          write(ft,T.list[i].email);
          write(ft,' | ');
          write(ft,T.list[i].telp);
          write(ft,' | ');
          write(ft,T.list[i].user);
          write(ft,' | ');
          write(ft,T.list[i].pass);
          write(ft,' | ');
          write(ft,T.list[i].stat);
          if (i <> T.Neff) then writeln(ft); // Pengecekan apabila sudah data terakhir, maka file tidak diberikan line break
        end;
        close(ft);
      end;
    end;

    // Karena semua prosedur ini memiliki runtutan proses yang sama, komentar untuk prosedur dibawah mengikuti komentar diatas

  procedure savefilerekening(fname : string; T : lrekonline);

    begin
      if (T.Neff = 0) then writeln('Tidak ada data yang disimpan!') // Array kosong
      else
      begin
        assign(ft,fname);
        rewrite(ft);
        for i := 1 to T.Neff do // Bagian penulisan array ke file
        begin
          write(ft,T.list[i].noakun);
          write(ft,' | ');
          write(ft,T.list[i].nonasabah);
          write(ft,' | ');
          write(ft,T.list[i].jenis);
          write(ft,' | ');
          write(ft,T.list[i].uang);
          write(ft,' | ');
          write(ft,FloatToStr(T.list[i].saldo)); // FloatToStr mengubah data real menjadi string, agar data bisa dimasukkan
          write(ft,' | ');
          write(ft,FloatToStr(T.list[i].setrutin));
          write(ft,' | ');
          write(ft,T.list[i].autodebet);
          write(ft,' | ');
          write(ft,T.list[i].waktu);
          write(ft,' | ');
          write(ft,T.list[i].tglmulai);
          if (i <> T.Neff) then writeln(ft);
        end;
        close(ft);
      end;
    end;

  procedure savefiletrans(fname : string; T : ltrans);

    begin
      if (T.Neff = 0) then writeln('Tidak ada data yang disimpan!')
      else
      begin
        assign(ft,fname);
        rewrite(ft);
        for i := 1 to T.Neff do
        begin
          write(ft,T.list[i].noakun);
          write(ft,' | ');
          write(ft,T.list[i].jenis);
          write(ft,' | ');
          write(ft,T.list[i].uang);
          write(ft,' | ');
          write(ft,FloatToStr(T.list[i].jumlah));
          write(ft,' | ');
          write(ft,FloatToStr(T.list[i].saldoakhir));
          write(ft,' | ');
          write(ft,T.list[i].tgl);
          if (i <> T.Neff) then writeln(ft);
        end;
        close(ft);
      end;
    end;

  procedure savefiletrf(fname : string; T : ltrf);

      begin
        if (T.Neff = 0) then writeln('Tidak ada data yang disimpan!')
        else
        begin
          assign(ft,fname);
          rewrite(ft);
          for i := 1 to T.Neff do
          begin
            write(ft,T.list[i].asal);
            write(ft,' | ');
            write(ft,T.list[i].tujuan);
            write(ft,' | ');
            write(ft,T.list[i].jenis);
            write(ft,' | ');
            write(ft,T.list[i].bank);
            write(ft,' | ');
            write(ft,T.list[i].uang);
            write(ft,' | ');
            write(ft,FloatToStr(T.list[i].jumlah));
            write(ft,' | ');
            write(ft,FloatToStr(T.list[i].saldoakhir));
            write(ft,' | ');
            write(ft,T.list[i].tgl);
            if (i <> T.Neff) then writeln(ft);
          end;
          close(ft);
        end;
      end;

  procedure savefilepembayaran(fname : string; T : lpembayaran);

    begin
      if (T.Neff = 0) then writeln('Tidak ada data yang disimpan!')
      else
      begin
        assign(ft,fname);
        rewrite(ft);
        for i := 1 to T.Neff do
        begin
          write(ft,T.list[i].noakun);
          write(ft,' | ');
          write(ft,T.list[i].jenis);
          write(ft,' | ');
          write(ft,T.list[i].nomorbayar);
          write(ft,' | ');
          write(ft,T.list[i].uang);
          write(ft,' | ');
          write(ft,FloatToStr(T.list[i].jumlah));
          write(ft,' | ');
          write(ft,FloatToStr(T.list[i].saldoakhir));
          write(ft,' | ');
          write(ft,T.list[i].tgl);
          if (i <> T.Neff) then writeln(ft);
        end;
        close(ft);
      end;
    end;

  procedure savefilepembelian(fname : string; T : lpembelian);

    begin
      if (T.Neff = 0) then writeln('Tidak ada data yang disimpan!')
      else
      begin
        assign(ft,fname);
        rewrite(ft);
        for i := 1 to T.Neff do
        begin
          write(ft,T.list[i].noakun);
          write(ft,' | ');
          write(ft,T.list[i].jenis);
          write(ft,' | ');
          write(ft,T.list[i].penyedia);
          write(ft,' | ');
          write(ft,T.list[i].nomortujuan);
          write(ft,' | ');
          write(ft,T.list[i].uang);
          write(ft,' | ');
          write(ft,FloatToStr(T.list[i].jumlah));
          write(ft,' | ');
          write(ft,FloatToStr(T.list[i].saldoakhir));
          write(ft,' | ');
          write(ft,T.list[i].tgl);
          if (i <> T.Neff) then writeln(ft);
        end;
        close(ft);
      end;
    end;

  procedure savefilekurs(fname : string; T : lkurs);

    begin
      if (T.Neff = 0) then writeln('Tidak ada data yang disimpan!')
      else
      begin
        assign(ft,fname);
        rewrite(ft);
        for i := 1 to T.Neff do
        begin
          write(ft,FloatToStr(T.list[i].nawal));
          write(ft,' | ');
          write(ft,T.list[i].awal);
          write(ft,' | ');
          write(ft,FloatToStr(T.list[i].nakhir));
          write(ft,' | ');
          write(ft,T.list[i].akhir);
          if (i <> T.Neff) then writeln(ft);
        end;
        close(ft);
      end;
    end;

  procedure savefilebarang(fname : string; T : lbarang);

    begin
      if (T.Neff = 0) then writeln('Tidak ada data yang disimpan!')
      else
      begin
        assign(ft,fname);
        rewrite(ft);
        for i := 1 to T.Neff do
        begin
          write(ft,T.list[i].jenis);
          write(ft,' | ');
          write(ft,T.list[i].penyedia);
          write(ft,' | ');
          write(ft,FloatToStr(T.list[i].harga));
          if (i <> T.Neff) then writeln(ft);
        end;
        close(ft);
      end;
    end;

end.
