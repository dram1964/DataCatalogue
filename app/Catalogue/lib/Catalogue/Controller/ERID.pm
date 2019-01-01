package Catalogue::Controller::ERID;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Catalogue::Controller::ERID - Catalyst Controller

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

    $c->response->body('Matched Catalogue::Controller::ERID in ERID.');
}

=head2 list 

List all ERIDs 

=cut

sub list : Chained('base') : PathPart('list') : Args(0) {
    my ( $self, $c ) = @_;
    my $erids = [ $c->stash->{resultset}->all ];
    $c->stash(
        erids    => $erids,
        template => 'erids/list.tt2'
    );
}

=head2 base

Can place common logic to start a chained dispatch here

=cut 

sub base : Chained('/') : PathPart('erid') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash( resultset => $c->model('DB::ERID') );
    $c->load_status_msgs;
}

=head2 object

Fetch the specified erid object based on the class id and store it in the stash

=cut 

sub object : Chained('base') : PathPart('id') : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $c->stash( object => $c->stash->{resultset}->find($id) );

    die "Class not found" if !$c->stash->{object};

}

=head2 add

Add new ERID

=cut

sub add : Chained('base') : PathPart('add') : Args(0) {
    my ( $self, $c ) = @_;
    my $name = $c->request->params->{name};
    my $erid = $c->stash->{resultset}->create( { name => $name } );
    $c->response->redirect(
        $c->uri_for(
            $self->action_for('list'),
            { mid => $c->set_status_msg("ERID $name added.") }
        )
    );
}

=head2 delete

Delete the ERID

=cut

sub delete : Chained('object') : PathPart('delete') : Args(0) {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless $c->stash->{object}->delete_allowed_by( $c->user->get_object );
    $c->stash->{object}->delete;
    $c->response->redirect(
        $c->uri_for(
            $self->action_for('list'),
            { mid => $c->set_status_msg("ERID Deleted.") }
        )
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
