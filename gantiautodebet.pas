program gantiautodebet;
{Program untuk mengganti autodebet suatu rekening}
uses banktype,utransaksi;

{Kamus Lokal}
var
	k : integer;
	found3 : boolean;
	autodebet : string;
	
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
		
	writeln('> Pilih rekening ',jenis,' Anda:');
    for i:=1 to N do
    begin
    	writeln('> ',i,'. ',tempArray[i]);
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
			found3 := false;
			
			write('> Masukkan nomor rekening autodebet baru anda : ');
			readln(autodebet);
			while (k<= arrrekonline.neff) and not(found) do
			begin
				k := k +1;
				if (arrrekonline.list[k].noakun = autodebet) and (arrrekonline.list[k].jenis = 'tabungan mandiri') then
				begin
					found := true;
				end;
			if (found3) then
			begin
				arrrekonline.list[j].autodebet := autodebet;
			end else
				writeln('> Anda tidak memiliki rekening mandiri');
			end;
		end else { not(found) }
    		writeln('> Rekening tidak ditemukan!');
    end else { N=0 }
    	writeln('> Anda tidak mempunyai ',jenis,'.');
end.