<?php

namespace Config;

use CodeIgniter\Config\BaseConfig;

class Cors extends BaseConfig
{
    public array $default = [
        'allowedOrigins' => [],

        'allowedOriginsPatterns' => [
            'http://localhost:[0-9]+',
            'http://127\.0\.0\.1:[0-9]+',
        ],

        'supportsCredentials' => false,

        'allowedHeaders' => [
            'Content-Type',
            'Authorization',
            'Accept',
            'X-Requested-With',
        ],

        'exposedHeaders' => [],

        'allowedMethods' => [
            'GET',
            'POST',
            'PUT',
            'PATCH',
            'DELETE',
            'OPTIONS',
        ],

        'maxAge' => 7200,
    ];
}