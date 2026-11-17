<?php
namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;
use App\Models\UmkmModel;

class UmkmController extends ResourceController
{
    protected $modelName = UmkmModel::class;
    protected $format = 'json';

    // GET - Mengambil semua data UMKM
    public function index()
    {
        $data = $this->model->findAll();

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil diambil',
            'data' => $data
        ], 200);
    }

    // GET - Mengambil satu UMKM berdasarkan ID
    public function show($id = null)
    {
        $data = $this->model->find($id);

        if (!$data) {
            return $this->respond([
                'success' => false,
                'message' => 'Data UMKM tidak ditemukan',
                'data' => null
            ], 404);
        }

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil diambil',
            'data' => $data
        ], 200);
    }

    // POST - Menambahkan UMKM baru
    public function create()
    {
        $data = $this->request->getJSON(true);

        if (!is_array($data)) {
            return $this->respond([
                'success' => false,
                'message' => 'Format JSON tidak valid',
                'data' => null
            ], 400);
        }

        $rules = [
            'nama_umkm' => 'required|max_length[100]',
            'pemilik'   => 'required|max_length[100]',
            'alamat'    => 'required',
            'kategori'  => 'required|max_length[50]',
            'kontak'    => 'required|max_length[20]'
        ];

        if (!$this->validateData($data, $rules)) {
            return $this->respond([
                'success' => false,
                'message' => 'Validasi data gagal',
                'data' => null,
                'errors' => $this->validator->getErrors()
            ], 400);
        }

        $data = $this->validator->getValidated();

        if ($this->model->insert($data) === false) {
            return $this->respond([
                'success' => false,
                'message' => 'Gagal menambahkan data UMKM',
                'data' => null,
                'errors' => $this->model->errors()
            ], 400);
        }

        $id = $this->model->getInsertID();

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil ditambahkan',
            'data' => $this->model->find($id)
        ], 201);
    }

    // PUT - Memperbarui data UMKM
    public function update($id = null)
    {
        $umkm = $this->model->find($id);

        if (!$umkm) {
            return $this->respond([
                'success' => false,
                'message' => 'Data UMKM tidak ditemukan',
                'data' => null
            ], 404);
        }

        $data = $this->request->getJSON(true);

        if (!is_array($data)) {
            return $this->respond([
                'success' => false,
                'message' => 'Format JSON tidak valid',
                'data' => null
            ], 400);
        }

        $rules = [
            'nama_umkm' => 'required|max_length[100]',
            'pemilik'   => 'required|max_length[100]',
            'alamat'    => 'required',
            'kategori'  => 'required|max_length[50]',
            'kontak'    => 'required|max_length[20]'
        ];

        if (!$this->validateData($data, $rules)) {
            return $this->respond([
                'success' => false,
                'message' => 'Validasi data gagal',
                'data' => null,
                'errors' => $this->validator->getErrors()
            ], 400);
        }

        $data = $this->validator->getValidated();

        if ($this->model->update($id, $data) === false) {
            return $this->respond([
                'success' => false,
                'message' => 'Gagal memperbarui data UMKM',
                'data' => null,
                'errors' => $this->model->errors()
            ], 400);
        }

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil diperbarui',
            'data' => $this->model->find($id)
        ], 200);
    }

    // DELETE - Menghapus data UMKM
    public function delete($id = null)
    {
        $umkm = $this->model->find($id);

        if (!$umkm) {
            return $this->respond([
                'success' => false,
                'message' => 'Data UMKM tidak ditemukan',
                'data' => null
            ], 404);
        }

        if ($this->model->delete($id) === false) {
            return $this->respond([
                'success' => false,
                'message' => 'Gagal menghapus data UMKM',
                'data' => null
            ], 400);
        }

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil dihapus',
            'data' => [
                'id' => $umkm['id'],
                'nama_umkm' => $umkm['nama_umkm']
            ]
        ], 200);
    }
}
