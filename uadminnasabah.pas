unit uadminnasabah;
{ Unit ini menampung berbagai subprogram berkaitan dengan nasabah (buat, edit, hapus, dkk.) }

interface
	uses banktype,utransaksi;

	procedure editnasabah();
	{ Mengubah berbagai data yang diinginkan oleh pengguna }

	procedure gantiautodebet;
{Program untuk mengganti autodebet suatu rekening}
implementation

	procedure editnasabah();
	var
		pilih 			: integer;
		data 			: string;

	begin
		writeln('> 1. Nama Nasabah');
		writeln('> 2. Alamat');
		writeln('> 3. Kota');
		writeln('> 4. Email');
		writeln('> 5. No Telp');
		writeln('> 6. Password');
		repeat
			write('> Pilih menu yang akan diganti : ');
			readln(pilih);
			if(NOT((pilih > 0) AND (pilih <= 6))) then writeln('> Pilihan salah! Coba lagi!');
		until((pilih > 0) AND (pilih <= 6));
		write('> Silakan masukkan data yang baru : ');
		readln(data);
		case pilih of
			1 : currentuser.nama := data;
			2 : currentuser.alamat := data;
			3 : currentuser.kota := data;
			4 : currentuser.email := data;
			5 : currentuser.telp := data;
			6 : currentuser.pass := data;
		end;
		writeln('> Data anda telah diupdate. ');
	end;

procedure gantiautodebet;
{Program untuk mengganti autodebet suatu rekening}

{Kamus Lokal}
var
	k : integer;
	autodebet : string;
	j : integer;
	found,found2,found1 : boolean;
	tempArray :  array [1..50] of string;
{Algoritma}
begin
	writeln('> Pilih jenis rekening:');
    writeln('> 1. Deposito');
    writeln('> 2. Tabungan rencana');
    { Validasi masukan jenis rekening }
    { Pengulangan akan berhenti jika pengguna memasukkan jenis rekening
      yang tepat, yaitu 1 atau 2 }
    stop:=false;
    repeat
    	write('> Jenis rekening : ');
    	readln(jenisRek);
    	if (jenisRek=1) or (jenisRek=2) then
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
		{ Pencarian indeks nomor akun rekening yang dimasukkan pengguna pada tempArray }
		found1:=false;
		i:=1;
		while (i<=N) and (not(found1)) do
		begin
			if (tempArray[i]=noAk) then
				found1:=true
			else
				i:=i+1;
		end;
    	if found1 then
    	begin
			{ Pencarian indeks nomor akun rekening pada arrrekonline }
			found2:=false;
			j:=1;
			while not(found2) do
			begin
				if (arrrekonline.list[j].noakun=noAk) then
					found2:=true
				else
					j:=j+1;
			end;
			k := 0;
			found := false;
			
			write('> Masukkan nomor rekening autodebet baru anda : ');
			readln(autodebet);
			while (k<= arrrekonline.neff) and not(found) do
			begin
				k := k +1;
				if (arrrekonline.list[k].noakun = autodebet) and (arrrekonline.list[k].jenis = 'tabungan mandiri') then
				begin
					found := true;
				end;
			end;
			if (found) then
			begin
				writeln('> Rekening autodebet anda telah diupdate');
				arrrekonline.list[j].autodebet := autodebet;
			end else
				writeln('> Anda tidak memiliki rekening mandiri');
		end else { not(found) }
    		writeln('> Rekening tidak ditemukan!');
    end else { N=0 }
    	writeln('> Anda tidak mempunyai ',jenis,'.');
end;
end.