import 'package:flutter/material.dart';

import '../models/quiz_pack.dart';
import '../models/quiz_question.dart';

QuizQuestion _question(
  String prompt,
  List<String> options,
  int correctAnswerIndex,
  String explanation,
) {
  return QuizQuestion(
    category: '',
    question: prompt,
    options: options,
    correctAnswerIndex: correctAnswerIndex,
    explanation: explanation,
    icon: Icons.quiz_rounded,
  );
}

QuizQuestion _extraQuestion(
  String prompt,
  String answer,
  List<String> distractors,
  String explanation,
) {
  final answerIndex = prompt.runes.fold<int>(0, (sum, rune) => sum + rune) % 4;
  final options = List<String>.of(distractors)..insert(answerIndex, answer);
  return _question(prompt, options, answerIndex, explanation);
}

final _additionalQuestions = <String, List<QuizQuestion>>{
  'Pengetahuan Umum': [
    _extraQuestion('Ibu kota Kanada adalah...', 'Ottawa', [
      'Toronto',
      'Vancouver',
      'Montreal',
    ], 'Ottawa adalah ibu kota Kanada.'),
    _extraQuestion('Mata uang resmi Indonesia adalah...', 'Rupiah', [
      'Ringgit',
      'Baht',
      'Peso',
    ], 'Indonesia menggunakan rupiah sebagai mata uang resminya.'),
    _extraQuestion(
      'Benua terbesar berdasarkan luas wilayah adalah...',
      'Asia',
      ['Afrika', 'Eropa', 'Amerika Selatan'],
      'Asia merupakan benua terbesar di dunia.',
    ),
    _extraQuestion('Berapa jumlah sisi pada sebuah segitiga?', 'Tiga', [
      'Dua',
      'Empat',
      'Lima',
    ], 'Segitiga memiliki tiga sisi dan tiga sudut.'),
    _extraQuestion(
      'Markas besar Perserikatan Bangsa-Bangsa berada di kota...',
      'New York',
      ['Jenewa', 'Paris', 'Roma'],
      'Markas besar PBB berada di New York, Amerika Serikat.',
    ),
    _extraQuestion(
      'Mamalia terbesar yang hidup saat ini adalah...',
      'Paus biru',
      ['Gajah Afrika', 'Jerapah', 'Hiu putih'],
      'Paus biru adalah hewan terbesar yang diketahui hidup saat ini.',
    ),
    _extraQuestion('Alat untuk mengukur suhu disebut...', 'Termometer', [
      'Barometer',
      'Higrometer',
      'Anemometer',
    ], 'Termometer digunakan untuk mengukur suhu.'),
    _extraQuestion(
      'Bahasa resmi utama yang digunakan di Brasil adalah...',
      'Portugis',
      ['Spanyol', 'Prancis', 'Italia'],
      'Brasil menggunakan bahasa Portugis sebagai bahasa resminya.',
    ),
    _extraQuestion(
      'Logam yang berbentuk cair pada suhu ruang adalah...',
      'Raksa',
      ['Besi', 'Aluminium', 'Tembaga'],
      'Raksa atau merkuri berbentuk cair pada suhu ruang.',
    ),
    _extraQuestion(
      'Hari Pendidikan Nasional Indonesia diperingati setiap...',
      '2 Mei',
      ['21 April', '17 Agustus', '10 November'],
      'Hari Pendidikan Nasional diperingati setiap 2 Mei.',
    ),
  ],
  'Dunia dan Geografi': [
    _extraQuestion('Ibu kota Australia adalah...', 'Canberra', [
      'Sydney',
      'Melbourne',
      'Perth',
    ], 'Canberra adalah ibu kota Australia, bukan Sydney atau Melbourne.'),
    _extraQuestion(
      'Garis khayal yang membagi Bumi menjadi belahan utara dan selatan disebut...',
      'Khatulistiwa',
      ['Garis bujur utama', 'Garis balik utara', 'Lingkar Arktik'],
      'Khatulistiwa berada pada lintang nol derajat.',
    ),
    _extraQuestion('Gurun Sahara terletak di benua...', 'Afrika', [
      'Asia',
      'Australia',
      'Amerika Selatan',
    ], 'Gurun Sahara membentang luas di Afrika Utara.'),
    _extraQuestion(
      'Negara dengan wilayah terluas di dunia adalah...',
      'Rusia',
      ['Kanada', 'Tiongkok', 'Amerika Serikat'],
      'Rusia memiliki wilayah daratan terluas di dunia.',
    ),
    _extraQuestion('Mata uang Jepang adalah...', 'Yen', [
      'Won',
      'Yuan',
      'Baht',
    ], 'Yen merupakan mata uang Jepang.'),
    _extraQuestion(
      'Great Barrier Reef berada di lepas pantai negara...',
      'Australia',
      ['India', 'Meksiko', 'Afrika Selatan'],
      'Great Barrier Reef terletak di lepas pantai Queensland, Australia.',
    ),
    _extraQuestion(
      'Negara yang terkenal dengan fjord dan berada di Skandinavia adalah...',
      'Norwegia',
      ['Portugal', 'Yunani', 'Mesir'],
      'Norwegia dikenal memiliki banyak fjord di sepanjang pesisirnya.',
    ),
    _extraQuestion('Kota Istanbul berada di negara...', 'Turki', [
      'Maroko',
      'India',
      'Argentina',
    ], 'Istanbul adalah kota besar di Turki yang berada di dua benua.'),
    _extraQuestion(
      'Pegunungan Andes membentang di kawasan...',
      'Amerika Selatan',
      ['Eropa Utara', 'Asia Timur', 'Afrika Tengah'],
      'Pegunungan Andes membentang di sisi barat Amerika Selatan.',
    ),
    _extraQuestion('Sungai Nil mengalir terutama di kawasan...', 'Afrika', [
      'Eropa',
      'Amerika Utara',
      'Australia',
    ], 'Sungai Nil merupakan sungai utama di Afrika bagian timur laut.'),
  ],
  'Sains Sehari-hari': [
    _extraQuestion('Simbol kimia untuk oksigen adalah...', 'O', [
      'Ox',
      'Og',
      'N',
    ], 'O adalah simbol kimia unsur oksigen.'),
    _extraQuestion(
      'Satuan gaya dalam Sistem Internasional adalah...',
      'Newton',
      ['Joule', 'Watt', 'Pascal'],
      'Gaya diukur dalam satuan newton.',
    ),
    _extraQuestion(
      'Perubahan wujud dari padat langsung menjadi gas disebut...',
      'Menyublim',
      ['Mencair', 'Membeku', 'Mengembun'],
      'Menyublim adalah perubahan dari padat langsung ke gas.',
    ),
    _extraQuestion('Nilai pH netral pada skala umum adalah...', '7', [
      '1',
      '5',
      '14',
    ], 'Larutan netral memiliki pH sekitar 7 pada kondisi standar.'),
    _extraQuestion(
      'Alat untuk melihat benda yang sangat kecil adalah...',
      'Mikroskop',
      ['Teleskop', 'Periskop', 'Barometer'],
      'Mikroskop memperbesar objek kecil agar dapat diamati.',
    ),
    _extraQuestion(
      'Sumber energi utama bagi sebagian besar kehidupan di Bumi adalah...',
      'Matahari',
      ['Bulan', 'Angin', 'Batu bara'],
      'Cahaya dan panas Matahari mendukung banyak proses kehidupan di Bumi.',
    ),
    _extraQuestion('Satuan kuat arus listrik adalah...', 'Ampere', [
      'Volt',
      'Ohm',
      'Watt',
    ], 'Kuat arus listrik diukur dalam ampere.'),
    _extraQuestion(
      'Gas yang diserap tumbuhan saat fotosintesis adalah...',
      'Karbon dioksida',
      ['Oksigen', 'Helium', 'Hidrogen'],
      'Tumbuhan menggunakan karbon dioksida dan air dalam fotosintesis.',
    ),
    _extraQuestion(
      'Organ yang membantu manusia bernapas dengan mengambil oksigen dari udara adalah...',
      'Paru-paru',
      ['Lambung', 'Pankreas', 'Usus halus'],
      'Paru-paru menjadi organ utama pertukaran gas saat bernapas.',
    ),
    _extraQuestion(
      'Bahan yang dapat ditarik kuat oleh magnet, seperti besi, disebut...',
      'Feromagnetik',
      ['Transparan', 'Elastis', 'Isolator'],
      'Bahan feromagnetik seperti besi dapat tertarik kuat oleh magnet.',
    ),
  ],
  'Fakta Unik': [
    _extraQuestion('Berapa jumlah kaki serangga dewasa pada umumnya?', 'Enam', [
      'Tiga',
      'Empat',
      'Lima',
    ], 'Serangga memiliki tiga pasang kaki, sehingga jumlahnya enam.'),
    _extraQuestion(
      'Warna darah gurita tampak kebiruan karena mengandung...',
      'Hem sianin berbasis tembaga',
      ['Hemoglobin berbasis besi', 'Klorofil', 'Melanin'],
      'Gurita menggunakan hemosianin yang mengandung tembaga untuk mengikat oksigen.',
    ),
    _extraQuestion(
      'Mamalia yang dapat terbang dengan kepakan sayap adalah...',
      'Kelelawar',
      ['Tupai terbang', 'Lemur', 'Kukang'],
      'Kelelawar adalah mamalia yang mampu terbang aktif.',
    ),
    _extraQuestion(
      'Hewan yang dapat mengubah warna kulit untuk berkamuflase adalah...',
      'Bunglon',
      ['Kelinci', 'Kuda', 'Paus'],
      'Bunglon dapat mengubah warna kulit untuk berbagai fungsi, termasuk komunikasi dan kamuflase.',
    ),
    _extraQuestion(
      'Kelompok hewan yang dikenal memiliki kemampuan regenerasi lengan adalah...',
      'Bintang laut',
      ['Ayam', 'Kupu-kupu', 'Kuda'],
      'Beberapa bintang laut dapat menumbuhkan kembali lengan yang hilang.',
    ),
    _extraQuestion('Burung yang dapat terbang mundur adalah...', 'Kolibri', [
      'Elang',
      'Burung unta',
      'Albatros',
    ], 'Kolibri mampu terbang mundur berkat gerakan sayapnya yang khas.'),
    _extraQuestion(
      'Hewan yang menggunakan ekolokasi untuk bernavigasi di air adalah...',
      'Lumba-lumba',
      ['Kura-kura', 'Iguana', 'Kambing'],
      'Lumba-lumba memakai pantulan bunyi untuk membantu mengenali lingkungan.',
    ),
    _extraQuestion(
      'Hewan berkantung yang menjadi simbol Australia adalah...',
      'Kanguru',
      ['Panda', 'Llama', 'Beruang kutub'],
      'Kanguru adalah marsupial yang sangat dikenal dari Australia.',
    ),
    _extraQuestion(
      'Indra yang paling dikenal tajam pada anjing adalah...',
      'Penciuman',
      ['Penglihatan warna', 'Pengecap rasa manis', 'Pendengaran ultrasonik'],
      'Anjing memiliki indra penciuman yang sangat berkembang.',
    ),
    _extraQuestion(
      'Bayi katak yang hidup di air sebelum tumbuh menjadi katak disebut...',
      'Berudu',
      ['Kepompong', 'Larva kupu-kupu', 'Nimfa'],
      'Berudu adalah tahap awal kehidupan katak yang umumnya hidup di air.',
    ),
  ],
  'Dunia Kuliner': [
    _extraQuestion(
      'Rendang berasal dari tradisi kuliner...',
      'Minangkabau',
      ['Betawi', 'Manado', 'Sunda'],
      'Rendang merupakan hidangan yang berasal dari tradisi Minangkabau, Sumatra Barat.',
    ),
    _extraQuestion('Bahan utama tahu adalah...', 'Kedelai', [
      'Singkong',
      'Beras',
      'Kacang tanah',
    ], 'Tahu dibuat dari sari kedelai yang digumpalkan.'),
    _extraQuestion('Sushi berasal dari negara...', 'Jepang', [
      'India',
      'Peru',
      'Turki',
    ], 'Sushi berkembang dalam tradisi kuliner Jepang.'),
    _extraQuestion('Bahan utama guacamole adalah...', 'Alpukat', [
      'Tomat',
      'Kentang',
      'Kelapa',
    ], 'Guacamole adalah saus yang bahan utamanya alpukat.'),
    _extraQuestion(
      'Ragi membantu adonan roti mengembang dengan menghasilkan...',
      'Karbon dioksida',
      ['Oksigen murni', 'Nitrogen', 'Helium'],
      'Ragi memfermentasi gula dan menghasilkan karbon dioksida yang membantu adonan mengembang.',
    ),
    _extraQuestion(
      'Rempah yang memberi warna kuning khas pada banyak masakan adalah...',
      'Kunyit',
      ['Lada putih', 'Kapulaga', 'Vanili'],
      'Kurkumin dalam kunyit memberikan warna kuning-oranye.',
    ),
    _extraQuestion(
      'Bahan utama pasta Italia umumnya adalah...',
      'Gandum durum',
      ['Tepung singkong', 'Tepung jagung saja', 'Tepung kelapa'],
      'Banyak pasta dibuat dari semolina gandum durum dan air.',
    ),
    _extraQuestion(
      'Minuman teh dibuat dengan menyeduh daun tanaman...',
      'Camellia sinensis',
      ['Mentha spicata', 'Coffea arabica', 'Theobroma cacao'],
      'Teh sejati berasal dari daun Camellia sinensis.',
    ),
    _extraQuestion(
      'Makanan yang diawetkan dengan larutan garam atau cuka mengalami proses...',
      'Pengasinan atau pengasaman',
      ['Pembekuan cepat', 'Pemanggangan kering', 'Pengkaramelan'],
      'Garam atau cuka dapat membantu mengawetkan makanan melalui pengasinan atau pengasaman.',
    ),
    _extraQuestion('Keju umumnya dibuat dari bahan dasar...', 'Susu', [
      'Air kelapa',
      'Tepung beras',
      'Jus buah',
    ], 'Keju dibuat dengan mengolah susu dan memisahkan dadihnya.'),
  ],
  'Kenalan dengan Hewan': [
    _extraQuestion('Katak termasuk kelompok hewan...', 'Amfibi', [
      'Mamalia',
      'Burung',
      'Ikan',
    ], 'Katak adalah amfibi yang menjalani tahap hidup di air dan di darat.'),
    _extraQuestion(
      'Hewan yang memiliki belalai panjang adalah...',
      'Gajah',
      ['Badak', 'Kuda nil', 'Jerapah'],
      'Belalai gajah merupakan organ serbaguna untuk mengambil makanan dan air.',
    ),
    _extraQuestion(
      'Kelompok hewan yang memberi makan anaknya dengan susu disebut...',
      'Mamalia',
      ['Reptil', 'Serangga', 'Ikan bertulang rawan'],
      'Mamalia memiliki kelenjar susu untuk menyusui anaknya.',
    ),
    _extraQuestion(
      'Hewan yang membangun jaring untuk menangkap mangsa adalah...',
      'Laba-laba',
      ['Lebah madu', 'Kupu-kupu', 'Capung'],
      'Banyak jenis laba-laba membuat jaring dari benang sutra.',
    ),
    _extraQuestion(
      'Rangka luar keras pada kepiting disebut...',
      'Eksoskeleton',
      ['Endoskeleton', 'Tulang rawan', 'Cangkang telur'],
      'Kepiting memiliki rangka luar yang melindungi tubuhnya.',
    ),
    _extraQuestion(
      'Kelompok hewan yang umumnya aktif pada malam hari disebut...',
      'Nokturnal',
      ['Diurnal', 'Herbivor', 'Migran'],
      'Hewan nokturnal aktif terutama pada malam hari.',
    ),
    _extraQuestion('Panda besar terutama memakan...', 'Bambu', [
      'Ikan laut',
      'Rumput laut',
      'Serangga saja',
    ], 'Sebagian besar makanan panda besar terdiri dari bambu.'),
    _extraQuestion(
      'Hewan yang membawa anaknya dalam kantung termasuk...',
      'Marsupial',
      ['Amfibi', 'Burung air', 'Moluska'],
      'Marsupial seperti kanguru membesarkan anaknya di dalam kantung.',
    ),
    _extraQuestion(
      'Lapisan pelindung tubuh kura-kura disebut...',
      'Karapas dan plastron',
      ['Bulu dan sisik', 'Sirip dan insang', 'Surai dan kuku'],
      'Cangkang kura-kura tersusun dari bagian atas karapas dan bagian bawah plastron.',
    ),
    _extraQuestion('Hewan pemakan tumbuhan disebut...', 'Herbivor', [
      'Karnivor',
      'Omnivor',
      'Insektivor',
    ], 'Herbivor memperoleh sebagian besar makanannya dari tumbuhan.'),
  ],
  'Dasar Kriptografi': [
    _extraQuestion(
      'Pesan asli sebelum dienkripsi disebut...',
      'Plaintext',
      ['Ciphertext', 'Checksum', 'Metadata'],
      'Plaintext adalah data yang masih dapat dibaca sebelum proses enkripsi.',
    ),
    _extraQuestion(
      'Pesan hasil enkripsi yang tidak langsung terbaca disebut...',
      'Ciphertext',
      ['Plaintext', 'Kunci publik', 'Tanda waktu'],
      'Ciphertext adalah keluaran yang telah diubah oleh proses enkripsi.',
    ),
    _extraQuestion(
      'Dalam enkripsi, informasi yang mengendalikan proses pengubahan pesan disebut...',
      'Kunci',
      ['Alamat jaringan', 'Nama berkas', 'Panjang kabel'],
      'Kunci kriptografi mengendalikan proses enkripsi atau dekripsi.',
    ),
    _extraQuestion(
      'Algoritma AES termasuk jenis kriptografi...',
      'Simetris',
      ['Kunci publik saja', 'Hash satu arah', 'Kompresi tanpa kunci'],
      'AES adalah algoritma enkripsi simetris yang menggunakan kunci rahasia.',
    ),
    _extraQuestion(
      'Dalam kriptografi asimetris, pasangan kunci terdiri dari...',
      'Kunci publik dan kunci privat',
      ['Dua kunci publik', 'Dua kata sandi sama', 'Kunci dan checksum'],
      'Kriptografi asimetris menggunakan pasangan kunci publik dan privat.',
    ),
    _extraQuestion(
      'Untuk mengirim data rahasia kepada pemilik kunci publik, pesan biasanya dienkripsi dengan...',
      'Kunci publik penerima',
      ['Kunci privat penerima', 'Kunci publik pengirim saja', 'Hash pesan'],
      'Penerima menggunakan kunci privat pasangannya untuk membuka data yang dienkripsi dengan kunci publiknya.',
    ),
    _extraQuestion(
      'Tujuan utama menggunakan nilai salt saat menyimpan hash kata sandi adalah...',
      'Membuat hash tiap kata sandi lebih unik',
      [
        'Menyimpan kata sandi dalam teks biasa',
        'Menghilangkan kebutuhan autentikasi',
        'Membuat kata sandi dapat dibalik',
      ],
      'Salt unik membantu mencegah penggunaan ulang tabel hash yang telah dihitung sebelumnya.',
    ),
    _extraQuestion(
      'Praktik yang baik untuk kata sandi adalah...',
      'Menggunakan kata sandi unik untuk setiap akun',
      [
        'Menggunakan satu kata sandi di semua situs',
        'Membagikannya kepada teman',
        'Menulisnya pada profil publik',
      ],
      'Kata sandi unik membatasi dampak jika satu layanan mengalami kebocoran.',
    ),
    _extraQuestion(
      'Protokol yang umum digunakan untuk mengamankan koneksi web adalah...',
      'TLS',
      ['FTP tanpa enkripsi', 'Telnet', 'HTTP tanpa perlindungan'],
      'TLS membantu melindungi kerahasiaan dan integritas data saat transit.',
    ),
    _extraQuestion(
      'Kunci kriptografi sebaiknya dibuat dengan sumber...',
      'Acak yang aman secara kriptografis',
      ['Nomor urut sederhana', 'Nama pengguna', 'Tanggal lahir'],
      'Kunci perlu dibuat dengan sumber acak yang kuat agar sulit ditebak.',
    ),
  ],
  'Sandi Klasik': [
    _extraQuestion(
      'Jika sandi Caesar menggeser huruf 3 langkah maju, huruf B menjadi...',
      'E',
      ['C', 'D', 'F'],
      'B bergeser tiga posisi menjadi E.',
    ),
    _extraQuestion(
      'Dalam sandi Caesar alfabet berulang setelah huruf...',
      'Z',
      ['X', 'Y', 'A'],
      'Setelah Z, pergeseran kembali ke awal alfabet.',
    ),
    _extraQuestion(
      'Sandi Vigenere menggunakan kata kunci untuk menentukan...',
      'Pergeseran huruf yang berubah-ubah',
      ['Warna setiap huruf', 'Urutan halaman buku', 'Jumlah kata dalam pesan'],
      'Vigenere memakai huruf kunci berulang untuk menentukan pergeseran yang berbeda.',
    ),
    _extraQuestion(
      'Sandi transposisi mengubah pesan terutama dengan cara...',
      'Mengatur ulang posisi huruf',
      [
        'Mengganti setiap huruf dengan angka acak',
        'Menghapus semua konsonan',
        'Menerjemahkan pesan ke bahasa lain',
      ],
      'Sandi transposisi mengubah susunan huruf tanpa harus mengganti hurufnya.',
    ),
    _extraQuestion(
      'Analisis frekuensi pada sandi klasik memanfaatkan...',
      'Seberapa sering huruf muncul dalam bahasa',
      ['Warna tinta yang digunakan', 'Ukuran kertas', 'Waktu pesan dibuat'],
      'Frekuensi kemunculan huruf dapat membantu mengenali pola pada sandi substitusi sederhana.',
    ),
    _extraQuestion('Pada Atbash, huruf B dipasangkan dengan...', 'Y', [
      'X',
      'Z',
      'A',
    ], 'Atbash membalik alfabet: A dengan Z, B dengan Y, dan seterusnya.'),
    _extraQuestion(
      'Sandi Caesar dengan pergeseran 0 akan...',
      'Membiarkan huruf tetap sama',
      [
        'Membalik urutan kata',
        'Menggandakan setiap huruf',
        'Mengubah semua huruf menjadi angka',
      ],
      'Pergeseran nol tidak mengubah huruf pada pesan.',
    ),
    _extraQuestion(
      'Sandi klasik yang menggunakan kisi dan menukar urutan kolom disebut...',
      'Transposisi kolom',
      ['Caesar', 'Atbash', 'ROT13'],
      'Transposisi kolom menyusun pesan dalam kisi lalu membaca kolom dengan urutan tertentu.',
    ),
    _extraQuestion(
      'Mengapa sandi substitusi sederhana rentan terhadap analisis frekuensi?',
      'Pola kemunculan huruf bahasa sering tetap terlihat',
      [
        'Pesan selalu terlalu pendek',
        'Kertasnya mudah rusak',
        'Huruf tidak bisa diulang',
      ],
      'Substitusi satu-ke-satu mempertahankan pola frekuensi huruf dari bahasa asli.',
    ),
    _extraQuestion(
      'Sandi klasik paling tepat digunakan untuk...',
      'Latihan memahami konsep dasar sandi',
      [
        'Melindungi data penting masa kini',
        'Menyimpan rahasia perbankan',
        'Mengamankan seluruh jaringan',
      ],
      'Sandi klasik bermanfaat untuk belajar, tetapi tidak cukup aman untuk perlindungan modern.',
    ),
  ],
  'Kunci, Hash, dan Keamanan': [
    _extraQuestion(
      'Hash kriptografis menghasilkan keluaran yang umumnya...',
      'Berukuran tetap untuk fungsi yang sama',
      [
        'Selalu sama panjang dengan masukan',
        'Dapat dibalik langsung',
        'Berisi kunci privat',
      ],
      'Fungsi hash menghasilkan digest dengan ukuran tetap untuk algoritma tertentu.',
    ),
    _extraQuestion(
      'Sifat tahan benturan pada hash berarti sulit menemukan...',
      'Dua masukan berbeda dengan hash yang sama',
      [
        'Masukan yang menghasilkan teks panjang',
        'Kunci publik dari sertifikat',
        'Dua berkas dengan nama berbeda',
      ],
      'Tahan benturan berarti sulit mencari dua masukan berbeda dengan digest identik.',
    ),
    _extraQuestion(
      'Untuk menyimpan kata sandi, sistem sebaiknya menggunakan...',
      'Fungsi hash khusus kata sandi dengan salt',
      [
        'Enkripsi yang kuncinya ditulis di halaman',
        'Teks biasa',
        'Encoding Base64 saja',
      ],
      'Hash kata sandi yang lambat dan bersalt dirancang untuk mempersulit tebakan kata sandi yang bocor.',
    ),
    _extraQuestion(
      'Tanda tangan digital dibuat oleh penanda tangan menggunakan...',
      'Kunci privatnya',
      [
        'Kunci publik penerima',
        'Kata sandi situs',
        'Hash acak yang tidak terkait',
      ],
      'Penanda tangan menggunakan kunci privat untuk membuat tanda tangan digital.',
    ),
    _extraQuestion(
      'Penerima memeriksa tanda tangan digital dengan...',
      'Kunci publik penanda tangan',
      ['Kunci privat penanda tangan', 'Kunci Wi-Fi', 'Kode pos pengirim'],
      'Kunci publik pasangan digunakan untuk memverifikasi tanda tangan digital.',
    ),
    _extraQuestion(
      'Sertifikat digital membantu menghubungkan identitas dengan...',
      'Kunci publik',
      ['Kata sandi pengguna', 'Alamat rumah', 'Kunci privat yang dibagikan'],
      'Sertifikat digital mengikat identitas tertentu dengan kunci publik dan ditandatangani otoritas tepercaya.',
    ),
    _extraQuestion(
      'Autentikasi multifaktor meningkatkan keamanan dengan meminta...',
      'Lebih dari satu jenis bukti identitas',
      [
        'Kata sandi yang sama dua kali',
        'Nama pengguna lebih panjang',
        'Alamat surel tambahan saja',
      ],
      'MFA menggabungkan faktor berbeda, misalnya sesuatu yang diketahui dan sesuatu yang dimiliki.',
    ),
    _extraQuestion(
      'Tujuan utama fungsi hash pada pemeriksaan berkas adalah membantu memeriksa...',
      'Integritas berkas',
      ['Warna berkas', 'Kecepatan layar', 'Kapasitas baterai'],
      'Digest hash dapat dibandingkan untuk mendeteksi perubahan pada berkas.',
    ),
    _extraQuestion(
      'Kunci privat dalam sistem tanda tangan digital harus...',
      'Dijaga oleh pemiliknya',
      [
        'Diunggah ke situs publik',
        'Dikirim bersama setiap tanda tangan',
        'Dibagikan kepada semua penerima',
      ],
      'Kunci privat tidak boleh dibagikan agar pihak lain tidak dapat menandatangani atas nama pemilik.',
    ),
    _extraQuestion(
      'Ikon gembok pada peramban terutama menunjukkan bahwa...',
      'Koneksi menggunakan perlindungan TLS',
      [
        'Situs pasti jujur dan tepercaya',
        'Isi situs selalu benar',
        'Perangkat bebas dari malware',
      ],
      'TLS melindungi koneksi, tetapi ikon gembok tidak menjamin isi atau reputasi situs.',
    ),
  ],
  'Bahasa Indonesia': [
    _extraQuestion(
      'Dalam kalimat “Adik membaca buku”, kata kerja utamanya adalah...',
      'Membaca',
      ['Adik', 'Buku', 'Kalimat'],
      'Membaca menyatakan tindakan yang dilakukan subjek.',
    ),
    _extraQuestion('Kata baku yang tepat adalah...', 'Apotek', [
      'Apotik',
      'Apoteik',
      'Apoték',
    ], 'Bentuk baku menurut KBBI adalah apotek.'),
    _extraQuestion('Persamaan makna kata “indah” adalah...', 'Elok', [
      'Buruk',
      'Kasar',
      'Bising',
    ], 'Elok memiliki makna yang serupa dengan indah.'),
    _extraQuestion('Antonim kata “hemat” adalah...', 'Boros', [
      'Cermat',
      'Irit',
      'Teliti',
    ], 'Boros merupakan lawan makna hemat.'),
    _extraQuestion(
      'Pantun umumnya terdiri atas berapa baris dalam satu bait?',
      'Empat',
      ['Dua', 'Tiga', 'Enam'],
      'Pantun umumnya memiliki empat baris dalam satu bait.',
    ),
    _extraQuestion(
      'Kata depan “di” pada frasa “di rumah” ditulis...',
      'Terpisah dari kata sesudahnya',
      ['Selalu digabung', 'Dengan tanda hubung', 'Dengan huruf kapital semua'],
      'Kata depan di ditulis terpisah, berbeda dari imbuhan di- pada kata kerja.',
    ),
    _extraQuestion(
      'Tanda baca yang digunakan untuk mengapit petikan langsung adalah...',
      'Tanda petik',
      ['Tanda kurung siku', 'Tanda garis miring', 'Tanda hubung'],
      'Petikan langsung diapit tanda petik.',
    ),
    _extraQuestion(
      'Kata penghubung yang menyatakan sebab adalah...',
      'Karena',
      ['Tetapi', 'Atau', 'Kemudian'],
      'Kata karena menghubungkan peristiwa dengan penyebabnya.',
    ),
    _extraQuestion('Huruf kapital digunakan pada awal...', 'Nama orang', [
      'Setiap kata dalam kalimat',
      'Semua kata benda',
      'Kata setelah koma saja',
    ], 'Nama orang ditulis dengan huruf kapital pada awal unsur namanya.'),
    _extraQuestion(
      'Kalimat yang berisi ajakan biasanya menggunakan kata...',
      'Marilah',
      ['Mungkin', 'Kemarin', 'Walaupun'],
      'Marilah dapat digunakan untuk menyampaikan ajakan.',
    ),
  ],
  'Sejarah Nusantara': [
    _extraQuestion('Dasar negara Republik Indonesia adalah...', 'Pancasila', [
      'Trisila',
      'Sapta Marga',
      'Dekret Presiden',
    ], 'Pancasila merupakan dasar negara Indonesia.'),
    _extraQuestion(
      'Candi Borobudur merupakan peninggalan bercorak...',
      'Buddha',
      ['Yunani', 'Romawi', 'Mesir kuno'],
      'Borobudur adalah candi Buddha yang dibangun pada masa Wangsa Syailendra.',
    ),
    _extraQuestion(
      'Tokoh yang dikenal dengan Sumpah Palapa adalah...',
      'Gajah Mada',
      ['Hayam Wuruk', 'Ken Arok', 'Pati Unus'],
      'Gajah Mada mengucapkan Sumpah Palapa dalam tradisi sejarah Majapahit.',
    ),
    _extraQuestion(
      'Hari Kebangkitan Nasional diperingati setiap...',
      '20 Mei',
      ['2 Mei', '28 Oktober', '1 Juni'],
      'Tanggal 20 Mei merujuk pada berdirinya Budi Utomo pada 1908.',
    ),
    _extraQuestion(
      'Tokoh emansipasi perempuan yang diperingati setiap 21 April adalah...',
      'R.A. Kartini',
      ['Dewi Sartika', 'Cut Nyak Dien', 'Martha Christina Tiahahu'],
      'Hari Kartini diperingati pada tanggal kelahiran R.A. Kartini.',
    ),
    _extraQuestion(
      'Kongres Pemuda II yang melahirkan Sumpah Pemuda berlangsung pada tahun...',
      '1928',
      ['1908', '1945', '1955'],
      'Sumpah Pemuda lahir dari Kongres Pemuda II pada 28 Oktober 1928.',
    ),
    _extraQuestion(
      'Kerajaan Majapahit mencapai puncak kejayaan pada masa pemerintahan...',
      'Hayam Wuruk',
      ['Airlangga', 'Purnawarman', 'Sultan Agung'],
      'Majapahit mencapai masa kejayaan pada masa Hayam Wuruk dengan dukungan Gajah Mada.',
    ),
    _extraQuestion(
      'Hari Lahir Pancasila diperingati pada tanggal...',
      '1 Juni',
      ['17 Agustus', '10 November', '22 Desember'],
      'Tanggal 1 Juni memperingati pidato Soekarno mengenai dasar negara pada 1945.',
    ),
    _extraQuestion(
      'Peristiwa Rengasdengklok terjadi menjelang...',
      'Proklamasi Kemerdekaan Indonesia',
      ['Kongres Pemuda I', 'Perang Diponegoro', 'Konferensi Asia Afrika'],
      'Peristiwa Rengasdengklok terjadi menjelang pembacaan proklamasi pada 17 Agustus 1945.',
    ),
    _extraQuestion(
      'Konferensi Asia Afrika tahun 1955 diselenggarakan di kota...',
      'Bandung',
      ['Yogyakarta', 'Surabaya', 'Makassar'],
      'Konferensi Asia Afrika diselenggarakan di Bandung pada 1955.',
    ),
  ],
  'Matematika Dasar': [
    _extraQuestion('Berapakah hasil dari 7 × 9?', '63', [
      '56',
      '64',
      '72',
    ], 'Tujuh dikalikan sembilan sama dengan 63.'),
    _extraQuestion('Berapakah hasil dari 144 ÷ 12?', '12', [
      '10',
      '11',
      '14',
    ], '144 dibagi 12 sama dengan 12.'),
    _extraQuestion('Nilai dari 2 pangkat 5 adalah...', '32', [
      '10',
      '16',
      '25',
    ], '2 pangkat 5 berarti 2 × 2 × 2 × 2 × 2, hasilnya 32.'),
    _extraQuestion('Jumlah sudut dalam sebuah segitiga adalah...', '180°', [
      '90°',
      '270°',
      '360°',
    ], 'Jumlah sudut dalam segitiga pada geometri Euclid adalah 180 derajat.'),
    _extraQuestion('Berapakah 15% dari 200?', '30', [
      '15',
      '20',
      '35',
    ], '15% dari 200 adalah 0,15 × 200 = 30.'),
    _extraQuestion(
      'Luas persegi panjang dengan panjang 8 cm dan lebar 3 cm adalah...',
      '24 cm²',
      ['11 cm²', '22 cm²', '32 cm²'],
      'Luas persegi panjang adalah panjang dikali lebar, yaitu 8 × 3 = 24 cm².',
    ),
    _extraQuestion('Bentuk pecahan sederhana dari 0,4 adalah...', '2/5', [
      '1/4',
      '3/5',
      '4/5',
    ], '0,4 sama dengan 4/10 yang disederhanakan menjadi 2/5.'),
    _extraQuestion('Rata-rata dari 4, 6, dan 8 adalah...', '6', [
      '4',
      '5',
      '8',
    ], 'Rata-ratanya adalah (4 + 6 + 8) ÷ 3 = 6.'),
    _extraQuestion(
      'Bilangan prima terkecil adalah...',
      '2',
      ['0', '1', '3'],
      'Dua adalah bilangan prima terkecil dan satu-satunya bilangan prima genap.',
    ),
    _extraQuestion('Satu kilometer sama dengan...', '1.000 meter', [
      '100 meter',
      '10.000 meter',
      '100.000 meter',
    ], 'Awalan kilo berarti seribu, jadi satu kilometer adalah seribu meter.'),
  ],
  'Budaya Indonesia': [
    _extraQuestion(
      'Rumah Joglo dikenal sebagai rumah tradisional dari...',
      'Jawa',
      ['Papua', 'Maluku', 'Nusa Tenggara Timur'],
      'Rumah Joglo merupakan salah satu rumah tradisional masyarakat Jawa.',
    ),
    _extraQuestion(
      'Alat musik sasando berasal dari...',
      'Pulau Rote',
      ['Pulau Madura', 'Pulau Weh', 'Pulau Bangka'],
      'Sasando adalah alat musik petik tradisional dari Pulau Rote, Nusa Tenggara Timur.',
    ),
    _extraQuestion(
      'Tari Kecak berasal dari...',
      'Bali',
      ['Aceh', 'Sumatra Barat', 'Kalimantan Selatan'],
      'Tari Kecak berkembang di Bali dan dikenal dengan paduan suara penarinya.',
    ),
    _extraQuestion(
      'Papeda merupakan makanan khas yang banyak dikenal di kawasan...',
      'Papua dan Maluku',
      ['Jawa Tengah', 'Bali', 'Sumatra Utara'],
      'Papeda berbahan sagu dan dikenal sebagai makanan pokok di Papua serta Maluku.',
    ),
    _extraQuestion(
      'Rumah Honai merupakan rumah tradisional masyarakat...',
      'Papua',
      ['Minangkabau', 'Betawi', 'Bugis'],
      'Honai adalah rumah tradisional yang dikenal dari wilayah pegunungan Papua.',
    ),
    _extraQuestion(
      'Kolintang merupakan alat musik tradisional dari...',
      'Minahasa, Sulawesi Utara',
      ['Banten', 'Aceh', 'Lombok'],
      'Kolintang berkembang di kalangan masyarakat Minahasa di Sulawesi Utara.',
    ),
    _extraQuestion(
      'Tari Piring berasal dari budaya masyarakat...',
      'Minangkabau',
      ['Asmat', 'Banjar', 'Sasak'],
      'Tari Piring merupakan tarian tradisional Minangkabau dari Sumatra Barat.',
    ),
    _extraQuestion(
      'Alat musik sape dikenal dalam tradisi masyarakat...',
      'Dayak di Kalimantan',
      ['Baduy di Banten', 'Mentawai di Sumatra Barat', 'Osing di Jawa Timur'],
      'Sape adalah alat musik petik yang dikenal dari berbagai masyarakat Dayak di Kalimantan.',
    ),
    _extraQuestion(
      'Reog Ponorogo berasal dari provinsi...',
      'Jawa Timur',
      ['Jawa Barat', 'Lampung', 'Sulawesi Barat'],
      'Reog Ponorogo merupakan kesenian tradisional dari Ponorogo, Jawa Timur.',
    ),
    _extraQuestion(
      'Keris diakui UNESCO sebagai bagian dari warisan budaya...',
      'Indonesia',
      ['Thailand', 'Jepang', 'India'],
      'Keris Indonesia diakui UNESCO sebagai Warisan Budaya Takbenda.',
    ),
  ],
  'Literasi Digital': [
    _extraQuestion(
      'Sebelum memasukkan data pribadi pada situs, sebaiknya periksa...',
      'Nama domain dan alamat situs',
      ['Warna latar halaman saja', 'Jumlah gambar', 'Jenis huruf judul'],
      'Memeriksa domain membantu mengenali situs tiruan atau alamat yang keliru.',
    ),
    _extraQuestion(
      'Pembaruan sistem operasi penting karena dapat...',
      'Memperbaiki celah keamanan dan kesalahan',
      [
        'Menjamin perangkat tidak pernah rusak',
        'Menghapus kebutuhan kata sandi',
        'Membuat semua situs tepercaya',
      ],
      'Pembaruan sering membawa perbaikan keamanan dan stabilitas.',
    ),
    _extraQuestion(
      'Prinsip hak akses minimum berarti pengguna mendapat...',
      'Akses secukupnya untuk tugasnya',
      [
        'Akses administrator sepanjang waktu',
        'Akses ke semua data',
        'Akses tanpa autentikasi',
      ],
      'Hak akses minimum membatasi izin sesuai kebutuhan pekerjaan.',
    ),
    _extraQuestion(
      'Salinan cadangan data yang baik sebaiknya...',
      'Disimpan terpisah dari perangkat utama',
      [
        'Hanya disimpan di folder yang sama',
        'Dibagikan ke publik',
        'Tidak pernah diuji',
      ],
      'Salinan terpisah membantu memulihkan data jika perangkat utama rusak atau hilang.',
    ),
    _extraQuestion(
      'Jika akun menerima peringatan masuk yang tidak dikenal, tindakan awal yang baik adalah...',
      'Amankan akun melalui aplikasi atau situs resminya',
      [
        'Klik tautan pada pesan tanpa memeriksa',
        'Bagikan kode verifikasi',
        'Abaikan dan kirim kata sandi ke teman',
      ],
      'Gunakan kanal resmi, ganti kata sandi bila perlu, dan jangan berikan kode verifikasi.',
    ),
    _extraQuestion(
      'Informasi tentang kapan dan dengan perangkat apa foto dibuat dapat tersimpan sebagai...',
      'Metadata',
      ['Kata sandi', 'Cookie wajib', 'Alamat MAC publik'],
      'Metadata dapat memuat waktu, perangkat, atau lokasi jika fitur lokasi aktif.',
    ),
    _extraQuestion(
      'Kode verifikasi sekali pakai sebaiknya...',
      'Tidak dibagikan kepada siapa pun',
      [
        'Dikirim kepada orang yang menelepon',
        'Ditulis di media sosial',
        'Dipakai sebagai kata sandi tetap',
      ],
      'Kode verifikasi dapat memberi akses ke akun dan harus dijaga seperti rahasia.',
    ),
    _extraQuestion(
      'Menggunakan pengelola kata sandi dapat membantu...',
      'Membuat dan menyimpan kata sandi unik',
      [
        'Menjamin semua situs bebas penipuan',
        'Menghapus kebutuhan pembaruan',
        'Membagikan kata sandi otomatis ke publik',
      ],
      'Pengelola kata sandi membantu menyimpan kredensial unik dengan lebih teratur.',
    ),
    _extraQuestion(
      'Sebelum membagikan berita daring, sebaiknya...',
      'Memeriksa sumber, tanggal, dan konteksnya',
      [
        'Hanya membaca judul',
        'Mengubah judul agar viral',
        'Meneruskan tanpa membaca',
      ],
      'Verifikasi membantu mengurangi penyebaran informasi keliru.',
    ),
    _extraQuestion(
      'Perangkat lunak sebaiknya diunduh dari...',
      'Sumber resmi atau toko aplikasi tepercaya',
      [
        'Tautan acak dari pesan',
        'Situs yang meminta mematikan perlindungan',
        'Lampiran tak dikenal',
      ],
      'Sumber resmi mengurangi risiko memasang perangkat lunak berbahaya atau palsu.',
    ),
  ],
};

