<?php

// autoload_static.php @generated by Composer

namespace Composer\Autoload;

class ComposerStaticInit111be0adff09ff05f4aab99b239447ba
{
    public static $classMap = array (
        'Composer\\InstalledVersions' => __DIR__ . '/..' . '/composer/InstalledVersions.php',
        'Format' => __DIR__ . '/../..' . '/application/libraries/Format.php',
        'Restserver\\Libraries\\REST_Controller' => __DIR__ . '/../..' . '/application/libraries/REST_Controller.php',
    );

    public static function getInitializer(ClassLoader $loader)
    {
        return \Closure::bind(function () use ($loader) {
            $loader->classMap = ComposerStaticInit111be0adff09ff05f4aab99b239447ba::$classMap;

        }, null, ClassLoader::class);
    }
}