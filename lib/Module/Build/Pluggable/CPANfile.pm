package Module::Build::Pluggable::CPANfile;

use strict;
use warnings;
use 5.008005;
use parent qw/Module::Build::Pluggable::Base/;
use Module::CPANfile;

our $VERSION = '0.02';

sub HOOK_prepare {
    my $self = shift;
    my $args = shift;

    my %copy_prereqs = (
        'configure_requires' => [qw/configure/],
        'build_requires'     => [qw/build test devel/],
        'requires'           => [qw/runtime/]
    );

    my $file = Module::CPANfile->load("cpanfile");
    my $prereq = $file->prereq_specs;

    for my $args_key ( keys %copy_prereqs ) {
        my $requires = $args->{$args_key} || {};
        for my $cpanfile_key ( @{$copy_prereqs{$args_key}} ) {
            $requires = {
                %$requires,
                $prereq->{$cpanfile_key} ? %{$prereq->{$cpanfile_key}->{requires}} : ()
            };
        }
        $args->{$args_key} = $requires if keys %$requires;
    }
    
}


1;
__END__

=encoding utf8

=head1 NAME

Module::Build::Pluggable::CPANfile - Include cpanfile

=head1 SYNOPSIS

  # cpanfile
  requires 'Plack', 0.9;
  on test => sub {
      requires 'Test::Warn';
  };
  
  # Build.PL
  use Module::Build::Pluggable (
      'CPANfile'
  );
  
  my $builder = Module::Build::Pluggable->new(
        ... # normal M::B args. but not required prereqs
  );
  $builder->create_build_script();

=head1 DESCRIPTION

Module::Build::Pluggable::CPANfile is plugin for Module::Build::Pluggable to include dependencies from cpanfile into meta files. 
This modules is L<Module::Install::CPANfile> for Module::Build

B<THIS IS A DEVELOPMENT RELEASE. API MAY CHANGE WITHOUT NOTICE>.

=head1 AUTHOR

Masahiro Nagano E<lt>kazeburo@gmail.comE<gt>

=head1 SEE ALSO

L<Module::Install::CPANfile>, L<cpanfile>, L<Module::Build::Pluggable>

=head1 LICENSE

Copyright (C) Masahiro Nagano

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
