package Catalogue::Controller::KPE;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Catalogue::Controller::KPE - Catalyst Controller

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

    $c->response->body('Matched Catalogue::Controller::KPE in KPE.');
}

=head2 list 

List all KPEs 

=cut

sub list : Chained('base') : PathPart('list') : Args(0) {
    my ( $self, $c ) = @_;
    my $kpes = [ $c->stash->{resultset}->all ];
    $c->stash(
        kpes     => $kpes,
        template => 'kpes/list.tt2'
    );
}

=head2 base

Can place common logic to start a chained dispatch here

=cut 

sub base : Chained('/') : PathPart('kpe') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash( resultset => $c->model('DB::Kpe') );
    $c->load_status_msgs;
}

=head2 object

Fetch the specified kpe object based on the class id and store it in the stash

=cut 

sub object : Chained('base') : PathPart('id') : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $c->stash( object => $c->stash->{resultset}->find($id) );

    die "Class not found" if !$c->stash->{object};

}

=head2 add

Add new KPE

=cut

sub add : Chained('base') : PathPart('add') : Args(0) {
    my ( $self, $c ) = @_;
    my $name = $c->request->params->{name};
    my $kpe = $c->stash->{resultset}->create( { name => $name } );
    $c->response->redirect(
        $c->uri_for(
            $self->action_for('list'),
            { mid => $c->set_status_msg("KPE $name added.") }
        )
    );
}

=head2 delete

Delete the KPE

=cut

sub delete : Chained('object') : PathPart('delete') : Args(0) {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless $c->stash->{object}->delete_allowed_by( $c->user->get_object );
    $c->stash->{object}->delete;
    $c->response->redirect(
        $c->uri_for(
            $self->action_for('list'),
            { mid => $c->set_status_msg("KPE Deleted.") }
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