QuizPack _pack({
  required String title,
  required QuizCategory category,
  required String description,
  required String duration,
  required String difficulty,
  required IconData icon,
  required List<QuizQuestion> questions,
}) {
  final allQuestions = [
    ...questions,
    ...(_additionalQuestions[title] ?? const <QuizQuestion>[]),
  ];
  return QuizPack(
    id: title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), ''),
    title: title,
    category: category,
    description: description,
    duration: allQuestions.length >= 15
        ? '${(allQuestions.length + 2) ~/ 3} menit'
        : duration,
    difficulty: difficulty,
    icon: icon,
    questions: [
      for (final question in allQuestions)
        QuizQuestion(
          category: title,
          question: question.question,
          options: question.options,
          correctAnswerIndex: question.correctAnswerIndex,
          explanation: question.explanation,
          icon: icon,
        ),
    ],
  );
}

final quizCatalog = <QuizPack>[
  _pack(
    title: 'Pengetahuan Umum',
    category: QuizCategory.umum,
    description: 'Uji wawasanmu dari berbagai topik.',
    duration: '3 menit',
    difficulty: 'Pemula',
    icon: Icons.lightbulb_rounded,
    questions: [
      _question(
        'Planet terbesar di tata surya kita adalah...',
        ['Mars', 'Jupiter', 'Saturnus', 'Bumi'],
        1,
        'Jupiter adalah planet terbesar di tata surya.',
      ),
      _question(
        'Ibu kota negara Jepang adalah...',
        ['Kyoto', 'Osaka', 'Tokyo', 'Hiroshima'],
        2,
        'Tokyo merupakan ibu kota Jepang.',
      ),
      _question(
        'Organ tubuh manusia yang memompa darah adalah...',
        ['Paru-paru', 'Hati', 'Ginjal', 'Jantung'],
        3,
        'Jantung memompa darah ke seluruh tubuh.',
      ),
      _question(
        'Kepanjangan CPU adalah...',
        [
          'Central Processing Unit',
          'Computer Personal Utility',
          'Central Program User',
          'Core Power Unit',
        ],
        0,
        'CPU adalah singkatan dari Central Processing Unit.',
      ),
      _question(
        'Bintang yang menjadi pusat tata surya adalah...',
        ['Sirius', 'Matahari', 'Proxima Centauri', 'Vega'],
        1,
        'Matahari adalah bintang di pusat tata surya kita.',
      ),
    ],
  ),
  _pack(
    title: 'Dunia dan Geografi',
    category: QuizCategory.umum,
    description: 'Kenali benua, negara, dan tempat di dunia.',
    duration: '3 menit',
    difficulty: 'Pemula',
    icon: Icons.explore_rounded,
    questions: [
      _question(
        'Samudra terluas di Bumi adalah...',
        ['Atlantik', 'Hindia', 'Pasifik', 'Arktik'],
        2,
        'Samudra Pasifik merupakan samudra terluas di dunia.',
      ),
      _question(
        'Menara Eiffel berada di kota...',
        ['Roma', 'Paris', 'Madrid', 'Lisbon'],
        1,
        'Menara Eiffel adalah salah satu landmark terkenal di Paris, Prancis.',
      ),
      _question(
        'Negara yang dikenal dengan bentuk kepulauan dan memiliki Bali adalah...',
        ['Thailand', 'Indonesia', 'Vietnam', 'Filipina'],
        1,
        'Bali merupakan salah satu pulau di Indonesia.',
      ),
      _question(
        'Gunung Everest berada di kawasan pegunungan...',
        ['Alpen', 'Andes', 'Himalaya', 'Rocky'],
        2,
        'Everest berada di Pegunungan Himalaya di perbatasan Nepal dan Tibet.',
      ),
      _question(
        'Benua tempat negara Mesir berada adalah...',
        ['Afrika', 'Eropa', 'Amerika Selatan', 'Australia'],
        0,
        'Sebagian besar wilayah Mesir berada di Afrika.',
      ),
    ],
  ),
  _pack(
    title: 'Sains Sehari-hari',
    category: QuizCategory.umum,
    description: 'Cari tahu sains di balik hal-hal sederhana.',
    duration: '3 menit',
    difficulty: 'Pemula',
    icon: Icons.science_rounded,
    questions: [
      _question(
        'Rumus kimia air adalah...',
        ['CO₂', 'H₂O', 'O₂', 'NaCl'],
        1,
        'Satu molekul air tersusun dari dua atom hidrogen dan satu oksigen.',
      ),
      _question(
        'Tumbuhan membuat makanan dengan bantuan cahaya melalui proses...',
        ['Fermentasi', 'Fotosintesis', 'Kondensasi', 'Evaporasi'],
        1,
        'Fotosintesis menggunakan cahaya untuk membantu tumbuhan menghasilkan makanan.',
      ),
      _question(
        'Planet yang sering disebut planet merah adalah...',
        ['Venus', 'Mars', 'Merkurius', 'Neptunus'],
        1,
        'Permukaan Mars tampak kemerahan karena mineral kaya besi.',
      ),
      _question(
        'Bunyi tidak dapat merambat melalui...',
        ['Air', 'Udara', 'Benda padat', 'Ruang hampa'],
        3,
        'Bunyi memerlukan medium untuk merambat, sehingga tidak merambat di ruang hampa.',
      ),
      _question(
        'Pada tekanan udara normal di permukaan laut, air mendidih sekitar...',
        ['50°C', '75°C', '100°C', '150°C'],
        2,
        'Titik didih air murni sekitar 100°C pada tekanan satu atmosfer.',
      ),
    ],
  ),
  _pack(
    title: 'Fakta Unik',
    category: QuizCategory.fun,
    description: 'Fakta kecil yang bikin kamu bilang “serius?”',
    duration: '3 menit',
    difficulty: 'Santai',
    icon: Icons.auto_awesome_rounded,
    questions: [
      _question(
        'Berapa jumlah jantung yang dimiliki gurita?',
        ['Satu', 'Dua', 'Tiga', 'Empat'],
        2,
        'Gurita memiliki tiga jantung.',
      ),
      _question(
        'Warna merah muda flamingo terutama dipengaruhi oleh...',
        ['Pantulan matahari', 'Pigmen dari makanannya', 'Warna air', 'Usianya'],
        1,
        'Pigmen karotenoid dari makanan seperti alga dan udang kecil memengaruhi warna bulunya.',
      ),
      _question(
        'Dalam klasifikasi botani, buah pisang termasuk...',
        ['Berry', 'Kacang', 'Umbi', 'Biji kering'],
        0,
        'Secara botani, pisang termasuk berry; stroberi justru bukan berry sejati.',
      ),
      _question(
        'Hewan yang terkenal menghasilkan kotoran berbentuk kubus adalah...',
        ['Koala', 'Wombat', 'Panda', 'Berang-berang'],
        1,
        'Wombat menghasilkan kotoran berbentuk kubus yang khas.',
      ),
      _question(
        'Kupu-kupu memiliki reseptor pengecap yang juga terdapat pada...',
        ['Sayap', 'Kaki', 'Antena saja', 'Ekor'],
        1,
        'Kupu-kupu menggunakan reseptor pada kakinya untuk membantu mengenali tanaman.',
      ),
    ],
  ),
  _pack(
    title: 'Dunia Kuliner',
    category: QuizCategory.fun,
    description: 'Tebak bahan, rasa, dan asal makanan favorit.',
    duration: '3 menit',
    difficulty: 'Santai',
    icon: Icons.restaurant_rounded,
    questions: [
      _question(
        'Tempe tradisional Indonesia umumnya dibuat dari...',
        ['Kedelai', 'Jagung', 'Kentang', 'Gandum'],
        0,
        'Tempe dibuat melalui fermentasi kedelai dengan kultur kapang.',
      ),
      _question(
        'Kimchi merupakan hidangan fermentasi yang populer dari...',
        ['Korea', 'Meksiko', 'Italia', 'Mesir'],
        0,
        'Kimchi adalah hidangan sayuran fermentasi yang terkenal dalam kuliner Korea.',
      ),
      _question(
        'Bahan utama cokelat berasal dari biji...',
        ['Kopi', 'Kakao', 'Vanila', 'Pala'],
        1,
        'Cokelat diolah dari biji kakao.',
      ),
      _question(
        'Rasa umami sering dijumpai pada kaldu dan berkaitan dengan senyawa...',
        ['Asam glutamat', 'Asam sitrat', 'Kafein', 'Laktosa'],
        0,
        'Glutamat alami dapat memberikan rasa gurih yang disebut umami.',
      ),
      _question(
        'Yogurt dibuat dengan bantuan proses...',
        ['Pembekuan', 'Fermentasi', 'Pengasapan', 'Pengeringan'],
        1,
        'Bakteri baik memfermentasi laktosa dalam susu menjadi asam laktat.',
      ),
    ],
  ),
  _pack(
    title: 'Kenalan dengan Hewan',
    category: QuizCategory.fun,
    description: 'Seberapa kenal kamu dengan penghuni bumi?',
    duration: '3 menit',
    difficulty: 'Santai',
    icon: Icons.pets_rounded,
    questions: [
      _question(
        'Lumba-lumba termasuk kelompok...',
        ['Ikan', 'Mamalia', 'Reptil', 'Amfibi'],
        1,
        'Lumba-lumba bernapas dengan paru-paru dan menyusui anaknya, jadi termasuk mamalia.',
      ),
      _question(
        'Pinguin merupakan jenis...',
        ['Ikan', 'Burung', 'Mamalia', 'Kadal'],
        1,
        'Pinguin adalah burung yang tidak dapat terbang dan pandai berenang.',
      ),
      _question(
        'Punuk unta terutama menyimpan...',
        ['Air', 'Lemak', 'Udara', 'Garam'],
        1,
        'Punuk unta menyimpan lemak yang dapat digunakan sebagai sumber energi.',
      ),
      _question(
        'Gurita bergerak dan menangkap benda menggunakan...',
        ['Sirip', 'Tentakel', 'Cangkang', 'Sayap'],
        1,
        'Gurita memiliki delapan lengan fleksibel dengan alat pengisap.',
      ),
      _question(
        'Kelelawar menemukan arah dalam gelap dengan bantuan...',
        ['Ekolokasi', 'Fotosintesis', 'Magnet di sayap', 'Cahaya tubuh'],
        0,
        'Banyak kelelawar menggunakan ekolokasi, yaitu membaca pantulan suara.',
      ),
    ],
  ),
  _pack(
    title: 'Dasar Kriptografi',
    category: QuizCategory.kriptografi,
    description: 'Pahami konsep enkripsi dan pesan rahasia.',
    duration: '4 menit',
    difficulty: 'Pemula',
    icon: Icons.lock_rounded,
    questions: [
      _question(
        'Tujuan utama enkripsi adalah...',
        [
          'Menyembunyikan isi informasi dari pihak yang tidak berwenang',
          'Menghapus semua salinan data',
          'Mempercepat koneksi internet',
          'Menggandakan ukuran berkas',
        ],
        0,
        'Enkripsi mengubah informasi agar hanya pihak yang memiliki kunci yang sesuai dapat membacanya.',
      ),
      _question(
        'Dalam kriptografi simetris, pihak yang berkomunikasi menggunakan...',
        [
          'Kunci rahasia yang sama',
          'Sepasang kunci publik saja',
          'Kata sandi yang selalu kosong',
          'Kunci berbeda untuk setiap huruf',
        ],
        0,
        'Kriptografi simetris menggunakan kunci rahasia yang sama untuk enkripsi dan dekripsi.',
      ),
      _question(
        'Pada kriptografi kunci publik, kunci yang boleh dibagikan adalah...',
        [
          'Kunci privat',
          'Kunci publik',
          'Keduanya harus dirahasiakan',
          'Kunci sesi saja',
        ],
        1,
        'Kunci publik dirancang untuk dibagikan; kunci privat tetap dijaga pemiliknya.',
      ),
      _question(
        'Apa yang sebaiknya dilakukan terhadap kunci privat?',
        [
          'Membagikannya di media sosial',
          'Menjaganya agar tetap rahasia',
          'Mengirimkannya bersama pesan publik',
          'Menuliskannya di semua situs',
        ],
        1,
        'Kerahasiaan kunci privat penting untuk mencegah orang lain bertindak atas nama pemiliknya.',
      ),
      _question(
        'Proses mengubah pesan terenkripsi kembali menjadi pesan yang dapat dibaca disebut...',
        ['Kompresi', 'Dekripsi', 'Rendering', 'Transmisi'],
        1,
        'Dekripsi menggunakan kunci yang sesuai untuk memulihkan pesan.',
      ),
    ],
  ),
  _pack(
    title: 'Sandi Klasik',
    category: QuizCategory.kriptografi,
    description: 'Coba sandi sederhana untuk belajar pola.',
    duration: '4 menit',
    difficulty: 'Pemula',
    icon: Icons.password_rounded,
    questions: [
      _question(
        'Pada sandi Caesar, huruf diganti dengan cara...',
        [
          'Menggesernya sejumlah posisi dalam alfabet',
          'Membalik warna huruf',
          'Menghapus huruf vokal',
          'Mengurutkannya berdasarkan panjang',
        ],
        0,
        'Sandi Caesar mengganti setiap huruf dengan huruf yang berjarak tetap di alfabet.',
      ),
      _question(
        'Dengan pergeseran Caesar 1 ke depan, huruf A menjadi...',
        ['A', 'B', 'C', 'Z'],
        1,
        'Jika setiap huruf digeser satu langkah ke depan, A menjadi B.',
      ),
      _question(
        'Dalam sandi Atbash, huruf A dipasangkan dengan...',
        ['B', 'M', 'Z', 'X'],
        2,
        'Atbash membalik urutan alfabet, sehingga A dipasangkan dengan Z.',
      ),
      _question(
        'Sandi ROT13 menggeser setiap huruf sebanyak...',
        ['1 posisi', '5 posisi', '13 posisi', '26 posisi'],
        2,
        'ROT13 menggeser alfabet sebanyak 13 posisi.',
      ),
      _question(
        'Mengapa sandi Caesar cocok untuk latihan, bukan untuk melindungi rahasia penting?',
        [
          'Kunci gesernya mudah dicoba satu per satu',
          'Sandi itu tidak bisa ditulis',
          'Semua huruf berubah menjadi angka',
          'Membutuhkan komputer super untuk dibaca',
        ],
        0,
        'Ruang kunci Caesar sangat kecil, sehingga mudah ditebak dan tidak aman untuk data penting.',
      ),
    ],
  ),
  _pack(
    title: 'Kunci, Hash, dan Keamanan',
    category: QuizCategory.kriptografi,
    description: 'Bedakan enkripsi, hash, dan tanda tangan digital.',
    duration: '4 menit',
    difficulty: 'Pemula',
    icon: Icons.enhanced_encryption_rounded,
    questions: [
      _question(
        'Fungsi hash kriptografis umumnya mengubah data menjadi...',
        [
          'Ringkasan berukuran tetap',
          'Pesan asli yang lebih panjang',
          'Kunci publik baru',
          'Gambar berwarna',
        ],
        0,
        'Fungsi hash menghasilkan ringkasan berukuran tetap dari masukan yang beragam.',
      ),
      _question(
        'Hash yang dirancang dengan baik biasanya...',
        [
          'Mudah dibalik untuk mendapatkan data asli',
          'Sulit dibalik untuk mendapatkan data asli',
          'Selalu menghasilkan teks yang sama panjang dengan masukan',
          'Tidak bergantung pada data masukan',
        ],
        1,
        'Hash kriptografis dirancang satu arah; hash bukan metode untuk mengembalikan data asli.',
      ),
      _question(
        'Tanda tangan digital dapat membantu memeriksa...',
        [
          'Keaslian dan integritas pesan',
          'Warna layar pengirim',
          'Kecepatan papan ketik',
          'Ukuran monitor penerima',
        ],
        0,
        'Tanda tangan digital membantu memeriksa siapa penandatangan dan apakah data berubah.',
      ),
      _question(
        'Untuk memeriksa tanda tangan digital, penerima umumnya menggunakan...',
        [
          'Kunci publik penanda tangan',
          'Kata sandi Wi-Fi',
          'Kunci privat penerima',
          'Alamat IP pengirim',
        ],
        0,
        'Tanda tangan yang dibuat dengan kunci privat dapat diperiksa menggunakan kunci publik pasangannya.',
      ),
      _question(
        'HTTPS membantu melindungi komunikasi antara peramban dan situs melalui...',
        [
          'Enkripsi koneksi selama data dikirim',
          'Penghapusan riwayat penjelajahan',
          'Penyimpanan semua kata sandi sebagai teks biasa',
          'Pemblokiran semua iklan',
        ],
        0,
        'HTTPS menggunakan TLS untuk membantu melindungi data saat transit; tetap periksa bahwa situsnya tepercaya.',
      ),
    ],
  ),
  _pack(
    title: 'Bahasa Indonesia',
    category: QuizCategory.umum,
    description: 'Latih pemahaman bahasa, kata baku, dan sastra.',
    duration: '3 menit',
    difficulty: 'Pemula',
    icon: Icons.menu_book_rounded,
    questions: [
      _question(
        'Manakah bentuk kata baku yang tepat?',
        ['Aktifitas', 'Aktivitas', 'Aktifitaz', 'Aktifitas'],
        1,
        'Bentuk baku yang tepat menurut KBBI adalah aktivitas.',
      ),
      _question(
        'Sinonim kata “cermat” adalah...',
        ['Teliti', 'Lambat', 'Ragu', 'Bising'],
        0,
        'Cermat berarti teliti dan berhati-hati.',
      ),
      _question(
        'Tanda baca yang mengakhiri kalimat tanya adalah...',
        ['Titik', 'Koma', 'Tanda tanya', 'Titik dua'],
        2,
        'Kalimat tanya biasanya diakhiri tanda tanya.',
      ),
      _question(
        'Lawan kata “optimistis” adalah...',
        ['Realistis', 'Pesimistis', 'Antusias', 'Kreatif'],
        1,
        'Optimistis berarti berpandangan penuh harapan, kebalikannya pesimistis.',
      ),
      _question(
        'Tokoh yang menyampaikan cerita dalam sebuah narasi disebut...',
        ['Narator', 'Editor', 'Ilustrator', 'Penerbit'],
        0,
        'Narator adalah pihak yang menuturkan jalannya cerita.',
      ),
    ],
  ),
  _pack(
    title: 'Sejarah Nusantara',
    category: QuizCategory.umum,
    description: 'Kenali peristiwa penting dalam sejarah Indonesia.',
    duration: '3 menit',
    difficulty: 'Pemula',
    icon: Icons.account_balance_rounded,
    questions: [
      _question(
        'Indonesia memproklamasikan kemerdekaan pada tanggal...',
        ['20 Mei 1908', '17 Agustus 1945', '10 November 1945', '1 Juni 1945'],
        1,
        'Proklamasi Kemerdekaan Indonesia dibacakan pada 17 Agustus 1945.',
      ),
      _question(
        'Sumpah Pemuda diperingati setiap tanggal...',
        ['2 Mei', '20 Mei', '28 Oktober', '10 November'],
        2,
        'Kongres Pemuda II yang melahirkan Sumpah Pemuda berlangsung pada 28 Oktober 1928.',
      ),
      _question(
        'Naskah proklamasi dibacakan oleh...',
        ['Mohammad Hatta', 'Soekarno', 'Ki Hajar Dewantara', 'Sutan Sjahrir'],
        1,
        'Soekarno membacakan teks proklamasi didampingi Mohammad Hatta.',
      ),
      _question(
        'Kerajaan maritim besar yang berpusat di Sumatra adalah...',
        ['Sriwijaya', 'Majapahit', 'Mataram Kuno', 'Singasari'],
        0,
        'Sriwijaya berkembang sebagai kerajaan maritim dan pusat perdagangan di Sumatra.',
      ),
      _question(
        'Hari Pahlawan Indonesia diperingati setiap...',
        ['10 November', '21 April', '1 Oktober', '22 Desember'],
        0,
        'Hari Pahlawan memperingati Pertempuran Surabaya pada 10 November 1945.',
      ),
    ],
  ),
  _pack(
    title: 'Matematika Dasar',
    category: QuizCategory.umum,
    description: 'Pemanasan berhitung, pola, dan geometri sederhana.',
    duration: '3 menit',
    difficulty: 'Pemula',
    icon: Icons.calculate_rounded,
    questions: [
      _question(
        'Berapakah hasil dari 12 × 8?',
        ['86', '92', '96', '108'],
        2,
        '12 dikalikan 8 menghasilkan 96.',
      ),
      _question(
        'Seperempat dari 100 adalah...',
        ['20', '25', '40', '50'],
        1,
        'Seperempat berarti membagi 100 dengan 4, hasilnya 25.',
      ),
      _question(
        'Keliling persegi dengan panjang sisi 5 cm adalah...',
        ['10 cm', '15 cm', '20 cm', '25 cm'],
        2,
        'Keliling persegi adalah empat kali panjang sisi: 4 × 5 = 20 cm.',
      ),
      _question(
        'Angka berikutnya dalam pola 3, 6, 9, 12, ... adalah...',
        ['13', '14', '15', '18'],
        2,
        'Pola bertambah 3 setiap langkah, jadi angka berikutnya adalah 15.',
      ),
      _question(
        'Bentuk desimal dari 3/4 adalah...',
        ['0,25', '0,5', '0,75', '1,25'],
        2,
        'Tiga dibagi empat sama dengan 0,75.',
      ),
    ],
  ),
  _pack(
    title: 'Budaya Indonesia',
    category: QuizCategory.fun,
    description: 'Jelajahi ragam seni dan budaya Nusantara.',
    duration: '3 menit',
    difficulty: 'Santai',
    icon: Icons.palette_rounded,
    questions: [
      _question(
        'Angklung merupakan alat musik tradisional yang terbuat dari...',
        ['Bambu', 'Logam', 'Kulit', 'Batu'],
        0,
        'Angklung dibuat dari tabung-tabung bambu yang dibunyikan dengan digoyangkan.',
      ),
      _question(
        'Kain tradisional yang dibuat dengan teknik perintang warna menggunakan lilin adalah...',
        ['Batik', 'Songket', 'Ulos', 'Tenun ikat'],
        0,
        'Batik menggunakan malam atau lilin untuk membentuk pola saat proses pewarnaan.',
      ),
      _question(
        'Tari Saman berasal dari provinsi...',
        ['Aceh', 'Bali', 'Jawa Barat', 'Sulawesi Selatan'],
        0,
        'Tari Saman berasal dari masyarakat Gayo di Aceh.',
      ),
      _question(
        'Rumah Gadang merupakan rumah adat dari...',
        ['Sumatra Barat', 'Kalimantan Timur', 'Maluku', 'Papua'],
        0,
        'Rumah Gadang adalah rumah tradisional Minangkabau dari Sumatra Barat.',
      ),
      _question(
        'Wayang kulit tradisional banyak berkembang di Pulau...',
        ['Jawa', 'Papua', 'Bali saja', 'Kepulauan Riau'],
        0,
        'Wayang kulit merupakan seni pertunjukan tradisional yang berkembang kuat di Jawa.',
      ),
    ],
  ),
  _pack(
    title: 'Literasi Digital',
    category: QuizCategory.kriptografi,
    description: 'Belajar bersikap aman dan kritis di dunia digital.',
    duration: '3 menit',
    difficulty: 'Pemula',
    icon: Icons.shield_rounded,
    questions: [
      _question(
        'Jika menerima tautan mencurigakan yang meminta kata sandi, sebaiknya...',
        [
          'Jangan membuka tautan dan periksa lewat saluran resmi',
          'Segera kirim kata sandi',
          'Teruskan ke semua kontak',
          'Matikan antivirus',
        ],
        0,
        'Tautan phishing meniru layanan tepercaya untuk mencuri informasi; buka situs resmi secara langsung.',
      ),
      _question(
        'Kata sandi yang lebih aman umumnya...',
        [
          'Unik dan sulit ditebak',
          'Sama untuk semua akun',
          'Berisi nama dan tanggal lahir saja',
          'Dibagikan kepada teman',
        ],
        0,
        'Kata sandi yang panjang dan unik membantu mengurangi risiko ketika satu layanan mengalami kebocoran.',
      ),
      _question(
        'Informasi yang belum diverifikasi sebaiknya...',
        [
          'Diperiksa sumber dan konteksnya sebelum dibagikan',
          'Langsung disebarkan',
          'Dianggap selalu benar',
          'Diedit agar lebih menarik',
        ],
        0,
        'Memeriksa sumber, tanggal, dan bukti membantu mengurangi penyebaran informasi keliru.',
      ),
      _question(
        'Autentikasi dua faktor menambahkan...',
        [
          'Langkah verifikasi tambahan saat masuk',
          'Dua akun baru',
          'Dua kata sandi yang sama',
          'Koneksi internet kedua',
        ],
        0,
        'Autentikasi dua faktor meminta bukti tambahan selain kata sandi.',
      ),
      _question(
        'Saat menggunakan Wi-Fi publik, praktik yang baik adalah...',
        [
          'Menghindari transaksi sensitif pada jaringan yang tidak tepercaya',
          'Mengirim kata sandi melalui pesan terbuka',
          'Menonaktifkan semua pembaruan keamanan',
          'Memakai kata sandi yang sama di semua akun',
        ],
        0,
        'Jaringan publik yang tidak tepercaya berisiko; gunakan koneksi aman dan tetap periksa alamat situs.',
      ),
    ],
  ),
];
