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
	
	Procedure Pembayaran (Var lrek :arrrekonline; trans : arrtransaksi ; var DP : arrbayar; Tanggal : Array of Word; T: arrkurs);
		Var
			i,j		: Integer;
			RE 		: rekonline;
			pil,ST2		: String; 
			found 		: Boolean;
			Jum1,Jum2	: longint;
			
		Begin
			PilihRekening(lrek,trans,i);
			
			RE := R.listRekening[i];
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
						1 : pil :='Listrik';
						2 : pil := 'BPJS';
						3 : pil := 'PDAM';
						4 : pil := 'Telepon';
						5 : pil := 'TV Kabel';
						6 : pil := 'Kartu Kredit';
						7 : pil := 'Pajak';
						8 : pil := 'Pendidikan'
					else
						Begin
							Write ('Jenis Transaksi : ');
							readln(pil);
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
