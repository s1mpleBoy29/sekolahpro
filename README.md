# sekolahpro
Aplikasi untuk orang tua atau wali murid


# Ketentunan Stuktur Folder

Berikut informasi struktur folder pada proyek ini:
## Folder Core
•⁠  ⁠Berisi function umum seperti pemanggilan API, helper, dan utilitas lainnya.

## Folder Presentation
•⁠  ⁠Berisi file-file halaman tampilan (UI).
•⁠  ⁠Jika ada widget/component yang hanya digunakan pada satu halaman, buat folder khusus dengan nama halaman tersebut, lalu letakkan widget/component-nya di dalam folder tersebut.
Contoh:
•⁠  ⁠presentation/home/home.dart – halaman utama
•⁠  ⁠presentation/home/highlight.dart – komponen khusus untuk halaman home

## File app_routes.dart
file app_routes.dart yang berada didalam folder **routes**
•⁠  ⁠File ini digunakan untuk mendefinisikan seluruh routing halaman.
•⁠  ⁠Jika menambahkan halaman baru, jangan lupa untuk mendaftarkannya di file ini.

## Folder Theme
•⁠  ⁠Berisi kustomisasi elemen bawaan Flutter seperti tombol dan input teks.
•⁠  ⁠Pengaturan warna dan skema tema dapat ditemukan di theme_helper.dart.

## Folder Widget
•⁠  ⁠Berisi widget yang reusable (dapat digunakan ulang di banyak halaman).
•⁠  ⁠Jika suatu widget hanya digunakan di satu halaman, tempatkan di folder halaman terkait (bukan di sini).


