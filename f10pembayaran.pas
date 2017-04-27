//aldo

 // SATU DATA Histori Pembayaran
        pembayaran = record
          noakun : string;
          jenis : string;
          nomorbayar : string;
          uang : string;
          jumlah : real;
          saldoakhir : real;
          tgl : string;
        end;

      // List Histori Pembayaran
        lpembayaran = record
          list : array[1..nmax] of pembayaran;
          Neff : integer;
        end;
	
	Procedure Pembayaran (Var R : DataRekening; Idx : daftarIndex; var B : DataPembayaran; Tanggal : Array of Word; T: DataNilaiTukar);
		Var
			i,j		: Integer;
			R1 		: T_Rekening;
			Jen,NoB		: String; 
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
						8 : Jen := 'Pendidikan'
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
