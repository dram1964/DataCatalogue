package Catalogue::Controller::Applications;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

Catalogue::Controller::CApplications - Catalyst Controller

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
        'Matched Catalogue::Controller::CApplications in CApplications.');
}

=head2 base

Can place common logic to start a chained dispatch here

=cut 

sub base : Chained('/') : PathPart('applications') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash( resultset => $c->model('DB::CApplication') );
    $c->load_status_msgs;
}

=head2 object

Fetch the specified application object based on the class id and store it in the stash

=cut 

sub object : Chained('base') : PathPart('id') : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $c->stash( object => $c->stash->{resultset}->find($id) );

    die "Class not found" if !$c->stash->{object};

}

=head2 list 

List all CApplications 

=cut

sub list : Chained('base') : PathPart('list') : Args(0) {
    my ( $self, $c ) = @_;
    my $page = $c->request->param('page') || 1;
    my $query = $c->stash->{resultset}->search(
        {},
        {   rows => 30,
            page => $page
        }
    );
    my $applications = [ $query->all ];
    my $pager        = $query->pager;
    $c->stash(
        applications => $applications,
        pager        => $pager,
        template     => 'applications/list.tt2'
    );
}

=head2 search

Search for applications

=cut

sub search : Chained('base') : PathPart('search') : Args(0) {
    my ( $self, $c ) = @_;
    my $search_term    = "%" . $c->request->params->{search} . "%";
    my $application_rs = $c->stash->{resultset}->search(
        {   -or => [
                { 'me.name'        => { like => $search_term } },
                { 'me.description' => { like => $search_term } },
                { 'kpe.name'       => { like => $search_term } },
                { 'cat2.name'      => { like => $search_term } },
                { 'erid.name'      => { like => $search_term } },
                { 'supplier.name'  => { like => $search_term } },
            ]
        },
        {   join     => [ 'kpe', 'cat2', 'erid', 'supplier' ],
            distinct => 1
        }
    );
    my $applications = [ $application_rs->all ];
    $c->stash(
        search_term  => $search_term,
        applications => $applications,
        template     => 'applications/list.tt2'
    );
}

=head2 add

Add new Application

=cut

sub add : Chained('base') : PathPart('add') : Args(0) :
    FormConfig('applications/edit.yml') {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless $c->stash->{resultset}
        ->first->edit_allowed_by( $c->user->get_object );

    my $form = $c->stash->{form};
    if ( $form->submitted_and_valid ) {
        my $application_name        = $c->request->params->{name};
        my $application_description = $c->request->params->{description};
        my $application = $c->model('DB::CApplication')->new_result(
            {   name        => $application_name,
                description => $application_description,
            }
        );
        $form->model->update($application);
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_status_msg("Dataset Added") }
            )
        );
        $c->detach;
    }
    $c->stash( template => 'applications/edit.tt2' );
}

=head2 edit

Edit an application

=cut

sub edit : Chained('object') : PathPart('edit') : Args(0) : FormConfig() {
    my ( $self, $c ) = @_;
    $c->detach('/error_noperms')
        unless $c->stash->{object}->edit_allowed_by( $c->user->get_object );

    my $application = $c->stash->{object};
    unless ($application) {
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                {   mid => $c->set_error_msg(
                        "Invalid application -- Cannot edit")
                }
            )
        );
        $c->detach;
    }
    my $form = $c->stash->{form};
    if ( $form->submitted_and_valid ) {
        $application->update(
            {   name        => $c->request->params->{application_name},
                description => $c->request->params->{application_description},
            }
        );
        $c->response->redirect(
            $c->uri_for(
                $self->action_for('list'),
                { mid => $c->set_status_msg("Application updated") }
            )
        );
        $c->detach;
    }
    else {
        my $name = $form->get_element( { name => 'application_name' } );
        $name->value( $application->name );
        my $description =
            $form->get_element( { name => 'application_description' } );
        $description->value( $application->description );
        $c->stash( application => $application );

    }
    $c->stash( template => 'applications/edit.tt2' );
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
