package Catalogue::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

my $dsn = $ENV{MYAPP_DSN} ||= 'dbi:mysql:catalogue_test';

__PACKAGE__->config(
    schema_class => 'Catalogue::Schema',
    
    connect_info => {
        dsn => $dsn,
        user => 'tutorial',
        password => 'password',
        AutoCommit => q{1},
    },
);

=head1 NAME

Catalogue::Model::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<Catalogue>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Catalogue::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.65

=head1 AUTHOR

David Ramlakhan

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;