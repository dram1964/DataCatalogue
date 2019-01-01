package Catalogue::Controller::Tables;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

Catalogue::Controller::Tables - Catalyst Controller

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

    $c->response->body('Matched Catalogue::Controller::Tables in Tables.');
}

=head2 base

Begin chained dispatch for /tables to store a DB::CTable resultset in the stash

=cut 

sub base : Chained('/') : PathPart('tables') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash( resultset => $c->model('DB::CTable') );
}

=head2 object

Chained dispatch for /tables/id/?/? to store a table object in the stash

=cut 

sub object : Chained('base') : PathPart('id') : CaptureArgs(1) {
    my ( $self, $c, $table_id ) = @_;
    $c->stash(
        object => $c->stash->{resultset}->find( { tbl_id => $table_id } ) );

    die "Class not found" if !$c->stash->{object};
}

=head2 search

Search for Tables

=cut

sub search : Chained('base') : PathPart('search') : Args(0) {
    my ( $self, $c ) = @_;
    my $search_term = "%" . $c->request->params->{search} . "%";
    $c->log->debug("*** Searching for $search_term ***");
    my $table_rs = $c->stash->{resultset}->search(
        {   -or => [
                { 'me.name'        => { like => $search_term } },
                { 'me.description' => { like => $search_term } },
            ]
        },
        { distinct => 1 }
    );
    $c->log->debug("*** Found $table_rs ***");
    my $tables = [ $table_rs->all ];
    $c->stash(
        tables   => $tables,
        template => 'tables/list.tt2'
    );
}

=head2 edit_description

Use HTML::FormFu to update description for table and return user to list of all schemas

=cut

sub edit_description : Chained('object') : PathPart('edit_description') :
    Args(0)
    : FormConfig {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless $c->stash->{object}->edit_allowed_by( $c->user->get_object );

    my $table = $c->stash->{object};
    unless ($table) {
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_error_msg("Invalid Table -- Cannot edit") }
            )
        );
        $c->detach;
    }

    my $form = $c->stash->{form};
    if ( $form->submitted_and_valid ) {
        $form->model->update($table);
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
        $description->value( $table->description );
    }
    $c->stash(
        table    => $table,
        template => 'tables/edit_description.tt2'
    );
}

=head2 edit_current

Use HTML::FormFu to update a schema description and return user to list of databases for current database

=cut

sub edit_current : Chained('object') : PathPart('edit_current') : Args(0)
    : FormConfig('tables/edit_description.yml') {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless $c->stash->{object}->edit_allowed_by( $c->user->get_object );

    my $table  = $c->stash->{object};
    my $schema = $table->sch;
    unless ($table) {
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_error_msg("Invalid Table -- Cannot edit") }
            )
        );
        $c->detach;
    }

    my $form = $c->stash->{form};
    if ( $form->submitted_and_valid ) {
        $form->model->update($table);
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list_tables'),
                $schema->id,
                { mid => $c->set_status_msg("Description updated") }
            )
        );
        $c->detach;
    }
    else {
        my $description = $form->get_element( { name => 'description' } );
        $description->value( $table->description );
    }
    $c->stash(
        schema   => $schema,
        table    => $table,
        template => 'tables/edit_description.tt2'
    );
}

=head2 list

Fetch all table objects and pass to tables/list.tt2 in stash to be displayed

=cut

sub list : Local {
    my ( $self, $c ) = @_;
    my $page = $c->request->param('page') || 1;
    my $query =
        $c->model('DB::CTable')->search( {}, { rows => 30, page => $page } );
    my $tables = [ $query->all ];
    my $pager  = $query->pager;
    $c->stash(
        tables   => $tables,
        pager    => $pager,
        template => 'tables/list.tt2'
    );
}

=head2 list_tables

Fetch the table objects for the specified schema and display in the list/tables template

=cut 

sub list_tables : Path('list_tables') : Args(1) {
    my ( $self, $c, $schema_id ) = @_;
    my $page = $c->request->param('page') || 1;
    my $query = $c->model('DB::CTable')
        ->search( { sch_id => $schema_id }, { rows => 30, page => $page } );
    my $tables = [ $query->all ];
    my $pager  = $query->pager;
    my $schema = $c->model('DB::CSchema')->find( { sch_id => $schema_id } );
    $c->stash(
        pager    => $pager,
        schema   => $schema,
        tables   => $tables,
        template => 'tables/list.tt2'
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
