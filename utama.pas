Program InterfaceXYZ;
// Program utama yang menangani berbagai masukan dari user

uses ubank, sysutils, crt; 
// ubank : Unit yang memuat berbagai fungsi-fungsi bank
// sysutils : Agar bisa memakai fungsi waktu yang disediakan Pascal
// crt : Untuk clrscr

{ KAMUS }
var
  cmd, s : string;

begin
  writeln('Selamat datang di sistem bank XYZ!');
  writeln('Tanggal dan waktu sekarang adalah ',DateTimeToStr(Now));
  repeat
    write('XYZ > ');readln(cmd);
    if (not(cmd = 'exit')) then 
    begin
      case cmd of // Ketika kode-kode yang bersangkutan sudah selesai, gantilah blok kode dibawah dengan yang relevan
        'load' : begin
                  write('Load file : ');readln(s);
                  loadFile(s);
                 end;
        'login' : writeln('Login launched!');
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