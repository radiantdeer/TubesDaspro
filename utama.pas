Program InterfaceXYZ;
// Program utama yang menangani berbagai masukan dari user

uses uload, ulogin, ulihatrek, utransaksi, uexit, banktype, sysutils, crt;
// u<str> : Unit yang memuat fungsi-fungsi yang berkaitan dengan <str> bank
// sysutils : Agar bisa memakai fungsi waktu yang disediakan Pascal
// crt : Untuk clrscr

function isCmdExecutable() : boolean;
{ Mengecek apakah :
  * File/Data rekening online ada (data array tidak kosong)
  * Ada user yang sudah login
  Jika kedua kondisi diatas dipenuhi, fungsi mengembalikan true }
begin
  isCmdExecutable := NOT(((loadedFile[2] = '') OR (arrrekonline.Neff = 0)) OR (currentuser.nonasabah = ''));
end;

// ALGORITMA UTAMA PROGRAM
begin
  // Inisialisasi berbagai variabel pendukung telah dilakukan di unit banktype
  writeln('Selamat datang di sistem bank XYZ!');
  writeln('Tanggal dan waktu sekarang adalah ',FormatDateTime('DD-MM-YYYY',Now)); // Menampilkan tanggal sekarang
  repeat
    write('XYZ > ');readln(cmd); // Menanyakan perintah
    if (not(cmd = 'exit')) then
    begin
      case cmd of // Ketika kode-kode yang bersangkutan sudah selesai, gantilah blok kode dibawah dengan yang relevan
        'load' : load();
        'login' : login();
        'informasirekening' : begin
                                if (isCmdExecutable()) then
                                  lihatdatarek()
                                else
                                  writeln('Data rekening kosong atau user belum login!');
                              end;
        'informasisaldo' : begin
                              if (isCmdExecutable()) then
                                infosaldo()
                              else
                                writeln('Data rekening kosong atau user belum login!');
                           end;
        'lihattransaksi' : begin
                            if (isCmdExecutable()) then
                              lihattransaksi()
                            else
                              writeln('Data rekening kosong atau user belum login!');
                           end;
        'bukarekening' : writeln('bukarekening launched');
        'setor' : begin
                    if (isCmdExecutable()) then
                      setoran()
                    else
                      writeln('Data rekening kosong atau user belum login!');
                  end;
        'tarik' : begin
                    if (isCmdExecutable()) then
                      penarikan()
                    else
                      writeln('Data rekening kosong atau user belum login!');
                  end;
        'transfer' : begin
                      if (isCmdExecutable() and not(loadedFile[7] = '')) then
                        transfer()
                      else 
                        writeln('Data pendukung tidak memadai atau user belum login!');
                     end;
        'pembayaran' : writeln('pembayaran launched!');
        'pembelian' : writeln('pembelian launched!');
        'tutuprekening' : writeln('tutuprekening launched!');
        'editnasabah' : writeln('editnasabah launched!');
        'tambahautodebet' : writeln('tambahautodebet launched!');
        'man' : writeln('man launched!'); // Gak ada di spek, nanti kalo udah kelar semua baru bikin manual (gampang sih ini sebenarnya...)
        'clear' : clrscr(); // Untuk membersihkan tampilan
        else writeln('Error : Perintah ',cmd,' tidak terdefinisi!');
      end;
    end;
  until(cmd = 'exit');
  exit();
  writeln('Goodbye...');
end.
