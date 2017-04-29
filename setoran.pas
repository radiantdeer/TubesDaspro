Program Setoran;
{ Menyetor sejumlah uang secara tunai ke suatu rekening tertentu }

uses sysutils, banktype;

{ Kamus }	
var
	arrrekonline : lrekonline;
	arrtransaksi : ltrans;
	tempArray : array [1..50] of string;
	currentuser : nasabah;
	jenis : string;
	jenisRek : integer;
	noAk : string;
	jumlahSetor : real;
	stop, found : boolean;
	N : integer;
	i : integer; { Iterasi }

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
		{ Pencarian indeks nomor akun rekening yang dimasukkan pengguna }
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
			write('> Jumlah setoran: ');
			readln(jumlahSetor);
			arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo+jumlahSetor;
			{ Update array transaksi setoran/penarikan }
			arrtransaksi.Neff:=arrtransaksi.Neff+1;
			arrtransaksi.list[arrtransaksi.Neff].noakun:=arrrekonline.list[i].noakun;
			arrtransaksi.list[arrtransaksi.Neff].jenis:='setoran';
			arrtransaksi.list[arrtransaksi.Neff].uang:=arrrekonline.list[i].uang;
			arrtransaksi.list[arrtransaksi.Neff].jumlah:=jumlahSetor;
			arrtransaksi.list[arrtransaksi.Neff].saldoakhir:=arrrekonline.list[i].saldo;
			arrtransaksi.list[arrtransaksi.Neff].tgl:=DateTimeToStr(Now);
			writeln('> Setoran berhasil! Jumlah saldo Anda adalah ',arrrekonline.list[i].saldo);
		end else { not(found) }
			writeln('Rekening tidak ditemukan!');
	end else { N=0 }
		writeln('> Anda tidak mempunyai ',jenis,'.');
end.
