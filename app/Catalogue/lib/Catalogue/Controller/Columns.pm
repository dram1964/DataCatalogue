package Catalogue::Controller::Columns;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Catalogue::Controller::Columns - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 auto

Deny all access unless user has curator or admin rights

=cut

sub auto : Private {
    my ( $self, $c ) = @_;
    unless ( $c->user->has_role('curator') || $c->user->has_role('admin') ) {
        $c->detach('/error_noperms');
    }
}

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Catalogue::Controller::Columns in Columns.');
}

=head2 list

Fetch all column objects and pass to columns/list.tt2 in stash to be displayed

=cut

sub list : Local {
    my ( $self, $c ) = @_;
    my $page = $c->request->param('page') || 1;
    my $query = $c->model('DB::CColumn')->search(
        {},
        {   join     => { 'tbl' => { 'sch' => 'db' } },
            prefetch => { 'tbl' => { 'sch' => 'db' } },
            rows     => 30,
            page     => $page,
        }
    );
    my $columns = [ $query->all ];
    my $pager   = $query->pager;
    $c->stash(
        pager    => $pager,
        columns  => $columns,
        template => 'columns/list.tt2'
    );
}

=head2 list_columns

Fetch all the columns for the specified table and display in the columns/list template

=cut

sub list_columns : Path('list_columns') : Args(1) {
    my ( $self, $c, $table_id ) = @_;
    my $columns = [
        $c->model('DB::CColumn')->search(
            { 'me.tbl_id' => $table_id },
            {   join     => { 'tbl' => { 'sch' => 'db' } },
                prefetch => { 'tbl' => { 'sch' => 'db' } },
            }
        )
    ];
    my $table = $c->model('DB::CTable')->find( { tbl_id => $table_id } );
    $c->stash(
        table    => $table,
        columns  => $columns,
        template => 'columns/list.tt2'
    );
}

=head2 search

Search for Columns

=cut

sub search : Path('search') : Args(0) {
    my ( $self, $c ) = @_;
    my $page        = $c->request->param('page') || 1;
    my $search_term = "%" . $c->request->params->{search} . "%";
    my $column_rs   = $c->model('DB::CColumn')->search(
        {   -or => [
                { 'me.name'  => { like => $search_term } },
                { 'tbl.name' => { like => $search_term } },
                { 'sch.name' => { like => $search_term } },
                { 'db.name'  => { like => $search_term } },
            ]
        },
        {   join     => { 'tbl' => { 'sch' => 'db' } },
            prefetch => { 'tbl' => { 'sch' => 'db' } },
            distinct => 1,
            rows     => 30,
            page     => $page,
        }
    );
    my $columns = [ $column_rs->all ];
    my $pager   = $column_rs->pager;
    $c->stash(
        pager    => $pager,
        columns  => $columns,
        template => 'columns/list.tt2'
    );
}

=encoding utf8

=head1 AUTHOR

David Ramlakhan

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
