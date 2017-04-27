unit Command;

interface
	
	uses typeStructures, utilities, Dos,sysUtils; //Unit lain yang dibutuhkan
	
	const
		//Index-index untuk mengakses tanggal, bulan ataupun tahun hari ini dari variabel tanggal
		year = 1;
		month = 2;
		date = 3;
		
		maxTry : integer = 3; //Batas percobaan input password yang diperbolehkan
	
	{
		Memberikan user kesempatan login ke Database yang diberikan
		Setiap login suatu username diberi 3 kesempatan, bila pada semua kesempatan password salah, maka akun dengan username tersebut dibuat inaktif
		Selain itu, fitur ini menyimpan tanggal login pada variabel tanggal yang diberikan sebagai argumen
		
		Output dari login adalah index nasabah yang berhasil login pada database
	}
	function login(var data : Database; var tanggal : array of word) : integer;
	
	{
		Command ini menampilkan daftar rekening online yang dimiliki masalah beserta beberapa informasi mendasar mengenai rekening-rekening tersebut
	}
		procedure lihatRekening(Rek : DataRekening ; Idx_R : daftarIndex);
	
	{
		Command ini menampilkan daftar rekening yang dimiliki nasabah lalu menampilkan saldo dari salah satu rekening-rekening tersebut sesuai input pengguna
	}
	Procedure Setor(Tanggal : Array of Word ; No : Integer ; var S : DataTransaksi; var R : DataRekening ; Idx : daftarIndex);
	Procedure Tarik(Tanggal : Array of Word; No : Integer; Var S : DataTransaksi; var R : DataRekening ; Idx : daftarIndex);
	Procedure Transfer (Var R : DataRekening ; Idx : daftarIndex ; var Trf : DataTransfer; Tanggal : Array of Word ; T : DataNilaiTukar);
	Procedure Pembayaran (Var R : DataRekening; Idx : daftarIndex; var B : DataPembayaran; Tanggal : Array of Word; T: DataNilaiTukar);
	Procedure Pembelian (Var R : DataRekening; Idx : daftarIndex; var B : DataPembelian; Tanggal : Array of Word; T: DataNilaiTukar);
	
