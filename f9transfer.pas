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
    
    
