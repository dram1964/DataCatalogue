package Catalogue::Controller::Databases;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

Catalogue::Controller::Databases - Catalyst Controller

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
    $c->response->body(
        'Matched Catalogue::Controller::Databases in Databases.');
}

=head2 base

Get a CDatabase resultset and load status messages for /databases chain

=cut 

sub base : Chained('/') : PathPart('databases') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash( resultset => $c->model('DB::CDatabase') );
    $c->load_status_msgs;
}

=head2 search

Search for databases

=cut

sub search : Chained('base') : PathPart('search') : Args(0) {
    my ( $self, $c ) = @_;
    my $search_term = "%" . $c->request->params->{search} . "%";
    $c->log->debug("*** Searching for $search_term ***");
    my $database_rs = $c->stash->{resultset}->search(
        {   -or => [
                { 'me.name'               => { like => $search_term } },
                { 'me.description'        => { like => $search_term } },
                { 'c_schemas.name'        => { like => $search_term } },
                { 'c_schemas.description' => { like => $search_term } },
            ]
        },
        {   join     => { 'c_schemas' },
            distinct => 1
        }
    );
    $c->log->debug("*** Found $database_rs ***");
    my $databases = [ $database_rs->all ];
    $c->stash(
        databases => $databases,
        template  => 'databases/list.tt2'
    );
}

=head2 object

Fetch the specified system database object based on the db and system id and store it in the stash for /datbases/id/?/? chain

=cut 

sub object : Chained('base') : PathPart('id') : CaptureArgs(1) {
    my ( $self, $c, $db_id ) = @_;
    $c->stash( object => $c->stash->{resultset}->find($db_id) );

    die "Class not found" if !$c->stash->{object};
}

=head2 edit_description

Use HTML::FormFu to update description for database and return user to list of all databases

=cut

sub edit_description : Chained('object') : PathPart('edit_description') :
    Args(0)
    : FormConfig {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless $c->stash->{object}->edit_allowed_by( $c->user->get_object );

    my $database = $c->stash->{object};
    unless ($database) {
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                {   mid =>
                        $c->set_error_msg("Invalid Database -- Cannot edit")
                }
            )
        );
        $c->detach;
    }

    my $form = $c->stash->{form};
    if ( $form->submitted_and_valid ) {
        $form->model->update($database);
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_status_msg("Description updated") }
            )
        );
        $c->detach;
    }
    else {
        my $description = $form->get_element( { name => 'description' } );
        $description->value( $database->description );
    }
    $c->stash(
        database => $database,
        template => 'databases/edit_description.tt2'
    );
}

=head2 list

Fetch all database objects and pass to databases/list.tt2 in stash to be displayed

=cut

sub list : Local {
    my ( $self, $c ) = @_;
    $c->stash( databases => [ $c->model('DB::CDatabase')->all ] );
    $c->stash( template  => 'databases/list.tt2' );
    my $page = $c->request->param('page') || 1;
    my $query = $c->model('DB::CDatabase')
        ->search( {}, { rows => 30, page => $page } );
    my $databases = [ $query->all ];
    my $pager     = $query->pager;
    $c->stash(
        databases => $databases,
        pager     => $pager,
        template  => 'databases/list.tt2'
    );
}

=head2 download

Download model contents to CSV file

=cut

sub download : Path('download') : Args(1) {
    my ( $self, $c, $content_type ) = @_;
    $c->detach('/error_noperms')
        unless $c->model('DB::CDatabase')
        ->first->edit_allowed_by( $c->user->get_object );
    my $filename = 'data.csv';
    my $data;
    my $rs = $c->model('DB::CDatabase')->search;
    while ( my $system_db = $rs->next ) {
        push @$data, [ $system_db->id, $system_db->name ];
    }
    if ($content_type) {
        $content_type = 'plain'
            unless scalar( grep { $content_type eq $_ } qw(csv html plain) );
        $c->res->header( 'Content-Type' => 'text/' . $content_type );
        $c->stash->{'download'} = 'text/' . $content_type;
        my $format = {
            'html' => sub {
                return
                    "<!DOCTYPE html><html><head><title>Data</title></head><body>"
                    . join( "<br>", map { join( " ", @$_ ) } @$data )
                    . "</body></html>";
            },
            'plain' => sub {
                return join( "\n", map { join( " ", @$_ ) } @$data );
            },
            'csv' => sub { return $data; }
        };

        $c->stash->{$content_type} = $format->{$content_type}();
        $c->stash( outfile_name => $filename );
        $c->detach('Catalogue::View::Download');
    }
    $c->res->body('Display page as normal');
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
