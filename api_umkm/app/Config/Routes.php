
<?php

use CodeIgniter\Router\RouteCollection;

/** @var RouteCollection $routes */

// Halaman utama
$routes->get('/', 'Home::index');

// =====================================
// ROUTES API UMKM
// =====================================

$routes->group('api', function ($routes) {

    // OPTIONS - Preflight CORS
    $routes->options('umkm', static function () {
        return service('response')->setStatusCode(204);
    });

    $routes->options('umkm/(:num)', static function () {
        return service('response')->setStatusCode(204);
    });

    // GET - Menampilkan semua data UMKM
    $routes->get(
        'umkm',
        'Api\UmkmController::index'
    );

    // GET - Menampilkan UMKM berdasarkan ID
    $routes->get(
        'umkm/(:num)',
        'Api\UmkmController::show/$1'
    );

    // POST - Menambahkan data UMKM
    $routes->post(
        'umkm',
        'Api\UmkmController::create'
    );

    // PUT - Memperbarui data UMKM
    $routes->put(
        'umkm/(:num)',
        'Api\UmkmController::update/$1'
    );

    // DELETE - Menghapus data UMKM
    $routes->delete(
        'umkm/(:num)',
        'Api\UmkmController::delete/$1'
    );

});
