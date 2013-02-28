use strict;
use warnings;
use utf8;
use Test::More;
use Test::Module::Build::Pluggable;
use Module::Build::Pluggable::CPANfile;
use JSON;

my $test = Test::Module::Build::Pluggable->new();
$test->write_file('Build.PL', <<'...');
use strict;
use Module::Build::Pluggable (
    'CPANfile',
);

my $builder = Module::Build::Pluggable->new(
    dist_name => 'Eg',
    dist_version => 0.01,
    dist_abstract => 'test',
    dynamic_config => 0,
    module_name => 'Eg',
    requires => {},
    provides => {},
    author => 1,
    dist_author => 'test',
);
$builder->create_build_script();
...

$test->write_file('cpanfile', <<'...');
requires 'LWP::UserAgent' => '6.02';
requires 'HTTP::Message'  => '6.04'; 
on 'test' => sub {
   requires 'Test::More'     => '0.98';
   requires 'Test::Requires' => '0.06';
};
...

$test->run_build_pl();
my $meta = $test->read_file('MYMETA.json');
ok($meta);
my $spec = decode_json($meta);

is_deeply( $spec->{prereqs}{build}, {
    requires => {
        'Test::More'     => '0.98',
        'Test::Requires' => '0.06',
        'Module::Build::Pluggable::CPANfile' => $Module::Build::Pluggable::CPANfile::VERSION,
    }
});

is_deeply( $spec->{prereqs}{configure}, {
    requires => {
        'Module::Build::Pluggable::CPANfile' => $Module::Build::Pluggable::CPANfile::VERSION,
    }
});

is_deeply( $spec->{prereqs}{runtime}, {
    requires => {
        'LWP::UserAgent' => '6.02',
        'HTTP::Message'  => '6.04', 
    }
});

done_testing();


