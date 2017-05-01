Program InterfaceXYZ;
// Program utama yang menangani berbagai masukan dari user

uses uload, ulogin, ututup, ulihatrek, utransaksi, uadminnasabah, utampilanpengguna, uexit, banktype, sysutils, crt;
// u<str> : Unit yang memuat fungsi-fungsi yang berkaitan dengan <str> bank
// sysutils : Agar bisa memakai fungsi waktu yang disediakan Pascal
// crt : Untuk clrscr

function isCmdExecutable() : boolean;
{ Mengecek apakah :
  * File/Data rekening online ada (data array tidak kosong)
  * Ada user yang sudah login. Bila user sudah login, sudah dipastikan bahwa data nasabah ada
  Jika kedua kondisi diatas dipenuhi, fungsi mengembalikan true }
begin
  isCmdExecutable := NOT(((loadedFile[2] = '') OR (arrrekonline.Neff = 0)) OR (currentuser.nonasabah = ''));
end;

// ALGORITMA UTAMA PROGRAM
begin
  // Inisialisasi berbagai variabel pendukung telah dilakukan di unit banktype
  writeln('Selamat datang di sistem bank XYZ!');
  writeln('Tanggal sekarang adalah ',FormatDateTime('DD-MM-YYYY',Now)); // Menampilkan tanggal sekarang
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
        'bukarekening' : begin
							if (isCmdExecutable()) then
								BukaRekening()
							else
								writeln('Data rekening kosong atau user belum login!');
						 end;
								
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
        'pembayaran' : begin
						if(isCmdExecutable() ) then
							bayarya()
						else
							writeln('Data pendukung tidak memadai atau user belum login!');
						end;
        'pembelian' : begin
                        if (isCmdExecutable() and not(loadedFile[7] = '') and not(loadedFile[8] = '')) then
                          menu_pembelian()
                        else
                          writeln('Data pendukung tidak memadai atau user belum login!');
                      end;
        'tutuprekening' : begin
							if (isCmdExecutable()) then
							tutuprek();
							else
							writeln('Data pendukung tidak memadai atau user belum login!');
						end;
		'editnasabah' : begin
                          if(NOT(currentuser.nonasabah = '')) then
                            editnasabah()
                          else
                            writeln('Data pendukung tidak memadai atau user belum login!');
                        end;
        'tambahautodebet' : begin
                          if(NOT(currentuser.nonasabah = '')) then
                            gantiautodebet()
                          else
                            writeln('Data pendukung tidak memadai atau user belum login!');
                        end;
        'clear' : clrscr(); // Untuk membersihkan tampilan
        else writeln('Error : Perintah ',cmd,' tidak terdefinisi!');
      end;
    end;
  until(cmd = 'exit');
  exit();
  writeln('Goodbye...');
end.
