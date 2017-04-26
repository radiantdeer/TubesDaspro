unit banktype;
// Mengandung semua deklarasi tipe yang digunakan dalam program bank

interface
const
  nmax=500;
  maxkurs=50;
type
  // SATU DATA Nasabah
   nasabah = record
     nonasabah : string;
     nama : string;
     alamat : string;
     kota : string;
     email : string;
     telp : string;
     user : string;
     pass : string;
     stat : string;
  end;

// List Data Nasabah
  lnasabah = record
    list : array[1..nmax] of nasabah;
    Neff : integer;
  end;

// SATU DATA Rekening Online
    rekonline = record
      noakun : string;
      nonasabah : string;
      jenis : string;
      uang : string;
      saldo : real;
      setrutin : real;
      autodebet : string;
      waktu : string;
      tglmulai : string;
    end;

// List Data Rekening Online
    lrekonline = record
      list : array[1..nmax] of rekonline;
      Neff : integer;
    end;

    // SATU DATA Histori Transaksi
      trans = record
        noakun : string;
        jenis : string;
        uang : string;
        jumlah : real;
        saldoakhir : real;
        tgl : string;
      end;

    // List Histori Transaksi
      ltrans = record
        list : array[1..nmax] of trans;
        Neff : integer;
      end;

    // SATU DATA Histori Transfer
      trf = record
        asal : string;
        tujuan : string;
        jenis : string;
        bank : string;
        uang : string;
        jumlah : real;
        saldoakhir : real;
        tgl : string;
      end;

    // List Histori Transfer
      ltrf = record
        list : array[1..nmax] of trf;
        Neff : integer;
      end;

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

      // SATU DATA Histori Pembelian
        pembelian = record
          noakun : string;
          jenis : string;
          penyedia : string;
          nomortujuan : string;
          uang : string;
          jumlah : real;
          saldoakhir : real;
          tgl : string;
        end;

      // List Histori Pembelian
        lpembelian = record
          list : array[1..nmax] of pembelian;
          Neff : integer;
        end;

  // SATU DATA Kurs Mata Uang
  kurs = record
    nawal : real;
    awal : string;
    nakhir : real;
    akhir : string;
  end;

// List Kurs
  lkurs = record
    list : array[1..maxkurs] of kurs;
    Neff : integer;
  end;

// SATU DATA Penyedia "Jasa" (yang bisa dibeli)
  barang = record
    jenis : string;
    penyedia : string;
    harga : real;
  end;

// List Barang
  lbarang = record
    list : array[1..nmax] of barang;
    Neff : integer;
  end;

  // Variabel dibawah adalah variabel pendukung data internal bank
var
  cmd, fname, user, pass : string;
  { cmd : penampung masukan perintah dari user }
  ft : text;
  pil, attempt, i : integer;
   { attempt : menampung jumlah 'retries' yang tersisa jika user salah memasukan data saat login }
  arrnasabah : lnasabah;
  arrrekonline : lrekonline;
  arrtransaksi : ltrans;
  arrtransfer : ltrf;
  arrbayar : lpembayaran;
  arrbeli : lpembelian;
  arrkurs : lkurs;
  arrbarang : lbarang;

  // Array untuk menampung nama file apa saja yang sudah dimuat ke array internal
  // 1 : nama file nasabah, 2 : nama file rekening online, dst... (lihat urutan array diatas)
  loadedFile : array[1..8] of string;
  currentuser : nasabah;   // Variabel menampung user yang sedang login sekarang
implementation

end.
