package Catalogue::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config( namespace => '' );

=encoding utf-8

=head1 NAME

Catalogue::Controller::Root - Root Controller for Catalogue

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The index page (/)

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( template => 'welcome.tt2' );
}

=head2 welcome

The welcome page (/welcome)

=cut

sub welcome : Path('welcome') : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( template => 'welcome.tt2' );
}

=head2 about

Displays the about page

=cut

sub about : Path('about') : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( template => 'about.tt2' );
}

=head2 contact

Displays the contact page

=cut

sub contact : Path('contact') : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( template => 'contact.tt2' );
}

=head2 help

Displays the help page

=cut

sub help : Path('help') : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( template => 'help.tt2' );
}

=head2 default

Standard 404 error page

=cut

sub default : Path {
    my ( $self, $c ) = @_;
    $c->response->body('Page not found');
    $c->response->status(404);
}

=head2 auto

Redirect user to login page if not looking at Datasets

=cut

sub auto : Private {
    my ( $self, $c ) = @_;
    if ( $c->controller eq $c->controller('Login') ) {
        return 1;
    }
    if ( $c->controller eq $c->controller('Datasets') ) {
        return 1;
    }
    if ( $c->request->path eq 'about' ) {
        return 1;
    }
    if ( $c->request->path eq 'registration/new' ) {
        return 1;
    }
    if ( $c->request->path eq 'registration/ng_new_submitted' ) {
        return 1;
    }
    if ( $c->request->path eq 'contact' ) {
        return 1;
    }
    if ( $c->request->path eq 'help' ) {
        return 1;
    }
    if ( $c->request->path eq 'welcome' ) {
        return 1;
    }
    if ( $c->request->path eq '' ) {
        return 1;
    }

    if ( !$c->user_exists ) {
        $c->flash->{original_path} = '/' . $c->req->path;
        $c->response->redirect( $c->uri_for('/login/required') );
        return 0;
    }

    return 1;
}

=head2 error_noperms

Permissions error page

=cut

sub error_noperms : Chained('/') : PathPart('error_noperms') : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( template => 'error_noperms.tt2' );
}

=head2 logged_in

Error page for logged-in users requesting an action for anonymous users
=cut

sub logged_in : Chained('/') : PathPart('logged_in') : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( template => 'logged_in.tt2' );
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') { }

=head1 AUTHOR

David Ramlakhan

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
