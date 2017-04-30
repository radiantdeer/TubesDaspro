Program Penarikan;
{ Menarik sejumlah uang secara tunai dari suatu rekening tertentu }

uses sysutils, dateutils, banktype;

{ Kamus }
var
	arrrekonline : lrekonline;
	arrtransaksi : ltrans;
	tempArray : array [1..50] of string;
	currentuser : nasabah;
	jenis : string;
	jenisRek : integer;
	noAk : string;
	jumlahTarik : real;
	stop, found, success : boolean;
	N : integer;
	i : integer; { Iterasi }

function SudahJatuhTempo (rekonline : rekonline) : boolean;
{ Menghasilkan true jika telah memenuhi waktu jatuh tempo dan false jika
  belum memenuhi waktu jatuh tempo }
{ Waktu jatuh tempo dihitung dari tanggal pembuatan rekening ke jangka 
  waktu yang ditentukan untuk rekening tersebut }
{ Kamus }
var
	tanggalMulai, jatuhTempo : TDateTime;
	cmd : integer;
	date, month, year : string;
	dd, mm, yy : integer;
{ Algoritma }
begin
	date:=copy(rekonline.tglmulai,1,2);
	month:=copy(rekonline.tglmulai,4,2);
	year:=copy(rekonline.tglmulai,7,4);
	val(date,dd);
	val(month,mm);
	val(year,yy);
	tanggalMulai:=EncodeDate(yy,mm,dd);
	case rekonline.waktu of
		'1 bulan' : begin
						jatuhTempo:=IncMonth(tanggalMulai,1);
					end;
		'3 bulan' : begin
						jatuhTempo:=IncMonth(tanggalMulai,3);
					end;
		'6 bulan' : begin
						jatuhTempo:=IncMonth(tanggalMulai,6);
					end;
		'1 tahun' : begin
						jatuhTempo:=IncMonth(tanggalMulai,12);
					end;
	end;
	cmd:=CompareDate(jatuhTempo,Now);
	SudahJatuhTempo:=cmd<=0;
end;
	
{ Algoritma }
begin
	writeln('> Pilih jenis rekening:');
	writeln('> 1. Deposito');
	writeln('> 2. Tabungan rencana');
	writeln('> 3. Tabungan mandiri');
	{ Validasi masukan jenis rekening }
	{ Pengulangan akan berhenti jika pengguna memasukkan jenis rekening 
	  yang tepat, yaitu 1, 2, atau 3 }
	stop:=false;
	repeat
		write('> Jenis rekening : ');
		readln(jenisRek);
		if (jenisRek=1) or (jenisRek=2) or (jenisRek=3) then
			stop:=true
		else
			writeln('> Jenis rekening yang Anda masukkan salah!');
	until stop;
	{ Mendaftarkan nomor akun rekening-rekening milik pengguna ke array 
	  tempArray sesuai dengan masukan jenis rekening }
	{ N adalah banyaknya rekening milik pengguna dengan jenis tertentu
	  sesuai masukan pengguna }
	if (jenisRek=1) then
	begin
		jenis:='deposito';
		N:=0;
		for i:=1 to arrrekonline.Neff do
		begin
			if (arrrekonline.list[i].nonasabah=currentuser.nonasabah) and (arrrekonline.list[i].jenis=jenis) then
			begin
				N:=N+1;
				tempArray[N]:=arrrekonline.list[i].noakun;
			end;
		end;
	end else if (jenisRek=2) then
	begin
		jenis:='tabungan rencana';
		N:=0;
		for i:=1 to arrrekonline.Neff do
		begin
			if (arrrekonline.list[i].nonasabah=currentuser.nonasabah) and (arrrekonline.list[i].jenis=jenis) then
			begin
				N:=N+1;
				tempArray[N]:=arrrekonline.list[i].noakun;
			end;
		end;
	end else
	begin
		jenis:='tabungan mandiri';
		N:=0;
		for i:=1 to arrrekonline.Neff do
		begin
			if (arrrekonline.list[i].nonasabah=currentuser.nonasabah) and (arrrekonline.list[i].jenis=jenis) then
			begin
				N:=N+1;
				tempArray[N]:=arrrekonline.list[i].noakun;
			end;
		end;
	end;
	if (N>0) then
	begin
		{ Menampilkan nomor akun rekening-rekening yang tersimpan pada
		  array tempArray }
		writeln('> Pilih rekening ',jenis,' Anda:');
		for i:=1 to N do
		begin
			writeln('> ',i,'. ',tempArray[i]);
		end;
		write('> Rekening: ');
		readln(noAk);
		{ Asumsikan nomor akun yang dimasukkan pengguna benar }
		found:=false;
		i:=1;
		while (i<=arrrekonline.Neff) and (not(found)) do
		begin
			if (arrrekonline.list[i].noakun=noAk) then
				found:=true
			else
				i:=i+1;
		end;
		if found then
		begin
			write('> Masukkan jumlah uang yang diinginkan!');
			readln(jumlahTarik);
			if (jenis='tabungan mandiri') and (arrrekonline.list[i].saldo>=jumlahTarik) then
			begin
				arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo-jumlahTarik;
				success:=true;
			end else if ((jenis='deposito') or (jenis='tabungan rencana')) and (arrrekonline.list[i].saldo>=jumlahTarik) and SudahJatuhTempo(arrrekonline.list[i]) then
			begin
				arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo-jumlahTarik;
				success:=true;
			end else
				success:=false;
			if (success=true) then
			begin
				arrtransaksi.Neff:=arrtransaksi.Neff+1;
				arrtransaksi.list[arrtransaksi.Neff].noakun:=arrrekonline.list[i].noakun;
				arrtransaksi.list[arrtransaksi.Neff].jenis:='penarikan';
				arrtransaksi.list[arrtransaksi.Neff].uang:=arrrekonline.list[i].uang;
				arrtransaksi.list[arrtransaksi.Neff].jumlah:=jumlahTarik;
				arrtransaksi.list[arrtransaksi.Neff].saldoakhir:=arrrekonline.list[i].saldo;
				arrtransaksi.list[arrtransaksi.Neff].tgl:=FormatDateTime('DD-MM-YYYY',Now);
				writeln('> Penarikan berhasil! Jumlah saldo Anda adalah ',arrrekonline.list[i].saldo);
			end else { not(success) }
				writeln('> Anda tidak dapat melakukan penarikan.');
		end else { not(found) }
			writeln('Rekening tidak ditemukan!');
	end else { N=0 }
		writeln('> Anda tidak mempunyai ',jenis,'.');
end.
