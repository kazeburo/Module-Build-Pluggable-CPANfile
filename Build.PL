use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
    license              => 'perl',
    dynamic_config       => 0,

    build_requires       => {
        'Test::More'     => '0.98',
        'Test::Requires' => 0,
        'Capture::Tiny'  => '0.21'
    },
    configure_requires   => { 'Module::Build' => '0.38' },
    requires             => {
        perl => '5.008005',
        'version'                  => '0.99',
        'parent'                   => '0',
        'Module::Build::Pluggable' => '0.05',
        'Module::CPANfile'         => '0.9010',
        'List::Util'               => '1.14'
    },

    no_index    => { 'directory' => [ 'inc' ] },
    name        => 'Module-Build-Pluggable-CPANfile',
    module_name => 'Module::Build::Pluggable::CPANfile',

    test_files => (-d '.git' || $ENV{RELEASE_TESTING}) ? 't/ xt/' : 't/',
    recursive_test_files => 1,
   
    create_readme  => 1,
    create_license => 1,
);
$build->create_build_script();
