# Pengujian Load Balancing Nginx dengan Docker

Repositori ini berisi lingkungan siap pakai untuk melakukan pengujian performa (*performance testing*) pada **Nginx** sebagai *load balancer*. Seluruh lingkungan diorkestrasi menggunakan **Docker Compose**, sehingga memudahkan untuk menjalankan, menguji, dan membersihkan layanan.

Proyek ini bertujuan untuk mensimulasikan arsitektur umum di mana sebuah *reverse proxy* (Nginx) mendistribusikan lalu lintas ke beberapa server aplikasi di belakangnya.

## 🏛️ Arsitektur / Architecture

Arsitektur pengujian ini terdiri dari beberapa komponen yang berjalan sebagai kontainer Docker:

  * **Nginx**: Bertindak sebagai *reverse proxy* dan *load balancer*. Menerima semua permintaan masuk dan mendistribusikannya ke layanan *backend*.
  * **Backend Services**: Beberapa replika dari aplikasi web sederhana yang akan menerima lalu lintas dari Nginx.
  * **Testing Script**: Sebuah skrip shell (`run_tests.sh`) yang menggunakan alat *benchmarking* (seperti `ab`, `wrk`, atau `k6`) untuk mengirimkan ribuan permintaan ke Nginx.

Alur kerjanya adalah sebagai berikut:
`Client (Testing Script) -> Nginx (Load Balancer) -> [Backend Service 1, Backend Service 2, ...]`

## 📁 Struktur Direktori / Directory Structure

```
.
├── analysis/         # Skrip untuk menganalisis data hasil pengujian (mis: Python/Gnuplot)
├── backend/          # Kode sumber untuk aplikasi backend (mis: Node.js/Python Flask)
├── logs/             # Menyimpan log dari Nginx dan layanan backend
├── nginx/            # Berisi file konfigurasi Nginx (nginx.conf)
├── results/          # Menyimpan hasil mentah dari pengujian performa
├── docker-compose.yml # File utama untuk mendefinisikan dan menjalankan semua layanan
└── run_tests.sh      # Skrip untuk memulai pengujian beban (load test)
```

**Penjelasan:**

  * `nginx/nginx.conf`: Tempat Anda mendefinisikan strategi *load balancing* (misalnya `round-robin`, `least_conn`, `ip_hash`).
  * `docker-compose.yml`: Mengatur bagaimana semua kontainer (Nginx, backend) dibangun dan dijalankan bersama. Anda dapat mengatur jumlah replika backend di file ini.
  * `run_tests.sh`: Skrip utama untuk mengeksekusi tes. Anda dapat mengubah parameter seperti jumlah permintaan, tingkat konkurensi, dll. di sini.

## 🚀 Cara Penggunaan / Getting Started

### 1\. Prasyarat (Prerequisites)

Pastikan Anda telah menginstal:

  * [Docker](https://docs.docker.com/get-docker/)
  * [Docker Compose](https://docs.docker.com/compose/install/)

### 2\. Instalasi (Installation)

Clone repositori ini ke mesin lokal Anda:

```bash
git clone https://github.com/rifkyadiii/nginx-loadbalance-test.git
```
```bash
cd nginx-loadbalance-test
```

### 3\. Menjalankan Tes (Running the Test)

Untuk memulai seluruh lingkungan dan menjalankan pengujian, cukup eksekusi skrip `run_tests.sh`:

```bash
bash run_tests.sh
```

Skrip ini akan:

1.  Membangun dan menjalankan semua layanan menggunakan `docker-compose up`.
2.  Menjalankan *benchmark* terhadap Nginx.
3.  Menyimpan output ke direktori `results/` dan log ke direktori `logs/`.
4.  Menghentikan dan membersihkan kontainer setelah selesai.

### 4\. Melihat Hasil (Viewing the Results)

Setelah pengujian selesai, Anda dapat memeriksa:

  * **Data mentah**: Lihat file yang dihasilkan di dalam direktori `results/`.
  * **Analisis**: Jalankan skrip yang ada di direktori `analysis/` untuk memproses data mentah menjadi grafik atau ringkasan statistik.

## 🔧 Kustomisasi / Customization

Anda dapat dengan mudah menyesuaikan pengujian ini:

  * **Mengubah Strategi Load Balancing**: Edit file `nginx/nginx.conf` pada bagian `upstream` untuk mengganti metode (misalnya dari `round-robin` (default) menjadi `least_conn`).
  * **Menambah/Mengurangi Server Backend**: Ubah nilai `replicas` pada layanan `backend` di dalam file `docker-compose.yml`.
  * **Mengubah Parameter Tes**: Modifikasi skrip `run_tests.sh` untuk menyesuaikan jumlah permintaan, durasi, atau tingkat konkurensi dari alat *benchmark* yang digunakan.