//	procedure informasiSaldo(var data : Database; userIdx : integer);
	
	
implementation

	function login(var data : Database; var tanggal : array of word) : integer;
	
	var
		username, password : string; //Variabel untuk menyimpan input user
		userIdx : integer; //Variabel untuk menyimpan index nasabah dengan username yang diinput
		i : integer; //Counter loop
		
	begin
		//Minta input username dari pengguna hingga ditemukan dalam database
		repeat
			write('Username: ');
			readln(username);
			
			userIdx := userExists(username, data);
			
			if(userIdx = userNotFound) then writeln('Username not found.');
			
		until (userIdx <> userNotFound);
		
		//Cek apakah akun aktif, bila tidak tampilkan pesan error
		if (not(data.nasabah.listNasabah[userIdx].statusAktif)) then 
		begin
			writeln('Maaf, akun anda sedang tidak aktif.');
			writeln('Mohon hubungi Customer Service kami untuk mengaktifkannya.');
			login := userNotFound; //Tidak berhasil login, kembalikan userNotFound
		end
		
		else
		begin
			//Input password sebanyak maksimum 3 kali, jika masih salah, nonaktifkan account nasabah tersebut
			
			//Inisialisasi password dan counter loop
			password := '0';
			i := 0;
			
			repeat
				write('Password: ');
				readln(password);
			
				if(password <> data.nasabah.listNasabah[userIdx].password) then
				begin
					writeln('Password Incorrect, you have ', maxTry - i - 1, ' tries left');		
					i := i + 1; //Tingkatkan counter percobaan input password
				end;
				
			until ((i >= maxTry) or (data.nasabah.listNasabah[userIdx].password = password));
			
			//Jika gagal menginput password yang benar, nonaktifkan account dan beritahukan pada nasabah
			if(i >= maxTry) then
			begin
				data.nasabah.listNasabah[userIdx].statusAktif := False;
				writeln('Maaf, kesempatan anda sudah habis.');
				writeln('Akun anda sudah kami nonaktifkan demi alasan keamanan. Untuk menyelesaikan masalah ini, hubungi Customer Service kami');
				login := userNotFound; //Tidak berhasil login, kembalikan userNotFound
			end
			
			else //Jika login berhasil, simpan tanggal hari ini dan kembalikan index nasabah yang berhasil login
			begin
				GetDate(tanggal[year], tanggal[month], tanggal[date], tanggal[4]);
				login := userIdx;
			end;
		end;
	end;
	
	procedure lihatRekening(Rek : DataRekening ; Idx_R : daftarIndex);
		//Output : Daftar Rekening Online Nasabah
		var
			z : String;
			i,j:Integer;
		Begin
			// Mencari Indeks Akun Nasabah yang dimasukkan
			for i:= 1 to Idx_R.Neff do
			Begin
				writeln('No. Akun : ' + Rek.listRekening[Idx_R.index[i]].noAkun);
				writeln('No. Nasabah : ' + Rek.listRekening[Idx_R.index[i]].NoNasabah);
				writeln('Jenis Rekening : ' + Rek.listRekening[Idx_R.index[i]].Jenis);
				writeln('Mata Uang : ' + Rek.listRekening[Idx_R.index[i]].mataUang);
				writeln('Saldo : ', Rek.listRekening[Idx_R.index[i]].Saldo);
				writeln('Setoran Rutin : ', Rek.listRekening[Idx_R.index[i]].Setoran);
				writeln('Auto debit : ', Rek.listRekening[Idx_R.index[i]].autoDebet);
				writeln('Jangka Waktu : ', Rek.listRekening[Idx_R.index[i]].Waktu, 'Bulan');
				write('Tanggal Mulai : ');
				for j:= 1 to 4 do
					Begin
						z := IntToStr(Rek.listRekening[Idx_R.index[i]].tanggalMulai[j]);
						write(z + '/');
					end;
				writeln();
			end;
		end;
		
	Procedure Setor(Tanggal : Array of Word ; No : Integer ; var S : DataTransaksi; var R : DataRekening ; Idx : daftarIndex);
		//Input : Nilai Setoran yang Dimasukkan
		//Otput : Data Transaksi & Rekening yang telah diupdate
		Var
			Jum : longint;
			k :Integer;
		Begin
			PilihRekening(R,Idx,k);
			writeln('Masukan Jumlah Uang Yang Ingin Diambil');
			readln(jum);
			S.Neff := S.Neff + 1;
			R.listRekening[k].Saldo := R.listRekening[k].Saldo + jum;
			S.listTransaksi[S.Neff].noAkun := R.listRekening[k].noAkun;
			S.listTransaksi[S.Neff].Jenis := 'Setoran';
			S.listTransaksi[S.Neff].mataUang := R.listRekening[k].mataUang;
			S.listTransaksi[S.Neff].Jumlah := Jum;
			S.listTransaksi[S.Neff].saldoAkhir := R.listRekening[k].Saldo;
			S.listTransaksi[S.Neff].Tanggal := Tanggal;
			writeln('Transaksi Berhasil');
		end;

	Procedure Tarik(Tanggal : Array of Word; No : Integer; Var S : DataTransaksi; var R : DataRekening ; Idx : daftarIndex);
		//Input : Nilai Uang yang Ditarik
		//Otput : Data Transaksi & Rekening yang telah diupdate
		Var
			Jum : longint;
			k :Integer;
		Begin
			PilihRekening(R,Idx,k);
			If BolehAmbil(R.listRekening[k],Tanggal) then
				Writeln('Waktu Batas Pengambilan Belum Lewat, Transaksi Gagal')
			else
				Begin
					writeln('Masukan Jumlah Uang Yang Ingin Diambil');
					ValidJumlah (R.listRekening[k], jum);
					S.Neff := S.Neff + 1;
					R.listRekening[k].Saldo := R.listRekening[k].Saldo - jum;
					S.listTransaksi[S.Neff].noAkun := R.listRekening[k].noAkun;
					S.listTransaksi[S.Neff].Jenis := 'Penarikan';
					S.listTransaksi[S.Neff].mataUang := R.listRekening[k].mataUang;
					S.listTransaksi[S.Neff].Jumlah := Jum;	
					S.listTransaksi[S.Neff].saldoAkhir := R.listRekening[k].Saldo;
					S.listTransaksi[S.Neff].Tanggal := Tanggal;
					writeln('Transaksi Berhasil');
				end;
		end;

	Procedure Transfer (Var R : DataRekening ; Idx : daftarIndex ; var Trf : DataTransfer; Tanggal : Array of Word ; T : DataNilaiTukar);
		//Input : Rekening Asal, Jenis Transfer, Jumlah Transfer, dan Rekening Tujuan
		//Output : DataTransfer dan DataRekening yang telah diupdate
		Var
			Jum,JumT: longint;
			i,j,k	: Integer;
			s,bnk 	: String;
			R1,R2 : T_Rekening;
		Begin
			PilihRekening(R,Idx,i);
			R1 := R.listRekening[i];
			If BolehAmbil(R1,Tanggal) then
					Writeln('Waktu Batas Transfer Belum Lewat, Transaksi Gagal')
			else
				Begin
					bnk := '-';
					Repeat
						writeln('Pilih Jenis Transaksi');
						writeln('  1. Sama Bank');
						writeln('  2. Beda Bank');
						write('Jenis Transaksi : ');
						readln(j);
						if (j<>1) and (j <> 2) then
							writeln('Masukkan Anda Salah, Silahkan Ulangi Masukan');
					until (j = 1) or (j = 2);
					if (j = 2) then
						Begin
							write('Bank Tujuan : ');
							readln(bnk);
							write('Rekening Tujuan : ');
							readln(s);
						end
					else 
						Begin
							Repeat
								write('Rekening Tujuan : ');
								readln(s);
								if IdxRekening(R,s) = 0 then 
									writeln('Rekening Tujuan Tidak Ditemukan, Silahkan Ulangi Masukan');
							until(IdxRekening(R,s) <> 0);
							k := IdxRekening(R,s);
							R2 := R.listRekening[k];
						end;
					Writeln('Masukan Jumlah Uang Yang Ingin ditransfer');
					ValidJumlah (R1, jumT);
					if (j = 2) and (R1.mataUang = 'IDR') then
						jum := jumT + 5000
					else if (j = 2) then
						jum := jumT + ConvertUang(T,'IDR',R1.mataUang,5000)
					else if (R1.mataUang <> R2.mataUang) then 
						jum := jumT + 2
					else
						jum := jumT;
					R1.Saldo := R1.Saldo - jum;
					if (j = 1) and (R1.mataUang <> R2.mataUang) then
						R2.Saldo := R2.Saldo + ConvertUang(T,R1.mataUang,R2.mataUang,jumT)
					else if (j = 1) then
						R2.Saldo := R2.Saldo + jumT;
					R.listRekening[k] := R2;
					R.listRekening[i] := R1;
					Trf.Neff := Trf.Neff + 1;
					Trf.listTransfer[Trf.Neff].noAkun := R1.noAkun;
					Trf.listTransfer[Trf.Neff].tujuan := s;
					Trf.listTransfer[Trf.Neff].jumlah := jumT;
					Trf.listTransfer[Trf.Neff].saldoAkhir := R1.Saldo;
					Trf.listTransfer[Trf.Neff].tanggal := Tanggal;
					Trf.listTransfer[Trf.Neff].bankLuar := bnk;
					if (j = 2) then
						Begin
							Trf.listTransfer[Trf.Neff].jenis := 'antar bank';
							Trf.listTransfer[Trf.Neff].mataUang := R1.mataUang;
						end
					else
						Begin
							Trf.listTransfer[Trf.Neff].jenis := 'dalam bank';
							Trf.listTransfer[Trf.Neff].mataUang := R2.mataUang;
						end;
				end;
		end;
	
	Procedure Pembayaran (Var R : DataRekening; Idx : daftarIndex; var B : DataPembayaran; Tanggal : Array of Word; T: DataNilaiTukar);
		Var
			i,j		 	: Integer;
			R1 			: T_Rekening;
			Jen,NoB	: String; 
			T15 		: Boolean;
			Jum,JumB	: longint;
			
		Begin
			PilihRekening(R,Idx,i);
			
			R1 := R.listRekening[i];
			If BolehAmbil(R1,Tanggal) then
				Writeln('Waktu Batas Pengambilan Belum Lewat, Transaksi Gagal')
			else
				Begin
					writeln ('Pilih Jenis Pembayaran');
					writeln('	1. Listrik');
					writeln('	2. BPJS');
					writeln('	3. PDAM');
					writeln('	4. Telepon');
					writeln('	5. TV Kabel');
					writeln('	6. Kartu Kredit');
					writeln('	7. Pajak');
					writeln('	8. Pendidikan');
					writeln('	9. Transaksi Lain');
					write ('Jenis Transaksi Pembayaran : ');
					readln(J);
					case j of
						1 : Jen := 'Listrik';
						2 : Jen := 'BPJS';
						3 : Jen := 'PDAM';
						4 : Jen := 'Telepon';
						5 : Jen := 'TV Kabel';
						6 : Jen := 'Kartu Kredit';
						7 : Jen := 'Pajak';
						8 :	Jen := 'Pendidikan'
					else
						Begin
							Write ('Jenis Transaksi : ');
							readln(Jen);
						end;
					end;
					write('Nomor Pembayaran : ');
					readln(NoB);
					if (j > 0) and (j < 6) then
						T15 := Tanggal[3] > 15
					else 
						T15 := False;
					writeln('Masukkan Jumlah yang ingin dibayar');
					ValidJumlah (R1, jumB);
					if T15 and (R1.mataUang = 'IDR') then
						jum := jumB + (tanggal[3] - 15)*10000
					else if T15 then
						jum := jumB + ConvertUang(T,'IDR',R1.mataUang,((tanggal[3] - 15)*10000))
					else 
						jum := jumB;
					R1.saldo := R1.saldo - jum;
					R.listRekening[i] := R1;
					B.Neff := B.Neff + 1;
					B.listPembayaran[B.Neff].noAkun := R1.noAkun;
					B.listPembayaran[B.Neff].jenis := jen;
					B.listPembayaran[B.Neff].tujuan := NoB;
					B.listPembayaran[B.Neff].mataUang := R1.mataUang;
					B.listPembayaran[B.Neff].jumlah := jumB;
					B.listPembayaran[B.Neff].saldoAkhir := R1.saldo;
					B.listPembayaran[B.Neff].tanggal := Tanggal;
				end;
		end;
					
	Procedure Pembelian (Var R : DataRekening; Idx : daftarIndex; var B : DataPembelian; Tanggal : Array of Word; T: DataNilaiTukar);
		Var
			i,j		 	: Integer;
			R1 			: T_Rekening;
			Jen,Com,NT	: String;
			Jum			: longint;
			
		Begin
			PilihRekening(R,Idx,i);
			R1 := R.listRekening[i];
			If BolehAmbil(R1,Tanggal) then
				Writeln('Waktu Batas Pengambilan Belum Lewat, Transaksi Gagal')
			else
				Begin
					writeln ('Pilih Jenis Pembelian');
					writeln('	1. Voucher HP');
					writeln('	2. Listrik');
					writeln('	3. Taksi Online');
					write ('Jenis Transaksi Pembayaran : ');
					readln(J);
					case j of
						1 : Jen := 'Voucher HP';
						2 : Jen := 'Listrik';
						3 : Jen := 'Taksi Online';
					else
						Begin
							Write ('Jenis Transaksi : ');
							readln(Jen);
						end;
					end;
					
					write('Penyedia Barang : ');
					readln(Com);
					write('Nomor Tujuan : ');
					readln(NT);
					writeln('Masukkan Jumlah yang ingin dibayar');
					ValidJumlah (R1, jum);
					R1.saldo := R1.saldo - jum;
					R.listRekening[i] := R1;
					B.Neff := B.Neff + 1;
					B.listPembelian[B.Neff].noAkun := R1.noAkun;
					B.listPembelian[B.Neff].jenisBarang := jen;
					B.listPembelian[B.Neff].penyedia := Com;
					B.listPembelian[B.Neff].noTujuan := NT;
					B.listPembelian[B.Neff].mataUang := R1.mataUang;
					B.listPembelian[B.Neff].jumlah := jum;
					B.listPembelian[B.Neff].saldoAkhir := R1.saldo;
					B.listPembelian[B.Neff].tanggal := Tanggal;
				end;
		end;

{ 	procedure informasiSaldo(var data : Database; userIdx : integer);
	
	var
		noAkses : string; //No. akun rekening yang ingin diakses pengguna
		listRekeningUser : dataRekening; //Daftar rekening milik pengguna
		i : integer; //Loop counter
		
	begin
		lihatRekening(data, userIdx); //Cetak daftar rekening atas nama pengguna tersebut
		
		//Minta pengguna input nomor akun yang ingin dilihat saldonya
		write('Nomor rekening yang ingin diakses: ');
		readln(noAkses); 
		
		//Akses rekening dengan nomor yang diakses bila ada,
		for i := 1 to data.rekening.Neff do
		begin
		
		end;
	end; }
end.
