Program Setoran;
{ Menyetor sejumlah uang secara tunai ke suatu rekening tertentu }

uses banktype;

{ Kamus }	
var
	arrrekonline : lrekonline;
	tempArray : array [1..50] of string;
	jenis : string;
	jenisRek : integer;
	noAk : string;
	jumlahSetor : real;
	stop, found : boolean;
	N : integer;
	i : integer; { Iterasi }

{ Algoritma - Program Utama }
begin
	writeln('> Pilih jenis rekening:');
	writeln('> 1. Deposito');
	writeln('> 2. Tabungan rencana');
	writeln('> 3. Tabungan mandiri');
	stop:=false;
	repeat
		write('> Jenis rekening : ');
		readln(jenisRek);
		if (jenisRek=1) or (jenisRek=2) or (jenisRek=3) then
			stop:=true
		else
			writeln('> Jenis rekening yang Anda masukkan salah!');
	until stop;
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
		while (not(found)) do
		begin
			if (arrrekonline.list[i].noakun=noAk) then
				found:=true
			else
				i:=i+1;
		end;
		write('> Jumlah setoran: ');
		readln(jumlahSetor);
		arrrekonline.list[i].saldo:=arrrekonline.list[i].saldo+jumlahSetor;
		writeln('> Setoran berhasil! Jumlah saldo Anda adalah ',arrrekonline.list[i].saldo);
	end else
		writeln('> Anda tidak mempunyai ',jenis);
end.
