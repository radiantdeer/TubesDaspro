unit utampilanpengguna;
{ Berisi prosedur-prosedur yang sering digunakan pada bagian lain }
{ Prosedur-prosedur pada bagian ini menangani tampilan pada layar }

interface

	uses banktype;
	
	type
		TabString = array [1..50] of string;
		
	procedure PilihJenisRekening (var jenisRek : integer);
	{ Menampilkan jenis-jenis rekening yang dapat dipilih pengguna }
	{ Menerima masukan jenis rekening dari pengguna }
	
	procedure IsiTempArray (var tempArray : TabString; var jenis : string; var N : integer; jenisRek : integer);
	{ Mendaftarkan nomor akun rekening-rekening milik pengguna ke array 
	tempArray sesuai dengan masukan jenis rekening pada procedure PilihJenisRekening }
	{ N adalah banyaknya rekening milik pengguna dengan jenis tertentu sesuai masukan pengguna }
	
	procedure TampilIsiTempArray (tempArray : TabString; N : integer; jenis : string);
	{ Menampilkan nomor akun rekening-rekening yang tersimpan pada array tempArray }
	
	procedure CariIdxpadaTempArray (tempArray : TabString; noAk : string; N : integer; var found : boolean);
	{ Pencarian indeks nomor akun rekening yang dimasukkan pengguna pada tempArray }
	
	procedure CariIdxpadaArrRekOnline (arrrekonline : lrekonline; noAk : string; var i : integer);
    { Pencarian indeks nomor akun rekening pada arrrekonline }

implementation

	procedure PilihJenisRekening(var jenisRek : integer);
	var
		stop : boolean;
	begin
		writeln('> Pilih jenis rekening:');
		writeln('> 1. Deposito');
		writeln('> 2. Tabungan rencana');
		writeln('> 3. Tabungan mandiri');
		{ Validasi masukan jenis rekening }
		{ Pengulangan akan berhenti jika pengguna memasukkan jenis rekening yang tepat, yaitu 1, 2, atau 3 }
		stop:=false;
		repeat
			write('> Jenis rekening : ');
			readln(jenisRek);
			if (jenisRek=1) or (jenisRek=2) or (jenisRek=3) then
				stop:=true
			else
				writeln('> Jenis rekening yang Anda masukkan salah!');
		until stop;
	end;
	
	procedure IsiTempArray(var tempArray : TabString; var jenis : string; var N : integer; jenisRek : integer);
	begin
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
	end;
	
	procedure TampilIsiTempArray(tempArray : TabString; N : integer; jenis : string);
	begin
		writeln('> Pilih rekening ',jenis,' Anda:');
		for i:=1 to N do
		begin
			writeln('> ',i,'. ',tempArray[i]);
		end;
	end;
	
	procedure CariIdxpadaTempArray (tempArray : TabString; noAk : string; N : integer; var found : boolean);
	var
		i : integer;
	begin
		found:=false;
		i:=1;
		while (i<=N) and (not(found)) do
		begin
			if (tempArray[i]=noAk) then
				found:=true
			else
				i:=i+1;
		end;
	end;
	
	procedure CariIdxpadaArrRekOnline (arrrekonline : lrekonline; noAk : string; var i : integer);
	var
		found : boolean;
	begin
		found:=false;
		i:=1;
		while not(found) do
		begin
			if (arrrekonline.list[i].noakun=noAk) then
				found:=true
			else
				i:=i+1;
		end;
	end;

end.
