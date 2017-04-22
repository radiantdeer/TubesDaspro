Program Setoran;
{ Menyetor sejumlah uang secara tunai ke suatu rekening tertentu }

uses banktype;

{ Kamus }
type
	TabString = array [1..50] of string;
	
var
	arrrekonline : lrekonline;
	tempArray : TabString;
	jenis : string;
	jenisRek : integer;
	noAk : string;
	jumlahSetor : real;
	stop, found : boolean;
	N : integer;
	i : integer; { Iterasi }

procedure TampilDaftarRekening (var N : integer; arrrekonline : lrekonline; jenis : string);
{ Kamus Lokal }
var
	i : integer; { Iterasi }
{ Algoritma }
begin
	N:=0;
	writeln('> Pilih rekening ',jenis,' Anda:');
	for i:=1 to arrrekonline.Neff do
	begin
		if (arrrekonline.list[i].jenis=jenis) then
		begin
			N:=N+1;
			writeln('> ',N,'. ',arrrekonline.list[i].noakun);
		end;
	end;
end;

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
		TampilDaftarRekening(N,arrrekonline,jenis);
	end else if (jenisRek=2) then
	begin
		jenis:='tabungan rencana';
		TampilDaftarRekening(N,arrrekonline,jenis);
	end else
	begin
		jenis:='tabungan mandiri';
		TampilDaftarRekening(N,arrrekonline,jenis);
	end;
	if (N>0) then
	begin
		write('> Rekening: ');
		readln(noAk);
		found:=false;
		i:=0;
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
