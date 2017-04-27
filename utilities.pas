unit utilities;

{Berisi prosedur-prosedur yang tidak berhubungan dengan user sama sekali seperti load dan quit}

interface
	
	//Unit lain yang dibutuhkan
	uses typeStructures;

	//Digunakan pada saat program dimulai untuk menyimpan data-data dari database ke variabel-variabel
	procedure load(var data : Database);

	//Digunakan pada saat program akan berakhir untuk mengupdate database
	procedure quit(var data : Database);
	
	//Digunakan untuk mengecek apakah username yang diberikan ada dalam database, bila ada output index username tersebut pada DatabaseNasabah, bila tidak output userNotFound
	function userExists(username : string; var data : Database) : integer;
	
	//Digunakan untuk mencari semua rekening yang dimiliki nasabah
	function findAllRekening(var data : Database; userIdx : integer) : daftarIndex;
	
	Function BolehAmbil(R : T_Rekening ; jWaktu : Array of Word) : Boolean;
	
	Procedure PilihRekening (Rek : DataRekening ; Idx : daftarIndex; Var k :Integer);
	
	Function ConvertUang (T : DataNilaiTukar ; MU1, MU2 : String ; Jumlah : longint) : longint;
	
	Function IdxRekening (Rek : DataRekening ; Akun : String) : Integer ;
	
	Procedure ValidJumlah (R : T_Rekening ; var jum : longint);
	
const
	dataFile = 'db.dat'; //Nama file database yang menyimpan semua data bank	
	userNotFound = 0;	//Nilai yang dikembalikan userExists bila user tidak ditemukan
	
implementation
	
	{Mengambil data yang tersimpan pada 'db.dat' dan menyimpannya di variabel untuk digunakan pada sesi bank online kali ini}
	procedure load(var data : Database);
	
	var
		source : file of Database;
		
	begin
		//Buka file database, siapkan untuk pembacaan, dan ambil data bila file tidak kosong
		assign(source, dataFile);
		reset(source);
		
		if(not(eof(source))) then read(source, data);
		
		close(source); //Tutup file
	end;
	
	{Procedure ini menyimpan data terbaru dari bank online setelah sesi ini dan menyimpannya ke dalam file database}
	procedure quit(var data : Database);
	
	var
		source : file of Database;
	
	begin
		//Buka file database, kosongkan, dan simpan data hasil sesi kali ini ke file tersebut
		assign(source,dataFile);
		
		rewrite(source);
		
		write(source, data);
		
		close(source); //Tutup file
	end;

	function userExists(username : string; var data : Database) : integer;
	
	var
		i : integer; //Loop counter
		
	begin
		//Inisialisasi counter
		i := 1;
		
		//Cek setiap nasbah dalam database hingga habis atau ditemukan nasabah dengan username tersebut
		while((i <= data.nasabah.Neff) and (data.nasabah.listNasabah[i].username <> username)) do
		begin
			i := i + 1;
		end;
		
		//Jika ditemukan, output index letak nasabah, bila tidak output userNotFound
		if(i <= data.nasabah.Neff) then userExists := i
		else userExists := userNotFound;
	end;

	function findAllRekening(var data : Database; userIdx : integer) : daftarIndex;
	
	var
		i : integer; //Loop counter
		
	begin
		//Inisialisasi Neff dari output fungsi
		findAllRekening.Neff := 0;
		
		//Cek setiap rekenign dalam database dan simpan indeksnya dalam output bila milik nasabah
		for i:= 1 to data.rekening.Neff do
		begin
			if(data.rekening.listRekening[i].noNasabah = data.nasabah.listNasabah[userIdx].noNasabah) then
			begin
				findAllRekening.Neff := findAllRekening.Neff + 1;
				findAllRekening.index[findAllRekening.Neff] := i;
			end;
		end;
	end;
	
	Function BolehAmbil(R : T_Rekening ; jWaktu : Array of Word) : Boolean;
		Var
			c : Integer;
		Begin
			c := jWaktu[2] - R.tanggalMulai[2];
			BolehAmbil := not((R.Jenis = 'Deposito') or (R.Jenis = 'Tabungan Rencana')) and (c < R.Waktu)
		end;
		
	Function ConvertUang (T : DataNilaiTukar ; MU1, MU2 : String ; Jumlah : longint) : longint;
		Var
			i : Integer;
		Begin
			i:=0;
			Repeat 
				i:= i+1
			until (T.listNilaiTukar[i].asal = MU1) and (T.listNilaiTukar[i].tujuan = MU2);
			ConvertUang := Jumlah*(T.listNilaiTukar[i].NilaiTujuan) div (T.listNilaiTukar[i].NilaiAsal);
		end;
		
	Function IdxRekening (Rek : DataRekening ; Akun : String) : Integer ;
		var
			i : Integer;
		Begin
			i := 0 ;
			Repeat 
				i :=  i + 1;
			until(Rek.listRekening[i].noAkun = Akun) or (i > Rek.Neff);
			if (Rek.Neff < i) then
				IdxRekening := 0
			else
				IdxRekening := i;
		end;
		
	Procedure PilihRekening (Rek : DataRekening ; Idx : daftarIndex; Var k :Integer);
		Var
			i : Integer;
			NR : String;
		Begin
			k := -1;
			Repeat
				write('Nomor Rekening : ');
				readln(NR);
				i := 0;
				Repeat
					i := i + 1;
				Until ((Rek.listRekening[Idx.index[i]].noAkun = NR) or (i > Idx.Neff));
				if i > Idx.Neff then
					writeln('Rekening Tidak Ditemukan, Silahkan Ulangi Masukan')
				else 
					k := Idx.index[i];
			until (k <> (-1));
		end;	
	
	Procedure ValidJumlah (R : T_Rekening ; var jum : longint);
	
	Begin
		Repeat
			write('Jumlah Uang : ');
			readln(jum);
			if (jum > R.Saldo) then
			writeln('Saldo Tidak Mencukupi, Silahkan Ulangi Masukan');
		until(R.Saldo >= jum);
	end;
	
end.
