package Catalogue::Controller::Schemas;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

Catalogue::Controller::Schemas - Catalyst Controller

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

    $c->response->body('Matched Catalogue::Controller::Schemas in Schemas.');
}

=head2 base

Begin chained dispatch for /schemas and store a DB::CSchema resultset in the stash

=cut 

sub base : Chained('/') : PathPart('schemas') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash( resultset => $c->model('DB::CSchema') );
    $c->load_status_msgs;
}

=head2 object

Chained dispatch for /schemas/id/?/? to store a schema object on the stash

=cut 

sub object : Chained('base') : PathPart('id') : CaptureArgs(2) {
    my ( $self, $c, $schema_id, $db_id ) = @_;
    $c->stash(
        object => $c->stash->{resultset}->find(
            {   sch_id => $schema_id,
                db_id  => $db_id
            }
        )
    );

    die "Class not found" if !$c->stash->{object};
}

=head2 search

Search for Schemas

=cut

sub search : Chained('base') : PathPart('search') : Args(0) {
    my ( $self, $c ) = @_;
    my $search_term = "%" . $c->request->params->{search} . "%";
    $c->log->debug("*** Searching for $search_term ***");
    my $schema_rs = $c->stash->{resultset}->search(
        {   -or => [
                { 'me.name'        => { like => $search_term } },
                { 'me.description' => { like => $search_term } },
            ]
        },
        { distinct => 1 }
    );
    $c->log->debug("*** Found $schema_rs ***");
    my $schemas = [ $schema_rs->all ];
    $c->stash(
        schemas  => $schemas,
        template => 'schemas/list.tt2'
    );
}

=head2 list

Fetch all schema objects and pass to schemas/list.tt2 in stash to be displayed

=cut

sub list : Local {
    my ( $self, $c ) = @_;
    my $page = $c->request->param('page') || 1;
    my $query =
        $c->model('DB::CSchema')->search( {}, { rows => 30, page => $page } );
    my $schemas = [ $query->all ];
    my $pager   = $query->pager;
    $c->stash(
        schemas  => $schemas,
        pager    => $pager,
        template => 'schemas/list.tt2'
    );
}

=head2 edit_description

Use HTML::FormFu to update an schema description and return user to schemas for 
all databases

=cut

sub edit_description : Chained('object') : PathPart('edit_description') :
    Args(0)
    : FormConfig {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless $c->stash->{object}->edit_allowed_by( $c->user->get_object );

    my $schema = $c->stash->{object};
    unless ($schema) {
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_error_msg("Invalid Schema -- Cannot edit") }
            )
        );
        $c->detach;
    }

    my $form = $c->stash->{form};
    if ( $form->submitted_and_valid ) {
        $form->model->update($schema);
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
        $description->value( $schema->description );
    }
    $c->stash(
        schema   => $schema,
        template => 'schemas/edit_description.tt2'
    );
}

=head2 edit_current

Use HTML::FormFu to update an schema description and return user to schemas for 
selected database

=cut

sub edit_current : Chained('object') : PathPart('edit_current') : Args(0)
    : FormConfig('schemas/edit_description') {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless $c->stash->{object}->edit_allowed_by( $c->user->get_object );

    my $schema   = $c->stash->{object};
    my $database = $schema->db;
    unless ($schema) {
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_error_msg("Invalid Schema -- Cannot edit") }
            )
        );
        $c->detach;
    }

    my $form = $c->stash->{form};
    if ( $form->submitted_and_valid ) {
        $form->model->update($schema);
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list_schemas'),
                $database->id,
                { mid => $c->set_status_msg("Description updated") }
            )
        );
        $c->detach;
    }
    else {
        my $description = $form->get_element( { name => 'description' } );
        $description->value( $schema->description );
    }
    $c->stash(
        database => $database,
        schema   => $schema,
        template => 'schemas/edit_description.tt2'
    );
}

=head2 list_schemas

Fetch schema objects for a specified database and display in 'schemas/list' template

=cut

sub list_schemas : Path('list') : Args(1) {
    my ( $self, $c, $db_id ) = @_;
    my $page = $c->request->param('page') || 1;
    my $query = $c->model('DB::CSchema')
        ->search( { db_id => $db_id }, { rows => 30, page => $page } );
    my $schemas  = [ $query->all ];
    my $pager    = $query->pager;
    my $database = $c->model('DB::CDatabase')->find( { db_id => $db_id } );
    $c->stash(
        schemas  => $schemas,
        database => $database,
        pager    => $pager,
        template => 'schemas/list.tt2'
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
