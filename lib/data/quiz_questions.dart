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

QuizPack _pack({
  required String title,
  required QuizCategory category,
  required String description,
  required String duration,
  required String difficulty,
  required IconData icon,
  required List<QuizQuestion> questions,
}) {
  return QuizPack(
    title: title,
    category: category,
    description: description,
    duration: duration,
    difficulty: difficulty,
    icon: icon,
    questions: [
      for (final question in questions)
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
];
